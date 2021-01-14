#!/bin/bash
# This script needs bash4 or above

if [[ ! -v 'TLD' ]]; then
    echo "TLD is empty or undefined. Please set \$TLD as the top level domain"
    exit 1
fi

if aws route53 list-hosted-zones > /dev/null; then
    echo "Connection to AWS route 53 succeded"
else
    echo "Connection to AWS route 53 failed. Please ensure AWS credentials are in place"
    exit 1
fi

mkdir -p $TLD

certbot certonly \
      --test-cert \
      --dns-route53 -d *.$TLD \
      --config-dir ~/$TLD \
      --work-dir ~/$TLD \
      --logs-dir ~/$TLD \
      -m andrew.holway@guest.hpi.de \
      --agree-tos -n 

kubectl create secret tls wildcard-${TLD/./-} \
      --key ~/$TLD/live/$TLD/privkey.pem \
      --cert ~/$TLD/live/$TLD/fullchain.pem  
