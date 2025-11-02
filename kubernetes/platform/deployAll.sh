echo "\n Initializing Kubernetes cluster...\n"
minikube start --cpus 2 --memory 4g --driver docker --profile crewcash

echo "\n Enabling NGINX Ingress Controller...\n"
minikube addons enable ingress --profile crewcash

./ingress-nginx/deploy.sh
./redis/deploy.sh
./postgres/deploy.sh
./rabbitmq/deploy.sh
./keycloak/deploy.sh
./argocd/deploy.sh

SERVICE_NAME="crewcash-keycloak"
NAMESPACE="keycloak-system"
external_ip=$(kubectl get service "$SERVICE_NAME" -n "$NAMESPACE" --no-headers -o custom-columns=":status.loadBalancer.ingress[0].ip")
./keycloak/create-secrets.sh "http://$external_ip/realms/CrewCash"

argocd_server_ip=$(kubectl -n argocd get service argocd-server -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
argocd_server_port=$(kubectl -n argocd get service argocd-server -o jsonpath="{.spec.ports[0].port}")

./argocd/configure.sh

echo "\n Kubernetes cluster has been successfully initialized."
echo "\n You can access the services using the following URLs:"
echo " - Argo CD: http://$argocd_server_ip:$argocd_server_port"
echo " - Keycloak: http://$external_ip/realms/CrewCash"
echo " - Keycloak: http://$external_ip/admin"

