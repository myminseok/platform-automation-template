```
$ grep -r "((" ./pivotal-container-service.yml| awk '{print $3}'

## ((pivotal-container-service_pks_tls.cert_pem)) 
-> pivotal-container-service_pks_tls.certificate
## ((pivotal-container-service_pks_tls.private_key_pem)) 
-> pivotal-container-service_pks_tls.private_key
credhub set -n /concourse/pcfdemo/pivotal-container-service_pks_tls  -t certificate -c domain.crt -p domain.key

##((properties_cloud_provider_vsphere_vcenter_master_creds.identity))
-> properties_cloud_provider_vsphere_vcenter_master_creds.username
##((properties_cloud_provider_vsphere_vcenter_master_creds.password))
credhub set -n /concourse/pcfdemo/properties_cloud_provider_vsphere_vcenter_master_creds -t user -z your-user -w "your-password"


```