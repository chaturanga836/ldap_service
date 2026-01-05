FROM osixia/openldap:1.5.0

# 1. Copy LDIF
COPY ./ldap/bootstrap.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom/50-bootstrap.ldif

# 2. Copy Certs (Note: we use the names the image expects by default or define them below)
COPY ./ldap/certs/tls.crt /container/service/slapd/assets/certs/tls.crt
COPY ./ldap/certs/tls.key /container/service/slapd/assets/certs/tls.key
COPY ./ldap/certs/tls.crt /container/service/slapd/assets/certs/ca.crt

RUN chown -R 911:911 /container/service/slapd/assets/certs && \
    chmod 600 /container/service/slapd/assets/certs/tls.key && \
    chown -R 911:911 /container/service/slapd/assets/config/bootstrap/ldif/custom

# 4. Explicit Environment Variables
ENV LDAP_TLS=true
ENV LDAP_TLS_CRT_FILENAME=tls.crt
ENV LDAP_TLS_KEY_FILENAME=tls.key
ENV LDAP_TLS_CA_CRT_FILENAME=ca.crt
# This prevents the container from trying to verify its own cert against a CA it doesn't have yet
ENV LDAP_TLS_VERIFY_CLIENT=never