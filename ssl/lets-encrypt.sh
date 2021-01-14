#!/bin/bash
# This script needs bash4 or above

if [[ ! -v 'TLD' ]]; then
    echo "var TLD is empty or undefined. Please set \$TLD as the top level domain"
    exit 1
fi

if [[ ! -v 'NAMESPACE' ]]; then
    echo "var NAMESPACE is empty or undefined. Please set \$NAMESPACE so I know which k8s namespace to place the cert in."
    exit 1
fi

if aws route53 list-hosted-zones > /dev/null; then
    echo "Connection to AWS route 53 succeded"
else
    echo "Connection to AWS route 53 failed. Please ensure AWS credentials are in place"
    exit 1
fi

mkdir -p $TLD

if [[ ! -v 'NAMESPACE' ]]; then
    echo "var NAMESPACE is empty or undefined. Please set \$NAMESPACE so I know which k8s namespace to place the cert in."
    exit 1
fi

# create fake cert if --fake flag is passed.
if [[ $* == *--fake ]]; then	
certbot certonly \
      --test-cert \
      --dns-route53 -d *.$TLD \
      --config-dir ~/$TLD \
      --work-dir ~/$TLD \
      --logs-dir ~/$TLD \
      -m andrew.holway@guest.hpi.de \
      --agree-tos -n 

# create real cert if --real flag is passed.
elif [[ $* == *--real ]]; then
certbot certonly \
      --dns-route53 -d *.$TLD \
      --config-dir ~/$TLD \
      --work-dir ~/$TLD \
      --logs-dir ~/$TLD \
      -m andrew.holway@guest.hpi.de \
      --agree-tos -n 
else
echo "You need to choose between a fake or real ssl cert. Please pass --fake or --real flags"
exit 1
fi

kubectl create secret tls wildcard-${TLD/./-} \
      --key ~/$TLD/live/$TLD/privkey.pem \
      --cert ~/$TLD/live/$TLD/fullchain.pem \
      -n $NAMESPACE
