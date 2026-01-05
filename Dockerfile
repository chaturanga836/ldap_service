FROM osixia/openldap:1.5.0

# 1. Copy LDIF
COPY ./ldap/bootstrap.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom/50-bootstrap.ldif

# 2. Copy Certs (Note: we use the names the image expects by default or define them below)
COPY ./ldap/certs/ldap.crt /container/service/slapd/assets/certs/ldap.crt
COPY ./ldap/certs/ldap.key /container/service/slapd/assets/certs/ldap.key
COPY ./ldap/certs/ldap.crt /container/service/slapd/assets/certs/ca.crt

# 3. Fix Permissions
RUN chown -R 911:911 /container/service/slapd/assets/certs && \
    chmod 600 /container/service/slapd/assets/certs/ldap.key && \
    chown -R 911:911 /container/service/slapd/assets/config/bootstrap/ldif/custom

# 4. Explicit Environment Variables
ENV LDAP_TLS=true
ENV LDAP_TLS_CRT_FILENAME=ldap.crt
ENV LDAP_TLS_KEY_FILENAME=ldap.key
ENV LDAP_TLS_CA_CRT_FILENAME=ca.crt
# This prevents the container from trying to verify its own cert against a CA it doesn't have yet
ENV LDAP_TLS_VERIFY_CLIENT=never