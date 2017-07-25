#!/bin/bash


# download CloudFlare SSL binaries if needed

CFSSL='cfssl'
hash $CFSSL || {
  curl -L -o cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  && chmod +x cfssl \
  && CFSSL='./cfssl'
}

CFSSLJSON='cfssljson'
hash $CFSSLJSON || {
  curl -L -o cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 \
  && chmod +x cfssljson \
  && CFSSLJSON='./cfssljson'
}


# setup CA

cat > ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "server": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > ca-csr.json << EOF
{
  "CN": "Vagrant CA",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "O": "Vagrant",
      "OU": "Infrastructure"
    }
  ]
}
EOF

$CFSSL gencert -initca ca-csr.json | $CFSSLJSON -bare ca


# setup keypairs for each node

for node in balancer-1 web-1 web-2; do

cat > "$node-csr.json" << EOF
{
  "CN": "$node",
  "hosts": [
    "$node"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "O": "Vagrant",
      "OU": "Infrastructure"
    }
  ]
}
EOF

$CFSSL gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=server \
  "$node-csr.json" \
| $CFSSLJSON -bare "$node"

done
