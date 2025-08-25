# run_admin.ps1
# Vérifie si lancé en admin, sinon se relance en admin
# Active le venv, check pyautogui, installe si besoin, lance run.py

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

# --- [3] Activer le venv (Windows style) ---
. .\venv\Scripts\Activate.ps1

# --- [4] Vérifier si pyautogui est installé ---
$check = python -c "import importlib.util; print(importlib.util.find_spec('pyautogui') is not None)" 2>$null

if ($check -eq "False") {
    Write-Host "pyautogui non trouvé → installation..."
    python -m pip install pyautogui
} else {
    Write-Host "pyautogui déjà installé."
}

# --- [5] Lancer ton script ---
python run.py

Write-Host "`nExécution terminée ✅"
Pause
