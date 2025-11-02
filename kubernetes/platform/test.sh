echo "\n Initializing Kubernetes cluster...\n"

minikube start --cpus 2 --memory 4g --driver docker --profile crewcash

echo "\n Enabling NGINX Ingress Controller...\n"

minikube addons enable ingress --profile crewcash