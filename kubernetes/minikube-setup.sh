echo -e "\n Initializing Kubernetes cluster...\n"
minikube start --cpus 4 --memory 6g --driver docker --profile crewcash

echo -e "\n Enabling NGINX Ingress Controller...\n"
minikube addons enable ingress --profile crewcash

# minikube tunnel --profile crewcash &