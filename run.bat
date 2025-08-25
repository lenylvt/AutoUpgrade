@echo off
:: run_admin.bat
:: Script batch complet : admin + venv + pyautogui + run.py

:: --- [1] Vérifier si lancé en admin ---
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Relance en mode administrateur...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: --- [2] Aller dans le dossier du script ---
cd /d "%~dp0"

:: --- [3] Vérifier si venv existe, sinon le créer ---
if not exist venv (
    echo Aucun venv trouvé → création en cours...
    py -m venv venv
)

:: --- [4] Activer le venv ---
call venv\Scripts\activate.bat

:: --- [5] Vérifier si pyautogui est installé ---
python -c "import pyautogui" 2>NUL
IF %ERRORLEVEL% NEQ 0 (
    echo pyautogui non trouvé → installation...
    python -m pip install --upgrade pip
    python -m pip install pyautogui
) ELSE (
    echo pyautogui déjà installé.
)

:: --- [6] Lancer le script Python ---
echo Lancement de run.py...
python run.py

echo.
echo Exécution terminée ✅
pause
