```
## grep -r "((" ./cf.yml | awk '{print $3}'

# blank
#((cloud_controller_encrypt_key.secret)) 
#((properties_credhub_hsm_provider_client_certificate.cert_pem))
#((properties_credhub_hsm_provider_client_certificate.private_key_pem))
#((properties_credhub_hsm_provider_partition_password.secret))

#((properties_credhub_key_encryption_passwords_0_key.secret)) -> ((properties_credhub_key_encryption_passwords_0_key))
credhub generate -n /concourse/dev-1/properties_credhub_key_encryption_passwords_0_key -t password -l 20


# 
#((properties_networking_poe_ssl_certs_0_certificate.cert_pem)) => ((properties_networking_poe_ssl_certs_0_certificate.certificate))
#((properties_networking_poe_ssl_certs_0_certificate.private_key_pem)) => ((properties_networking_poe_ssl_certs_0_certificate.private_key))
credhub set -n /concourse/dev-1/properties_networking_poe_ssl_certs_0_certificate  -t certificate -c domain.crt -p domain.key


# blank
#((properties_nfs_volume_driver_enable_ldap_service_account_password.secret))

# blank
#((properties_smtp_credentials.identity))
#((properties_smtp_credentials.password))

#((uaa_service_provider_key_credentials.cert_pem)) => ((properties_networking_poe_ssl_certs_0_certificate.certificate))
#((uaa_service_provider_key_credentials.private_key_pem)) => ((properties_networking_poe_ssl_certs_0_certificate.private_key))


#((uaa_service_provider_key_password.secret)) => ((uaa_service_provider_key_password))
credhub set -n /concourse/dev-1/uaa_service_provider_key_password -t password --password="xxxxxx"
```