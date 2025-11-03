kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode

# adjust namespace and secret name if different (here: keycloak-system and crewcash-keycloak)
kubectl -n keycloak-system get secret crewcash-keycloak -o jsonpath="{.data.admin-user}" | base64 --decode
kubectl -n keycloak-system get secret crewcash-keycloak -o jsonpath="{.data.admin-password}" | base64 --decode