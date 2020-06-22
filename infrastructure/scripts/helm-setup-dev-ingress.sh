NAME=jamie

#echo "Run Hello World App"
#cargo

echo "Apply Hello World Configs"
kubectl apply -f ../../hello-world/dev

#echo "Add Helm repos"
#helm repo add stable https://kubernetes-charts.storage.googleapis.com/
echo "Install Ingress"
helm install ingress stable/nginx-ingress

#echo "Install Ingress"
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud/deploy.yaml # version control
#kubectl apply -f ../environments/dev/k8s/ingress-template.yml

echo "Getting Ingress Controller Public IP..."
ingressPubIp=$(kubectl get services ingress-nginx-ingress-controller -o json | jq -r '.status.loadBalancer.ingress[0].ip')

echo "Waiting for Public IP to be defined (Usually takes 24 seconds or 12 attempts)"
while [ "$ingressPubIp" == "null" ]
do
  ingressPubIp=$(kubectl get services ingress-nginx-ingress-controller -o json | jq -r '.status.loadBalancer.ingress[0].ip')
   x=$(( $x + 1 ))
  echo "Attempt $x. Public IP is still $ingressPubIp"
  sleep 2
done

echo "Apply Ingress Config"
kubectl apply -f ../environments/dev/k8s/ingress-service.yml

#echo "Tidying up string containing IP..."
#ingressPubIp=$(echo $ingressPubIp | sed 's/"//g')
echo "Creating Querystring..."
ingressPubIpQuery="[?ipAddress=='"${ingressPubIp}"']"
echo "Getting IP ID from Azure..."
ingressIpId=$(
  az network public-ip list \
    --subscription 4a4be66c-9000-4906-8253-6a73f09f418d \
  --query "$(echo $ingressPubIpQuery)" | jq -r '.[0].id'
)
#
##az network public-ip show --ids $ingressIpId
echo "Assigning the DNS name to the Public IP"
az network public-ip update \
  --ids $ingressIpId \
  --dns-name $NAME-fnhs2

#echo $ingressIpId

echo "Done!!"
