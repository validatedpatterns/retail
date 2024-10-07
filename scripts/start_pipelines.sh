#!/bin/bash

build_ns=quarkuscoffeeshop-cicd
pipelines=('build-and-push-quarkuscoffeeshop-barista' 'build-and-push-quarkuscoffeeshop-counter' 'build-and-push-quarkuscoffeeshop-customerloyalty' 'build-and-push-quarkuscoffeeshop-customermocker' 'build-and-push-quarkuscoffeeshop-inventory' 'build-and-push-quarkuscoffeeshop-kitchen' 'build-and-push-quarkuscoffeeshop-web')


MAX_ATTEMPTS=720
DELAY=5
ATTEMPT=1

while [ ${ATTEMPT} -le ${MAX_ATTEMPTS} ]; do
    OUT=$(oc get clustertasks 2>/dev/null | wc -l)
    if [ ${OUT} -gt 0 ]; then
        echo "ClusterTasks found"
        break
    else
        echo "ClusterTasks not found yet"
        if [ ${ATTEMPT} -ge ${MAX_ATTEMPTS} ]; then
            echo "Max attempts reached. Exiting."
            exit 1
        fi
        ATTEMPT=$((ATTEMPT + 1))
        sleep ${DELAY}
    fi
done

echo "Checking for resources to be available to start pipelines"
retry=0
MAX_ATTEMPTS=720
DELAY=5
ATTEMPT=0

while [ ${ATTEMPT} -le ${MAX_ATTEMPTS} ]; do
    sleep ${DELAY}
    if [ ${ATTEMPT} -ge ${MAX_ATTEMPTS} ]; then
        echo "Max attempts reached. Exiting."
        exit 1
    fi
    ATTEMPT=$((ATTEMPT + 1))

    for p in ${pipelines[@]}; do
        oc get -n $build_ns pipeline $p 1>/dev/null 2>/dev/null
        if [ "$?" != "0" ]; then
            echo "Error with pipeline $p, checking again"
            retry=1
            break
        fi
        retry=0
    done

    if [ "$retry" == "1" ]; then
        retry=0
        continue
    fi
    imageRegistryType=$(yq .global.imageregistry.type values-global.yaml)

    if [ $imageRegistryType == "openshift-internal" ]; then
        #No need to check secret if the image registry type is openshift-internal
        break
    fi
    oc get -n $build_ns secret quay-auth-secret 1>/dev/null 2>/dev/null
    if [ "$?" != "0" ]; then
        echo "Error with secret quay-auth-secret, checking again"
        continue
    fi

    # Everything checks out, time to leave this loop
    break
done

echo "Resources are all present, starting pipelines now"
# Start all the pipelines in the extra subdir with correct paramaters. Requires only oc.
for plr in $(ls charts/hub/quarkuscoffeeshop-pipelines/extra/*.yaml); do
    oc create -f $plr
done
