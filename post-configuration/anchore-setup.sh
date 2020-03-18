

_anchoreRoute=$(oc get routes --no-headers=true | grep anchore-engine-api | awk '{ print $2 }')
_nexusREPO=$(oc get routes --no-headers=true | grep repo-nexus | awk '{ print $2 }')

echo "Anchore Route: $_anchoreRoute"
_anchoreURL=http://$_anchoreRoute
echo "Anchore admin: $_anchoreURL"
echo "Nexus repo: $_nexusREPO"

echo "DELETE existing registry present"
curl  -X DELETE -u admin:anchore --header 'Accept: application/json' $_anchoreURL/v1/registries/$_nexusREPO

echo "Add Nexus Registry"
curl -X POST  -u admin:anchore --header "Content-Type: application/json" $_anchoreURL/v1/registries -d @rest-config/anchore-add-reg.json


echo "DELETE existing policy if present"
curl  -X DELETE -u admin:anchore --header 'Accept: application/json' $_anchoreURL/v1/policies/tssc_default_bundle

echo "Add TSSC Default Policy"
curl -X POST  -u admin:anchore --header "Content-Type: application/json" $_anchoreURL/v1/policies -d @rest-config/anchore-policy.json

oc exec $(oc get pods --no-headers=true | grep engine-api | awk '{ print $1 }') anchore-cli policy activate tssc_default_bundle


