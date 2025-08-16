# Neovim PyCharm-Level Python Debugging Setup

A complete Neovim configuration that provides PyCharm-level Python debugging capabilities for Linux servers (Digital Ocean, AWS, Google Cloud, etc.) with Chromebook-compatible keybindings.

## 🚀 Features

- **PyCharm-Style Debugging**: Visual debugging panels, variable inspection, call stack
- **Universal Keybindings**: Chromebook-friendly keybindings (no F-keys) that work on any system
- **Immediate + Enhanced**: Works instantly with basic features, loads advanced features progressively
- **Framework Support**: FastAPI, Django, Flask, pytest debugging configurations
- **Visual UI**: Debug panels, variable inspection, breakpoint management
- **Hybrid Architecture**: Falls back to pdb if advanced plugins fail

## 📦 What's Included

- **Complete init.lua**: Full Neovim configuration with debugging
- **Setup Scripts**: One-command installation
- **Documentation**: Comprehensive setup and usage guides
- **Test Files**: Sample Python files for testing debugging

## ⚡ Quick Setup

### Prerequisites
- Neovim v0.11.3+
- Python 3 with pip/uv
- Git

### Installation

1. **Clone this repository:**
```bash
git clone https://github.com/yourusername/neovim-python-debug.git
cd neovim-python-debug
```

2. **Run the setup script:**
```bash
chmod +x setup.sh
./setup.sh
```

3. **Test the setup:**
```bash
nvim test_debug.py
```

## 🎮 Debug Commands (Chromebook-Friendly)

### Immediate Commands
| Key | Action | Description |
|-----|--------|-------------|
| `SPACE + bb` | Toggle Breakpoint | Set/remove breakpoints |
| `SPACE + dd` | Start Debug | Begin debugging session |

### PyCharm-Level Commands (after plugins load)
| Key | Action | Description |
|-----|--------|-------------|
| `SPACE + bb` | Toggle Breakpoint | Enhanced breakpoint system |
| `SPACE + bc` | Conditional Breakpoint | Breakpoint with conditions |
| `SPACE + dd` | Start/Continue | Main debug control |
| `SPACE + dn` | Step Over | Execute current line |
| `SPACE + di` | Step Into | Enter function calls |
| `SPACE + do` | Step Out | Exit current function |
| `SPACE + dt` | Terminate | Stop debugging |
| `SPACE + du` | Toggle Debug UI | Show/hide debug panels |
| `SPACE + de` | Evaluate Expression | Evaluate code/variables |
| `SPACE + dw` | Add Watch | Monitor variables |
| `SPACE + dpt` | Debug Test Method | Debug pytest methods |

## 🎯 Debug Configurations

Pre-configured debugging for:
- **Python Files**: Standard Python script debugging
- **FastAPI**: uvicorn debugging with reload
- **Django**: Development server debugging  
- **Flask**: Development mode debugging
- **pytest**: Test debugging with verbose output
- **Remote Debugging**: Attach to remote Python processes

## 🏗️ Architecture

### Hybrid Debugging Approach
1. **Immediate Layer**: Basic breakpoints and pdb (works instantly)
2. **Enhanced Layer**: nvim-dap with visual UI (loads in background)

### UI Layout
- **Left Panel (50 cols)**: Variables, Breakpoints, Call Stack, Watch Expressions
- **Bottom Panel (15 lines)**: Debug Console + Application Output
- **Inline Variables**: Shows variable values next to code

## 📂 File Structure

```
neovim-python-debug/
├── README.md                    # This file
├── setup.sh                     # One-command setup script
├── config/
│   └── init.lua                 # Complete Neovim configuration
├── docs/
│   ├── SETUP_GUIDE.md          # Detailed setup instructions
│   ├── USAGE_GUIDE.md          # Usage and debugging guide
│   └── TROUBLESHOOTING.md      # Common issues and solutions
├── examples/
│   ├── test_debug.py           # Sample Python debugging file
│   ├── fastapi_example.py      # FastAPI debugging example
│   └── django_example.py       # Django debugging example
└── scripts/
    ├── install_dependencies.sh # Install Python dependencies
    └── backup_config.sh        # Backup existing config
```

## 🛠️ Manual Setup

If you prefer manual setup:

1. **Install debugpy:**
```bash
pip install debugpy
# OR if using uv
uv add debugpy
```

2. **Create config directory:**
```bash
# Check where Neovim expects config
nvim -c ":echo stdpath('config')" -c ":qa"

# Usually one of these:
mkdir -p ~/.config/nvim          # Most systems
mkdir -p /home/root/.config/nvim # Some RunPod setups
```

3. **Install lazy.nvim:**
```bash
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
```

4. **Copy configuration:**
```bash
cp config/init.lua ~/.config/nvim/init.lua
```

## 🐛 Troubleshooting

### Common Issues

**"No module named 'debugpy'"**
- Install debugpy: `pip install debugpy` or `uv add debugpy`
- Check Python path in config matches your environment

**F-keys don't work on Chromebook**
- Use SPACE + letter combinations instead
- All debugging commands work with SPACE key

**Plugins not loading**
- Check `:Lazy` command in Neovim
- Ensure internet connection for plugin downloads
- Try `:Lazy sync` to force plugin installation

**Config not loading**
- Verify config path: `:echo stdpath('config')`
- Check for Lua syntax errors: `:checkhealth`

## 🎓 Comparison with PyCharm

| Feature | PyCharm | This Setup | Notes |
|---------|---------|------------|-------|
| Visual Breakpoints | ✅ | ✅ | Emoji indicators |
| Variable Inspection | ✅ | ✅ | Real-time panels |
| Step Debugging | ✅ | ✅ | Step into/over/out |
| Watch Expressions | ✅ | ✅ | Monitor variables |
| Debug Console | ✅ | ✅ | Interactive REPL |
| Framework Support | ✅ | ✅ | FastAPI/Django/Flask |
| Remote Debugging | ✅ | ✅ | Attach to processes |
| GUI Configuration | ✅ | ➖ | Text-based config |
| Vim Motions | ➖ | ✅ | Native Vim editing |
| Resource Usage | Heavy | Light | Lightweight setup |

## 🔮 Future Enhancements

- [ ] AI-powered breakpoint suggestions
- [ ] Performance profiling integration
- [ ] Docker debugging support
- [ ] Jupyter notebook debugging
- [ ] Multi-language debugging (Go, Rust, etc.)

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test your changes thoroughly
4. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details.

## 🙏 Acknowledgments

- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Core debugging adapter
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) - Visual debugging interface
- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [Neovim](https://neovim.io/) - The editor that makes this possible

---

*Turn your Neovim into a PyCharm-level Python debugging powerhouse! 🚀*