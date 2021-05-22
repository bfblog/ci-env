
SET SCRIPT_DIR=%~dp0

curl.exe https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml --output %SCRIPT_DIR%\..\kubernetes\tekton\tekton-dashboard.yaml
curl.exe https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml --output %SCRIPT_DIR%\..\kubernetes\tekton\tekton.yaml