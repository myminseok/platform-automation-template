```
## grep -r "((" ./director.yml | awk '{print $3}'

## replase to real value

((iaas-configurations_0_bosh_disk_path))
((iaas-configurations_0_bosh_template_folder))
((iaas-configurations_0_bosh_vm_folder))
((iaas-configurations_0_datacenter))
((iaas-configurations_0_disk_type))
((iaas-configurations_0_ephemeral_datastores_string))
((iaas-configurations_0_name))
((iaas-configurations_0_nsx_networking_enabled)) -> false
((iaas-configurations_0_persistent_datastores_string))
((iaas-configurations_0_ssl_verification_enabled)) -> false
((iaas-configurations_0_vcenter_host))

((iaas-configurations_0_vcenter_password))
-> credhub set -n /concourse/dev-1/iaas-configurations_0_vcenter_password -t password --password="xxxxxx"

((iaas-configurations_0_vcenter_username))
-> credhub set -n /concourse/dev-1/iaas-configurations_0_vcenter_username -t value -v "xxxxxx"

((properties-configuration_security_configuration_generate_vm_passwords)) -> true

properties-configuration.security_configuration.trusted_certificates
=> 
1. save to domain.cert: printf -- "-----BEGIN CERTIFICATE-----\r\nMIIDAz xxx ==\r\n-----END CERTIFICATE-----" > domain.cert
2. credhub set -n /concourse/dev-1/properties-configuration_security_configuration_trusted_certificates  -t certificate -c domain.crt
==> replace to placeholder: ((properties-configuration_security_configuration_trusted_certificates))

## replace as following:

    #encryption: []
    encryption:
      keys: []
      providers: []

  #   dns_configuration: []
  dns_configuration:
    excluded_recursors: []
    handlers: []


```