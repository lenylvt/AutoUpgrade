# run_admin.ps1
# Script complet : admin + création venv + activation + pyautogui + run.py

# --- [1] Vérifier si on est admin ---
$IsAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent() `
   ).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "Relance en mode Administrateur..."
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# --- [2] Aller dans le dossier du script ---
Set-Location -Path $PSScriptRoot

# --- [3] Créer le venv s’il n’existe pas ---
if (-not (Test-Path ".\venv")) {
    Write-Host "Aucun venv trouvé → création en cours..."
    python -m venv venv
}

# --- [4] Activer le venv ---
. .\venv\Scripts\Activate.ps1

# --- [5] Vérifier si pyautogui est installé ---
$check = python -c "import importlib.util; print(importlib.util.find_spec('pyautogui') is not None)" 2>$null

if ($check -eq "False") {
    Write-Host "pyautogui non trouvé → installation..."
    python -m pip install --upgrade pip
    python -m pip install pyautogui
} else {
    Write-Host "pyautogui déjà installé."
}

# --- [6] Lancer ton script ---
Write-Host "Lancement de run.py..."
python run.py

Write-Host "`nExécution terminée ✅"
Pause
