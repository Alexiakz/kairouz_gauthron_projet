#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo -e "${BLUE}=== Kairouz & Gauthron - Lancement du projet ===${NC}"

# 1. Lancer PocketBase en arriere-plan
echo -e "${GREEN}[1/3] Demarrage de PocketBase...${NC}"
cd "$ROOT_DIR/server"
./pocketbase serve &
PB_PID=$!
echo "      PocketBase PID: $PB_PID"
echo "      Admin: http://127.0.0.1:8090/_/"
echo "      API:   http://127.0.0.1:8090/api/"

# Attendre que PocketBase soit pret
sleep 2

# 2. Installer les dependances Flutter
echo -e "${GREEN}[2/3] Installation des dependances Flutter...${NC}"
cd "$ROOT_DIR/app"
flutter pub get

# 3. Lancer l'app Flutter
echo -e "${GREEN}[3/3] Lancement de l'application Flutter...${NC}"
echo ""
echo -e "${BLUE}Pour arreter: Ctrl+C${NC}"
echo ""
flutter run

# Quand Flutter s'arrete, on arrete PocketBase
echo -e "${GREEN}Arret de PocketBase (PID $PB_PID)...${NC}"
kill $PB_PID 2>/dev/null
echo -e "${BLUE}Termine.${NC}"
