#!/bin/bash -x

if [ -z "$1" ]; then
    ENDPOINT="quarkuscoffeeshop-customermocker-coffeeshop-store.$(oc get ingresses.config/cluster -o jsonpath={.spec.domain})"
else
    ENDPOINT="$1"
fi

id=$(uuid)
body=$(cat <<EOF
{}
EOF
)

curl  --request POST http://$ENDPOINT/api/start \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
-d "$body"

#curl  --request POST http://$ENDPOINT/api/start \
#--header 'Content-Type: application/json' \
#--header 'Accept: application/json' \
#-d "$body"
