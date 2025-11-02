echo "\n Deploying PostgreSQL..."

kubectl apply -f resources/postgresql.yml

sleep 5

echo "\n Waiting for PostgreSQL to be deployed..."

while [ $(kubectl get pod -l db=crewcash-postgres | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n Waiting for PostgreSQL to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=crewcash-postgres \
  --timeout=180s