echo "\n Deploying Redis..."

kubectl apply -f services/redis.yml

sleep 5

echo "\n Waiting for Redis to be deployed..."

while [ $(kubectl get pod -l db=crewcash-redis | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n Waiting for Redis to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=crewcash-redis \
  --timeout=180s