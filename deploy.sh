# Install and configure aws cli
cd terraform
terraform init
terraform apply --auto-approve
cd ..
aws eks update-kubeconfig --region us-east-1 --name openwebui-ollama-eks
kubectl apply -f .\k8s\ollama.yaml -f .\k8s\webui.yaml
kubectl get all
