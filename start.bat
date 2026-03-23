@echo off
echo === Kairouz ^& Gauthron - Lancement du projet ===

echo [1/3] Demarrage de PocketBase...
cd /d "%~dp0server"
start /B pocketbase.exe serve
echo       Admin: http://127.0.0.1:8090/_/
echo       API:   http://127.0.0.1:8090/api/

timeout /t 2 /nobreak >nul

echo [2/3] Installation des dependances Flutter...
cd /d "%~dp0app"
call flutter pub get

echo [3/3] Lancement de l'application Flutter...
echo.
echo Pour arreter: Ctrl+C puis fermer la fenetre
echo.
call flutter run

echo Arret de PocketBase...
taskkill /F /IM pocketbase.exe >nul 2>&1
echo Termine.
pause
