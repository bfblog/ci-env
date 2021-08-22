
ipconfig.exe /flushdns

SET SCRIPT_DIR=%~dp0

REM install nginx ingress controller
kubectl.exe apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.48.1/deploy/static/provider/cloud/deploy.yaml
kubectl.exe wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s

REM install cert-manager
kubectl.exe apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.yaml

REM install argocd
kubectl.exe create namespace argocd
kubectl.exe apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl.exe apply -n argocd -f %SCRIPT_DIR%\kubernetes\argocd\argocd-ingress.yaml

REM install tekton
kubectl.exe apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
kubectl.exe apply --filename https://github.com/tektoncd/dashboard/releases/latest/download/tekton-dashboard-release.yaml
kubectl.exe apply --filename kubernetes/tekton-pipelines/tekton-dashboard-ingress.yaml

REM show argocd-password
kubectl.exe -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d


