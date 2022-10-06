#!/bin/bash -x 

apps=('homeoffice-backend' 'homeoffice-ingress' 'quarkuscoffeeshop-barista' 'quarkuscoffeeshop-counter' 'quarkuscoffeeshop-counter' 'quarkuscoffeeshop-customermocker' 'quarkuscoffeeshop-homeoffice-ui' 'quarkuscoffeeshop-inventory' 'quarkuscoffeeshop-kitchen' 'quarkuscoffeeshop-majestic-monolith' 'quarkuscoffeeshop-web')
namespace='quarkuscoffeeshop-cicd'

for app in ${apps[@]}; do
    pipeline="build-and-push-$app"
    mavenpvc="$app-maven-settings-pvc"
    workspacepvc="$app-shared-workspace-pvc"
    gitresource="$app-git"
    imageresource="$app-image"
    tkn pipeline start $pipeline -n $namespace \
        --resource 'app-git'="$gitresource" \
        --resource image="$imageresource" \
        --workspace name='shared-workspace',claimName="$workspacepvc" \
        --workspace name='maven-settings',claimName="$mavenpvc" \
        --use-param-defaults
done
