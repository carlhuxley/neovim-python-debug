#!/bin/bash
# Initialize the Neovim Python Debug repository

cd "$(dirname "$0")"

echo "🚀 Initializing Neovim Python Debug repository..."

# Initialize git repository
git init
echo "✅ Git repository initialized"

# Create .gitignore
cat > .gitignore << 'EOF'
# Neovim
.nvim/
*.swp
*.swo
*~

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
*.log
logs/

# Temporary files
tmp/
temp/
EOF

echo "✅ .gitignore created"

# Add all files
git add .
echo "✅ Files staged"

# Initial commit
git commit -m "Initial commit: PyCharm-level Neovim Python debugging setup

Features:
- Complete Neovim configuration with PyCharm-level debugging
- Chromebook-friendly keybindings (SPACE + letter combinations)
- Hybrid architecture: immediate basic features + enhanced UI
- Support for FastAPI, Django, Flask, pytest debugging
- Visual debugging panels with variable inspection
- One-command setup script
- Comprehensive documentation

🤖 Generated with Claude Code
"

echo "✅ Initial commit created"

echo ""
echo "🎉 Repository initialized successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Create GitHub repository"
echo "2. Add remote: git remote add origin https://github.com/yourusername/neovim-python-debug.git"
echo "3. Push: git push -u origin main"
echo ""
echo "🧪 Test the setup:"
echo "./setup.sh"