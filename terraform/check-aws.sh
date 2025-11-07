# check aws login
aws sts get-caller-identity

# get eks access
aws eks update-kubeconfig --region <region> --name <cluster-name>