#!/usr/bin/env python3
"""
Generate self-signed certificates for LDAP server
"""
from cryptography import x509
from cryptography.x509.oid import NameOID
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from datetime import datetime, timedelta
import os

# Create certs directory if it doesn't exist
os.makedirs('ldap/certs', exist_ok=True)

# Generate private key
private_key = rsa.generate_private_key(
    public_exponent=65537,
    key_size=2048,
    backend=default_backend()
)

# Create certificate
subject = issuer = x509.Name([
    x509.NameAttribute(NameOID.COMMON_NAME, u"ldap-server"),
])

cert = x509.CertificateBuilder().subject_name(
    subject
).issuer_name(
    issuer
).public_key(
    private_key.public_key()
).serial_number(
    x509.random_serial_number()
).not_valid_before(
    datetime.utcnow()
).not_valid_after(
    datetime.utcnow() + timedelta(days=365)
).add_extension(
    x509.SubjectAlternativeName([
        x509.DNSName(u"ldap-server"),
        x509.DNSName(u"localhost"),
    ]),
    critical=False,
).sign(private_key, hashes.SHA256(), default_backend())

# Write private key
with open('ldap/certs/ldap-server.key', 'wb') as f:
    f.write(private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.TraditionalOpenSSL,
        encryption_algorithm=serialization.NoEncryption()
    ))

# Write certificate
with open('ldap/certs/ldap-server.crt', 'wb') as f:
    f.write(cert.public_bytes(serialization.Encoding.PEM))

print("✓ Generated ldap/certs/ldap-server.crt")
print("✓ Generated ldap/certs/ldap-server.key")
