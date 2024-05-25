import os
import json
from datetime import datetime
import requests
from netaddr import *
from tetpyclient import RestClient
from dotenv import load_dotenv
import urllib3

urllib3.disable_warnings()

load_dotenv()

API_ENDPOINT=os.getenv('TET_URL')
scanner_type = os.getenv('KENNA_SCANNER')
kenna_token = os.getenv('KENNA_TOKEN')
kenna_base_url=os.getenv('KENNA_URL')
kenna_connector_id = os.getenv('KENNA_CONNECTOR_ID')

restclient = RestClient(API_ENDPOINT, credentials_file=os.getenv('API_CREDENTIALS_FILE'), verify=False)

def kenna_file_upload(t,c,u,fn,):

    files = {
    'file': json.dumps(fn)
    }

    header = {
    'accept': 'application/json',   
    'X-Risk-Token': t,
    }

    #### Changes
    ##payload = {
    ##'run': 'true'
    ##}
    ####
    url = f"{u}/connectors/{c}/data_file"

    r = requests.post(url, headers=header, files=files)
    return r.json()

def kenna_run_connector (t,c,u):
    
    header = {
    'X-Risk-Token': t,
    }

#    url = f"{u}/connectors/{c}/run?data_files[]={fid}"
    url = f"{u}/connectors/{c}/run"
    r = requests.get(url, headers=header)
    return (r.json())

def kenna_connector_status (t,c,u,cid):
    
    header = {
    'accept': 'application/json',
    'X-Risk-Token': t,
    }

    url = f"{u}/connectors/{c}/connector_runs/{cid}"

    r = requests.get(url, headers=header)
    return (r.json())
    
def kenna_list_connectors(t,u):
    headers = {
        'Accept': 'application/json',
        'X-Risk-Token': t
        }
    r = (requests.get(u + '/connectors', headers=headers))
    if r.status_code == 200:
        return r.json()
    else:
        return (r.text)

def kenna_get_connector_runs(t,u,i):
    headers = {
        'Accept': 'application/json',
        'X-Risk-Token': t
        }
    r = (requests.get(u + '/connectors/'+i+'/connector_runs', headers=headers))
    if r.status_code == 200:
        return r.json()
    else:
        return (r.text)
       
def CreateJsonFile(s_list,f_name):
    print ("creating {}.json export file".format(f_name))
    with open('{}.json'.format(f_name), 'w') as f:
            json.dump(s_list, f)
    return

def collect_asset_info(rc):
    failed_count=0
    successful_count=0
    #Grab sensors, and put UUID's in a list
    resp = rc.get('/sensors')
    #Turn Response into python list
    r_status=resp.status_code
    if r_status !=200:
        resp.raise_for_status()
    sensor_resp = resp.json()
    asset_list=[]
    #CREATE A LIST OF UUID'S THAT WE CAN ITERATE OVER FOR INFORMATION
    CreateJsonFile(sensor_resp["results"],'sensor_list') # json file of sensors - debugging
    for sensor in sensor_resp["results"]:
        # Check to see if agent is host based
        if (sensor['agent_type_str'] != 'ENFORCER') and (sensor['agent_type_str'] != 'SENSOR'): 
            print ('sensor',sensor['host_name'],'is not a supported agent type')
            failed_count = failed_count+1
            continue  
        #Check to see if agent is inactive
        if ((datetime.now() - datetime.fromtimestamp(sensor['last_config_fetch_at'])).days > 0):
            print ('sensor',sensor['host_name'],'has an inactive agent')
            failed_count= failed_count+1
            continue
        #Check to see if agent as been deleted
        if ('deleted_at' in sensor):
            print ('sensor',sensor['host_name'],'with UUID:', sensor['uuid'],'has been deleted')
            continue
        #Logic to pull best interface IP from Sensor in CSW
        for int in sensor['interfaces']:
            if IPAddress(int['ip']).is_private() and int['family_type'] == "IPV4" and (int['name'] != 'tunl0' and int['name'] != 'docker0' and int['name'] != 'vxlan.calico'): 
                interface_ip = int['ip']
        asset = {}
        asset =  {'uuid': sensor['uuid'],
                    'hostname': sensor['host_name'],
                    'os': sensor['platform'],
                    'kernel_version': sensor['kernel_version'],
                    'ip': interface_ip  }
        
        asset_list.append(asset)
        successful_count= successful_count+1

    print ('total list from sensor API:', len(sensor_resp["results"]))
    print('failed count:',failed_count)
    print('successful count:',successful_count)
    return asset_list

