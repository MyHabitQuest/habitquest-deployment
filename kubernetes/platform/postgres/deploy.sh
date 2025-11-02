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

echo "\n PostgreSQL has been successfully deployed."
echo "\n Generating Secrets with PostgreSQL credentials."

kubectl -n "$NAMESPACE" delete secret crewcash-postgres-wallet-credentials --ignore-not-found=true
kubectl -n "$NAMESPACE" create secret generic crewcash-postgres-wallet-credentials \
  --from-literal=spring.datasource.url=jdbc:postgresql://crewcash-postgres:5432/crewcashdb_wallet \
  --from-literal=spring.datasource.username=user \
  --from-literal=spring.datasource.password=password

kubectl -n "$NAMESPACE" delete secret crewcash-postgres-sharing-credentials --ignore-not-found=true
kubectl -n "$NAMESPACE" create secret generic crewcash-postgres-sharing-credentials \
  --from-literal=spring.datasource.url=jdbc:postgresql://crewcash-postgres:5432/crewcashdb_sharing \
  --from-literal=spring.datasource.username=user \
  --from-literal=spring.datasource.password=password

kubectl -n "$NAMESPACE" delete secret crewcash-postgres-payment-credentials --ignore-not-found=true
kubectl -n "$NAMESPACE" create secret generic crewcash-postgres-payment-credentials \
  --from-literal=spring.datasource.url=jdbc:postgresql://crewcash-postgres:5432/crewcashdb_payment \
  --from-literal=spring.datasource.username=user \
  --from-literal=spring.datasource.password=password