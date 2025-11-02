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
./keycloak/create-secrets.sh " http://$external_ip/realms/CrewCash"