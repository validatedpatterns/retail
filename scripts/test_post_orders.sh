#!/bin/bash

if [ -z "$1" ]; then
    ENDPOINT="quarkuscoffeeshop-web-coffeeshop-store.$(oc get ingresses.config/cluster -o jsonpath={.spec.domain})"
else
    ENDPOINT="$1"
fi

curl  --request POST http://$ENDPOINT/order \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
-d '{
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
}'
