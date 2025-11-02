### configuring ArgoCD to manage the CrewCash applications
argocd_admin_password=$(kubectl -n argocd get secret argocd-initial-admin-secret \
 -o jsonpath="{.data.password}" | base64 -d; echo)

# retrieve argocd public ip
argocd_server_ip=$(kubectl -n argocd get service argocd-server -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
argocd login "$argocd_server_ip" --username admin --password "$argocd_admin_password" --insecure

argocd app create wallet-service \
 --repo \
 https://github.com/CrewCash/crewcash-deployment.git \
 --path kubernetes/applications/wallet-service/ \
  --dest-server https://kubernetes.default.svc \
 --dest-namespace default \
 --sync-policy auto \
 --auto-prune

argocd app create payment-service \
 --repo \
 https://github.com/CrewCash/crewcash-deployment.git \
 --path kubernetes/applications/payment-service/ \
  --dest-server https://kubernetes.default.svc \
 --dest-namespace default \
 --sync-policy auto \
 --auto-prune

argocd app create sharing-service \
 --repo \
 https://github.com/CrewCash/crewcash-deployment.git \
 --path kubernetes/applications/sharing-service/ \
  --dest-server https://kubernetes.default.svc \
 --dest-namespace default \
 --sync-policy auto \
 --auto-prune

argocd app create notification-service \
 --repo \
 https://github.com/CrewCash/crewcash-deployment.git \
 --path kubernetes/applications/notification-service/ \
  --dest-server https://kubernetes.default.svc \
 --dest-namespace default \
 --sync-policy auto \
 --auto-prune

argocd app create edge-service \
 --repo \
 https://github.com/CrewCash/crewcash-deployment.git \
 --path kubernetes/applications/edge-service/ \
  --dest-server https://kubernetes.default.svc \
 --dest-namespace default \
 --sync-policy auto \
 --auto-prune

argocd app create budeget-service \
 --repo \
 https://github.com/CrewCash/crewcash-deployment.git \
 --path kubernetes/applications/budget-service/ \
  --dest-server https://kubernetes.default.svc \
 --dest-namespace default \
 --sync-policy auto \
 --auto-prune