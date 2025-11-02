echo -e "\n Initializing Kubernetes cluster...\n"
minikube start --cpus 2 --memory 4g --driver docker --profile crewcash

echo -e "\n Enabling NGINX Ingress Controller...\n"
minikube addons enable ingress --profile crewcash

minikube tunnel --profile crewcash &