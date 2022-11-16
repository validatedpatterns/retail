#!/bin/bash -x

# Start all the pipelines in the extra subdir with correct paramaters. Requires only oc.
for plr in $(ls charts/hub/quarkuscoffeeshop-pipelines/extra/*.yaml); do
    oc create -f $plr
done
