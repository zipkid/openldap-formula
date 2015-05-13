# openldap-formula

Pillar config

```yaml
ldap:
  config:
    connection: ldap://localhost:389
    dc_name: <domain>
    domain: <domain>.<ext>
    base: dc=<domain>,dc=<ext>
    root_user: cn=ldap_admin
    pwd_salt: <salt>
    root_pwd: <pwd>
```
