
SET SCRIPT_DIR=%~dp0

REM create namespace argocd
kubectl.exe create namespace argocd

REM install argocd from git repository
#kubectl.exe apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl.exe apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.1.0-rc3/manifests/install.yaml

REM patch service to type LoadBalancer
kubectl.exe patch svc argocd-server -n argocd -p "{\"spec\":{\"type\":\"LoadBalancer\"}}"

REM install ingress 
kubectl.exe apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.46.0/deploy/static/provider/cloud/deploy.yaml
kubectl.exe wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s

REM install cert-manager
kubectl.exe apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.yaml
kubectl.exe apply -f %SCRIPT_DIR%\..\kubernetes\argocd

REM show argocd-password
kubectl.exe -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d


