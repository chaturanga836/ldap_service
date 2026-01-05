FROM osixia/openldap:1.5.0

# Create the directory and copy your file
COPY ./ldap/bootstrap.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom/50-bootstrap.ldif

COPY ./ldap/certs/ldap.crt /container/service/slapd/assets/certs/ldap.crt
COPY ./ldap/certs/ldap.key /container/service/slapd/assets/certs/ldap.key
COPY ./ldap/certs/ldap.crt /container/service/slapd/assets/certs/ca.crt

# Crucial: Set ownership to 911 so the startup script is happy
RUN chown -R 911:911 /container/service/slapd/assets/config/bootstrap/ldif/custom
RUN chown -R 911:911 /container/service/slapd/assets/certs