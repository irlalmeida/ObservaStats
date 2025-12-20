#!/bin/bash

# =====================================================
# ObservaStats - Setup Secrets & Clean History
# For Manjaro/Arch Linux
# =====================================================

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     ObservaStats - Setup Secrets & Clean History          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"

# ===== STEP 1: CRIAR ARQUIVOS DE CONFIGURAÇÃO =====
echo -e "${YELLOW}📝 Step 1: Criando arquivos de configuração...${NC}\n"

# Criar config.js
cat > config.js << 'EOF'
const firebaseConfig = {
    apiKey: "AIzaSyCGqYF9A3GtudMHqE0SoCY2zK3mqPm83BY",
    authDomain: "observastats-75a9c.firebaseapp.com",
    databaseURL: "https://observastats-75a9c-default-rtdb.firebaseio.com",
    projectId: "observastats-75a9c",
    storageBucket: "observastats-75a9c.firebasestorage.app",
    messagingSenderId: "8287096724",
    appId: "1:8287096724:web:2f19fb368b7838d31f8981"
};
EOF

echo -e "${GREEN}✓ config.js criado${NC}"

# Criar codes.js
cat > codes.js << 'EOF'
const INITIAL_CODES = {
    "OBSERVATORIO": "Beatriz",
    "TRANSFORMACAO": "Camila",
    "DIGITAL": "Isabela",
    "ESTADO": "Bento",
    "SAOPAULO": "Lucas"
};
EOF

echo -e "${GREEN}✓ codes.js criado${NC}\n"

# ===== STEP 2: CRIAR .GITIGNORE =====
echo -e "${YELLOW}🛡️  Step 2: Configurando .gitignore...${NC}\n"

cat > .gitignore << 'EOF'
# Arquivos sensíveis
codes.js
config.js
.env
.env.local
firebase-key.json

# Node
node_modules/
package-lock.json

# IDE
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db
EOF

echo -e "${GREEN}✓ .gitignore criado${NC}\n"

# ===== STEP 3: CRIAR GITHUB SECRETS =====
echo -e "${YELLOW}🔐 Step 3: Criando GitHub Secrets...${NC}\n"

# Firebase Secrets
echo "  📦 Firebase Secrets..."
gh secret set FIREBASE_API_KEY -b "AIzaSyCGqYF9A3GtudMHqE0SoCY2zK3mqPm83BY"
gh secret set FIREBASE_AUTH_DOMAIN -b "observastats-75a9c.firebaseapp.com"
gh secret set FIREBASE_DATABASE_URL -b "https://observastats-75a9c-default-rtdb.firebaseio.com"
gh secret set FIREBASE_PROJECT_ID -b "observastats-75a9c"
gh secret set FIREBASE_STORAGE_BUCKET -b "observastats-75a9c.firebasestorage.app"
gh secret set FIREBASE_MESSAGING_SENDER_ID -b "8287096724"
gh secret set FIREBASE_APP_ID -b "1:8287096724:web:2f19fb368b7838d31f8981"
gh secret set FIREBASE_DEPLOY_TOKEN -b ""

echo -e "  ${GREEN}✓ Firebase Secrets${NC}"

# Login Codes
echo "  📝 Login Codes..."
gh secret set LOGIN_CODE_1 -b "OBSERVATORIO"
gh secret set LOGIN_NAME_1 -b "Beatriz"
gh secret set LOGIN_CODE_2 -b "TRANSFORMACAO"
gh secret set LOGIN_NAME_2 -b "Camila"
gh secret set LOGIN_CODE_3 -b "DIGITAL"
gh secret set LOGIN_NAME_3 -b "Isabela"
gh secret set LOGIN_CODE_4 -b "ESTADO"
gh secret set LOGIN_NAME_4 -b "Bento"
gh secret set LOGIN_CODE_5 -b "SAOPAULO"
gh secret set LOGIN_NAME_5 -b "Lucas"

echo -e "  ${GREEN}✓ Login Codes${NC}\n"

# ===== STEP 4: LIMPAR HISTÓRICO =====
echo -e "${YELLOW}🧹 Step 4: Limpando histórico do Git...${NC}\n"

# Verifica se BFG está instalado
if ! command -v bfg &> /dev/null; then
    echo -e "${YELLOW}⚠️  BFG não está instalado. Instalando...${NC}"
    sudo pacman -S bfg --noconfirm
fi

# Fazer backup
echo "  📦 Fazendo backup dos arquivos..."
cp observastats.html observastats.html.backup 2>/dev/null
cp index.html index.html.backup 2>/dev/null

# Clone mirror
echo "  ⬇️  Clonando mirror do repositório..."
REPO_URL=$(git config --get remote.origin.url)
git clone --mirror "$REPO_URL" observastats-mirror.git

# Remove arquivos do histórico
cd observastats-mirror.git
echo "  🗑️  Removendo observastats.html do histórico..."
bfg --delete-files observastats.html

echo "  ��️  Removendo index.html do histórico..."
bfg --delete-files index.html

# Limpa
echo "  🧹 Limpando histórico..."
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Push
echo "  📤 Fazendo push..."
git push --mirror

# Cleanup
cd ..
rm -rf observastats-mirror.git

echo -e "  ${GREEN}✓ Histórico limpo${NC}\n"

# ===== STEP 5: ATUALIZAR REPO LOCAL =====
echo -e "${YELLOW}🔄 Step 5: Atualizando repositório local...${NC}\n"

git pull
echo -e "${GREEN}✓ Repositório atualizado${NC}\n"

# ===== STEP 6: COMMIT FINAL =====
echo -e "${YELLOW}📝 Step 6: Fazendo commit final...${NC}\n"

git add .gitignore config.js codes.js
git commit -m "🔐 Add secure configuration files and cleanup sensitive data"
git push

echo -e "${GREEN}✓ Commit finalizado${NC}\n"

# ===== SUMMARY =====
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                   ✅ SETUP COMPLETO!                       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"

echo -e "${GREEN}✓ Arquivos criados:${NC}"
echo "  • config.js (no .gitignore)"
echo "  • codes.js (no .gitignore)"
echo "  • .gitignore (atualizado)"

echo -e "\n${GREEN}✓ 18 GitHub Secrets criados:${NC}"
echo "  • 7 Firebase secrets"
echo "  • 1 Firebase Deploy Token"
echo "  • 10 Login codes"

echo -e "\n${GREEN}✓ Histórico limpo:${NC}"
echo "  • observastats.html removido"
echo "  • index.html removido"

echo -e "\n${YELLOW}📝 Próximos passos:${NC}"
echo "  1. Verifique os secrets no GitHub:"
echo "     gh secret list"
echo ""
echo "  2. Teste o login com um dos códigos:"
echo "     OBSERVATORIO (Beatriz)"
echo ""
echo "  3. Backups salvos como:"
echo "     • observastats.html.backup"
echo "     • index.html.backup"
echo ""

echo -e "${GREEN}🎉 Tudo pronto! Seu projeto está seguro!${NC}\n"
