#!/bin/bash

# Neovim PyCharm-Level Python Debugging Setup Script
# One-command setup for complete debugging environment

set -e  # Exit on any error

echo "🚀 Setting up Neovim PyCharm-level Python debugging..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "${BLUE}📦 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
print_step "Checking prerequisites..."

# Check Neovim
if ! command -v nvim &> /dev/null; then
    print_error "Neovim not found. Please install Neovim first:"
    echo "  Ubuntu/Debian: sudo apt install neovim"
    echo "  Snap: sudo snap install nvim --classic"
    echo "  macOS: brew install neovim"
    exit 1
fi

NVIM_VERSION=$(nvim --version | head -1 | awk '{print $2}')
print_success "Neovim $NVIM_VERSION found"

# Check Python
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 not found. Please install Python 3."
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
print_success "Python $PYTHON_VERSION found"

# Check pip or uv
PIP_CMD=""
if command -v uv &> /dev/null; then
    PIP_CMD="uv add"
    print_success "uv package manager found (preferred)"
elif command -v pip3 &> /dev/null; then
    PIP_CMD="pip3 install"
    print_success "pip3 found"
elif command -v pip &> /dev/null; then
    PIP_CMD="pip install"
    print_success "pip found"
else
    print_error "No Python package manager found (pip/uv required)"
    exit 1
fi

# Get Neovim config directory
print_step "Detecting Neovim configuration directory..."
NVIM_CONFIG_DIR=$(nvim --headless -c "echo stdpath('config')" -c "qa" 2>/dev/null || echo "$HOME/.config/nvim")
print_success "Config directory: $NVIM_CONFIG_DIR"

# Backup existing config
if [ -f "$NVIM_CONFIG_DIR/init.lua" ]; then
    print_warning "Existing init.lua found, backing up..."
    cp "$NVIM_CONFIG_DIR/init.lua" "$NVIM_CONFIG_DIR/init.lua.backup.$(date +%Y%m%d_%H%M%S)"
    print_success "Backup created"
fi

# Create config directory
print_step "Creating Neovim configuration directory..."
mkdir -p "$NVIM_CONFIG_DIR"
print_success "Directory created: $NVIM_CONFIG_DIR"

# Install lazy.nvim
print_step "Installing lazy.nvim plugin manager..."
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
    print_success "lazy.nvim installed"
else
    print_success "lazy.nvim already installed"
fi

# Install debugpy
print_step "Installing Python debugging dependencies..."
if $PIP_CMD debugpy; then
    print_success "debugpy installed successfully"
else
    print_warning "debugpy installation failed, continuing anyway..."
fi

# Get Python executable path
PYTHON_PATH=$(which python3)
if [ -f ".venv/bin/python3" ]; then
    PYTHON_PATH="$(pwd)/.venv/bin/python3"
    print_success "Using virtual environment Python: $PYTHON_PATH"
else
    print_success "Using system Python: $PYTHON_PATH"
fi

# Copy and customize configuration
print_step "Installing Neovim configuration..."
cp config/init.lua "$NVIM_CONFIG_DIR/init.lua"

# Update Python path in config if using virtual environment
if [ -f ".venv/bin/python3" ]; then
    sed -i "s|local python_path = '/root/dev/ai_l7_kb/.venv/bin/python3'|local python_path = '$(pwd)/.venv/bin/python3'|g" "$NVIM_CONFIG_DIR/init.lua"
    print_success "Configuration updated for virtual environment"
fi

print_success "Configuration installed: $NVIM_CONFIG_DIR/init.lua"

# Create test file
print_step "Creating test debugging file..."
cp examples/test_debug.py ./test_debug.py
print_success "Test file created: ./test_debug.py"

# Final instructions
echo ""
echo "🎉 Setup complete! Here's what was installed:"
echo ""
echo "📂 Files created:"
echo "  • $NVIM_CONFIG_DIR/init.lua (main configuration)"
echo "  • ./test_debug.py (test file for debugging)"
echo ""
echo "🎮 Debug Commands (Chromebook-friendly):"
echo "  • SPACE + bb = Toggle breakpoint"
echo "  • SPACE + dd = Start debugging"  
echo "  • SPACE + dn = Step over"
echo "  • SPACE + di = Step into"
echo "  • SPACE + do = Step out"
echo "  • SPACE + dt = Terminate"
echo "  • SPACE + du = Toggle debug UI"
echo ""
echo "🧪 Test the setup:"
echo "  1. Run: nvim test_debug.py"
echo "  2. Wait for plugins to load (~10-20 seconds)"
echo "  3. Set breakpoint: SPACE + bb"
echo "  4. Start debugging: SPACE + dd"
echo "  5. Enjoy PyCharm-level debugging! 🚀"
echo ""
echo "📖 For detailed documentation, see:"
echo "  • docs/SETUP_GUIDE.md"
echo "  • docs/TROUBLESHOOTING.md"
echo ""
echo "🐛 If you encounter issues:"
echo "  • Check :Lazy in Neovim for plugin status"
echo "  • Verify debugpy: python3 -c 'import debugpy; print(debugpy.__version__)'"
echo "  • See troubleshooting guide for common fixes"