

_nexusRoute=$(oc get routes --no-headers=true | grep nexus-tssc | awk '{ print $2 }')
_nexusREPO=$(oc get routes --no-headers=true | grep repo-nexus | awk '{ print $2 }')

echo "Nexus Route: $_nexusRoute"
_nexusURL=https://$_nexusRoute
echo "Nexus admin: $_nexusURL"
echo "Nexus repo: $_nexusREPO"

echo "DELETE existing Script if present"
curl  -X DELETE -u admin:admin123 -k --header 'Accept: application/json' $_nexusURL/service/siesta/rest/v1/script/tssc-docker-repo

echo "Upload  Docker Repo Script"
curl -vk -X POST -u admin:admin123 --header "Content-Type: application/json"  $_nexusURL/service/siesta/rest/v1/script -d @rest-config/tssc-docker-repo.json

echo "Run the Docker Repo Script"
curl -X POST -k  -u admin:admin123 --header 'Content-Type: text/plain' --header 'Accept: application/json' $_nexusURL/service/siesta/rest/v1/script/tssc-docker-repo/run

echo "DELETE existing Helm Script if present"
curl  -X DELETE -u admin:admin123 -k --header 'Accept: application/json' $_nexusURL/service/siesta/rest/v1/script/tssc-helm-repo

echo "Upload Helm Repo Script"
curl -vk -X POST -u admin:admin123 --header "Content-Type: application/json"  $_nexusURL/service/siesta/rest/v1/script -d @rest-config/tssc-helm-repo.json

echo "Run the Helm Repo Script"
curl -X POST -k  -u admin:admin123 --header 'Content-Type: text/plain' --header 'Accept: application/json' $_nexusURL/service/siesta/rest/v1/script/tssc-helm-repo/run


##echo "Restarting Jenkins"
##oc delete pods  $(oc get pods --no-headers=true | grep jenkins | awk '{ print $1 }')

echo "Uploading Helm Chart to Nexus"
git clone https://github.com/redhat-mal/tssc-pipelines.git
helm package ./tssc-pipelines/helm/deployments/
curl -vk -u admin:admin123 --upload-file deployments-0.1.0.tgz  $_nexusURL/repository/helm/deployments-0.1.0.tgz
rm -rf tssc-pipelines

