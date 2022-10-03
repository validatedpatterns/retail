#!/bin/bash -x

if [ -z "$1" ]; then
    ENDPOINT="quarkuscoffeeshop-web-coffeeshop-store.$(oc get ingresses.config/cluster -o jsonpath={.spec.domain})"
else
    ENDPOINT="$1"
fi

id=$(uuid)
body=$(cat <<EOF
{
    "id": "$id",
    "commandType": "PLACE_ORDER",
    "orderSource": "WEB",
    "storeId": "ATLANTA",
    "rewardsId": "test@example.com",
    "kitchenItems": [
        { "name": "Tester", "item": "MUFFIN", "price": "3.55" }
    ],
    "baristaItems": [
        { "name": "Tester", "item": "COFFEE_BLACK", "price": "3.50" }
    ]
}
EOF
)

#echo "$body" | jq .

curl  --request POST http://$ENDPOINT/order \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
-d "$body"
