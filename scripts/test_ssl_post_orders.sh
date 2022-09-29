#!/bin/bash -x

if [ -z "$1" ]; then
    ENDPOINT="quarkuscoffeeshop-web-tls-coffeeshop-store.$(oc get ingresses.config/cluster -o jsonpath={.spec.domain})"
else
    ENDPOINT="$1"
fi

id=$(uuid)
body=$(cat <<EOF
{
    "id": "$id",
    "baristaItems": [
        {
            "item": "COFFEE_WITH_ROOM",
            "name": "Mickey"
        },
        {
            "item": "CAPPUCCINO",
            "name": "Minnie"
        }
    ],
    "kitchenItems": [
        {
            "item": "CAKEPOP",
            "name": "Mickey"
        },
        {
            "item": "CROISSANT",
            "name": "Minnie"
        }
    ],
    "storeId": "ATLANTA",
	"orderSource": "WEB",
	"rewardsId": "test-post@example.com"
}
EOF
)

echo $body | jq .

curl  -k --request POST https://$ENDPOINT/order \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
-d "$body"
