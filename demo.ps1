# === Demo End-to-End: Estado de la app ===
Write-Host "=== Demo End-to-End: Estado de la app ===`n"

# --- Paso 1: Estado del Deployment principal ---
Write-Host "Deployment en Kubernetes:"
$deploy = kubectl get deploy final-app -n default -o json | ConvertFrom-Json

$desired = $deploy.spec.replicas
$available = $deploy.status.availableReplicas
if ($available -eq $desired) {
    Write-Host "Replicas disponibles: ${available}/${desired}" -ForegroundColor Green
} else {
    Write-Host "Replicas disponibles: ${available}/${desired}" -ForegroundColor Red
}
Write-Host "`n"

# --- Paso 2: Estado de los Pods ---
Write-Host "Pods actuales:"
$pods = kubectl get pods -n default -o json | ConvertFrom-Json
foreach ($p in $pods.items) {
    $name = $p.metadata.name
    $status = $p.status.phase
    $image = $p.spec.containers[0].image
    if ($status -eq "Running") {
        Write-Host "${name}  |  ${status}  |  ${image}" -ForegroundColor Green
    } else {
        Write-Host "${name}  |  ${status}  |  ${image}" -ForegroundColor Red
    }
}
Write-Host "`n"

# --- Paso 3: Estado de los Deployments de ArgoCD (sin CLI) ---
Write-Host "Estado de la app en ArgoCD (por deployments):"
$argocd_deploy = kubectl get deploy -n argocd -o json | ConvertFrom-Json
foreach ($d in $argocd_deploy.items) {
    $name = $d.metadata.name
    $available = $d.status.availableReplicas
    $desired = $d.spec.replicas
    if ($available -eq $desired) {
        Write-Host "Deployment ${name}: ${available}/${desired} replicas" -ForegroundColor Green
    } else {
        Write-Host "Deployment ${name}: ${available}/${desired} replicas" -ForegroundColor Red
    }
}
Write-Host "`n"

# --- Paso 4: Mensaje final ---
Write-Host "Demo finalizada: verifica que todos los deployments y pods estén Healthy." -ForegroundColor Cyan