def collect_workload_info (rc, st, uuid):
        resp = rc.get('/workload/'+ uuid + '/vulnerabilities')
        r_status=resp.status_code
        temp_vulndef_list = []
        v_list = []
        f_list = []
        if r_status == 200:
            parsed_resp = resp.json()

            #FORMATTING ALL OF THE DATA...because our API SUCKS
            for package in parsed_resp:
                vdef = {}
                v = {}
                f = {}
                #PICKING OUT THE CVE ID AND URL
                vdef['scanner_type'] = st
                vdef['cve_identifiers'] = package['cve_id']
                vdef['name'] = package['cve_id']
                temp_vulndef_list.append (vdef)

                v['scanner_identifier']= package['cve_id']
                v['scanner_type'] = st

                try:
                    v['scanner_score'] = int(package['v3_score'])
                except KeyError:
                    v['scanner_score'] = int(package['v2_score'])
                v['last_seen_at'] = datetime.now().isoformat()
                v['status'] = 'open'
                v['vuln_def_name'] = package['cve_id']
                v_list.append(v)

                f['scanner_identifier']= uuid + '-' + package['cve_id']
                f['scanner_type'] = st               
                f['last_seen_at'] = datetime.now().isoformat()
                f['vuln_def_name'] = package['cve_id']
                f_list.append(f)
            return temp_vulndef_list, v_list, f_list
        else:
            print ('Vulnerabilities are not available for UUID:', uuid)

#BOILERPLATE
if __name__ == "__main__":

    #Build a list of workloads to pull vulnerabily information in CSW
    workloads = collect_asset_info(restclient)
    CreateJsonFile (workloads,'workload_list')  #Json file of workload list - debugging


    assets = []
    vuln_def = []
    for each in workloads:
        v_def, vuln, findings = collect_workload_info(restclient, scanner_type, each['uuid'])
        print (each['hostname'], 'has', len(vuln), 'vulnerabilities')
        temp_asset = {}
        temp_asset['hostname'] = each['hostname']
        temp_asset['os'] = each['os']
        temp_asset['os_version'] = each['kernel_version']
        temp_asset['ip_address'] = each['ip']
        temp_asset['tags'] = ['csw']
        temp_asset['vulns'] = vuln
        temp_asset['findings'] = findings
        assets.append(temp_asset)
        for item in v_def:
            if item['name'] not in vuln_def:
                vuln_def.append(item)

    print ('Kenna upload list has', len(vuln_def), 'vulnerability definitions ')
    print (len(assets))
    kenna_upload = {'skip_autoclose': False,
                     'version': 2,
                      'assets': assets,
                      'vuln_defs': vuln_def}
    CreateJsonFile(kenna_upload, 'kenna_csw')
    u_resp =  (kenna_file_upload(kenna_token,kenna_connector_id,kenna_base_url,kenna_upload))
    if u_resp['success']:
    #    print ("----------------------")
    #    print (kenna_base_url)
    #    print ("----------------------")
    #    print (u_resp)
    #    print ("----------------------")
    #    print (kenna_connector_id)
    #    print (kenna_token)
        print ('File uploaded succeeded to emeatest Tenant, datafile id =', u_resp['data_file'])
      #  r_resp = (kenna_run_connector(kenna_token,kenna_connector_id,kenna_base_url,u_resp['data_file']))
        r_resp = (kenna_run_connector(kenna_token,kenna_connector_id,kenna_base_url))
        if r_resp['success']:
            run_id = r_resp['connector_run_id']
        print ("Upload completed, import triggered. go to 'https://emeatest.eu.kennasecurity.com/connectors/132977' to check the state")
    #    print (run_id)

    else:
        print ('File uploaded failed')