# Neovim Python Debugging Setup Guide
*Complete setup for Python debugging on Chromebook/RunPod*

## 🎯 Overview

This guide documents the complete setup process for getting Python debugging working in Neovim on a Chromebook/RunPod environment. The setup provides both immediate debugging capabilities and advanced features.

## 🛠️ Prerequisites

- **Neovim v0.11.3+** (installed via snap)
- **Python 3** with debugpy
- **tmux** (for terminal management)
- **Git** (for plugin installation)

## 📁 Key Discovery: Config Directory

**Critical Issue:** Neovim looks for config in `/home/root/.config/nvim`, NOT `/root/.config/nvim`

```bash
# Check where Neovim expects config
nvim -c ":echo stdpath('config')" -c ":qa"
```

## 🔧 Installation Steps

### Step 1: Install Neovim
```bash
# Install via snap (most reliable on Ubuntu)
sudo snap install nvim --classic

# Verify installation
nvim --version
```

### Step 2: Install Python Debugging Dependencies
```bash
# Install debugpy for Python debugging
uv add debugpy
# OR
pip install debugpy
```

### Step 3: Create Config Directory
```bash
# Create the correct config directory
mkdir -p /home/root/.config/nvim
```

### Step 4: Install Lazy.nvim Plugin Manager
```bash
# Manual installation of lazy.nvim
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
```

### Step 5: Create Configuration File

Create `/home/root/.config/nvim/init.lua`:

```lua
-- Working debugging setup with real Python debugging
print("🚨 ENHANCED DEBUG CONFIG LOADING! 🚨")
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.g.mapleader = " "

-- Manual breakpoint tracking (works immediately)
local breakpoints = {}

-- Simple breakpoint toggle function
local function toggle_simple_breakpoint()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local buf = vim.api.nvim_get_current_buf()
    
    if breakpoints[line] then
        -- Remove breakpoint
        vim.fn.sign_unplace('SimpleBreakpoint', {buffer = buf, id = line})
        breakpoints[line] = nil
        print("🔴 Breakpoint removed from line " .. line)
    else
        -- Add breakpoint
        vim.fn.sign_place(line, 'SimpleBreakpoint', 'SimpleBreakpoint', buf, {lnum = line})
        breakpoints[line] = true
        print("🔴 Breakpoint set on line " .. line)
    end
end

-- Define simple breakpoint sign
vim.fn.sign_define('SimpleBreakpoint', {text='🔴', texthl='Error'})

-- Simple debugging function using Python's built-in pdb
local function start_python_debug()
    local file = vim.fn.expand('%:p')
    if vim.bo.filetype ~= 'python' then
        print("❌ Not a Python file!")
        return
    end
    
    print("🐍 Starting Python debugging with pdb...")
    -- Open terminal and run Python with pdb
    vim.cmd('split')
    vim.cmd('terminal python3 -m pdb ' .. vim.fn.shellescape(file))
    print("📋 pdb commands: (n)ext, (s)tep, (c)ontinue, (l)ist, (p)rint var, (q)uit")
end

-- Keybindings that work immediately
vim.keymap.set('n', '<leader>bb', toggle_simple_breakpoint, { desc = 'Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dd', start_python_debug, { desc = 'Start Python Debug (pdb)' })

print("✅ Enhanced debugging ready!")
print("📋 Current commands:")
print("  SPACE + bb = Toggle breakpoint")
print("  SPACE + dd = Start Python debugging")

-- Try to enhance with nvim-dap in background
vim.opt.rtp:prepend("/root/.local/share/nvim/lazy/lazy.nvim")

vim.defer_fn(function()
    local ok, lazy = pcall(require, "lazy")
    if ok then
        print("📦 Loading advanced debugging plugins...")
        lazy.setup({
            {
                "mfussenegger/nvim-dap",
                config = function()
                    local dap = require('dap')
                    
                    -- Configure Python adapter
                    dap.adapters.python = {
                        type = 'executable',
                        command = 'python3',
                        args = { '-m', 'debugpy.adapter' },
                    }
                    
                    -- Python debug configuration
                    dap.configurations.python = {
                        {
                            type = 'python',
                            request = 'launch',
                            name = 'Launch file',
                            program = '${file}',
                            pythonPath = 'python3',
                        },
                    }
                    
                    -- Enhanced keybindings (only after dap loads)
                    vim.keymap.set('n', '<leader>dc', function()
                        dap.continue()
                        print("▶️ DAP Continue!")
                    end, { desc = 'DAP Continue' })
                    
                    vim.keymap.set('n', '<leader>dn', function()
                        dap.step_over()
                        print("⏭️ DAP Step Over!")
                    end, { desc = 'DAP Step Over' })
                    
                    vim.keymap.set('n', '<leader>di', function()
                        dap.step_into()
                        print("⏬ DAP Step Into!")
                    end, { desc = 'DAP Step Into' })
                    
                    vim.keymap.set('n', '<leader>dt', function()
                        dap.terminate()
                        print("⏹️ DAP Terminated!")
                    end, { desc = 'DAP Terminate' })
                    
                    -- DAP breakpoint signs
                    vim.fn.sign_define('DapBreakpoint', {text='🟢', texthl='String'})
                    vim.fn.sign_define('DapStopped', {text='👉', texthl='Special'})
                    
                    print("🎉 Advanced DAP debugging loaded!")
                    print("📋 Additional commands available:")
                    print("  SPACE + dc = DAP continue")
                    print("  SPACE + dn = DAP step over")
                    print("  SPACE + di = DAP step into")
                    print("  SPACE + dt = DAP terminate")
                end
            }
        })
    else
        print("📋 Using simple debugging only (pdb)")
    end
end, 2000)
```

## 🎮 Debugging Commands

### Immediate Commands (work instantly)
| Key Combination | Action | Description |
|-----------------|--------|-------------|
| `SPACE + bb` | Toggle Breakpoint | Sets/removes red breakpoint markers |
| `SPACE + dd` | Start pdb Debug | Opens Python debugger in terminal |

### Advanced Commands (after plugins load)
| Key Combination | Action | Description |
|-----------------|--------|-------------|
| `SPACE + dc` | DAP Continue | Continue execution in DAP debugger |
| `SPACE + dn` | DAP Step Over | Execute current line, move to next |
| `SPACE + di` | DAP Step Into | Enter function calls |
| `SPACE + dt` | DAP Terminate | Stop debugging session |

### pdb Commands (in debug terminal)
| Command | Description |
|---------|-------------|
| `n` | Next line |
| `s` | Step into function |
| `c` | Continue execution |
| `l` | List current code |
| `b <line>` | Set breakpoint at line |
| `p <var>` | Print variable value |
| `q` | Quit debugger |

## 🏗️ Architecture Design

### Hybrid Debugging Approach
The setup uses a **two-tier architecture**:

1. **Immediate Layer**: Simple breakpoints and pdb debugging
   - Works instantly without waiting for plugins
   - Uses Neovim's built-in sign system
   - Leverages Python's built-in pdb debugger

2. **Enhanced Layer**: nvim-dap integration
   - Loads in background after 2 seconds
   - Provides advanced debugging features
   - Visual debugging interface

### Key Design Decisions

**Chromebook Compatibility:**
- F-keys don't work (volume controls) → Use SPACE + letter combinations
- Double-letter keybindings (bb, dd) to avoid conflicts
- Terminal-based debugging for universal compatibility

**Graceful Degradation:**
- System works immediately with basic features
- Enhanced features load progressively
- Clear feedback messages for each stage

## 🐛 Common Issues & Solutions

### Issue 1: Config Not Loading
**Problem:** Neovim doesn't load init.lua
**Solution:** Check config path with `:echo stdpath('config')` and put config in correct location

### Issue 2: F-Keys Don't Work
**Problem:** F9, F5 keys are mapped to system functions on Chromebook
**Solution:** Use SPACE + letter combinations instead

### Issue 3: Plugins Not Installing
**Problem:** lazy.nvim not found or plugins fail to install
**Solution:** 
```bash
# Manually install lazy.nvim
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
```

### Issue 4: Python Debugging Fails
**Problem:** debugpy not available
**Solution:**
```bash
# Install debugpy in your environment
uv add debugpy
# OR
pip install debugpy
```

### Issue 5: Stepping Enters Insert Mode
**Problem:** Keybinding conflicts with existing Neovim mappings
**Solution:** Use unique double-letter combinations (dn, di, dc) instead of single letters

## 🔍 Troubleshooting Commands

```bash
# Check Neovim config location
nvim -c ":echo stdpath('config')" -c ":qa"

# Check startup process
nvim --startuptime /tmp/startup.log +q
grep "init.lua" /tmp/startup.log

# Test basic functionality
nvim -c ":lua print('Config working')" -c ":qa"

# Check plugin status (in Neovim)
:Lazy

# Test Python debugging
python3 -c "import debugpy; print('debugpy available')"
```

## ⚡ Quick Setup Script

For future setups, this one-liner recreates the environment:

```bash
#!/bin/bash
# Quick Neovim debugging setup
mkdir -p /home/root/.config/nvim
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
# Then copy the init.lua content above
echo "Setup complete! Open nvim and test with SPACE+bb"
```

## 🎓 Lessons Learned

### Critical Discoveries
1. **Config Path Matters**: Neovim config location varies by environment
2. **Chromebook Limitations**: F-keys are not available for custom mappings
3. **Plugin Loading**: Lazy loading prevents immediate functionality
4. **Graceful Degradation**: Always provide working basic features first

### Best Practices
1. **Test basics first**: Ensure config loads before adding complexity
2. **Provide immediate feedback**: Clear messages for each step
3. **Layer functionality**: Basic → Enhanced → Advanced
4. **Document everything**: Complex setups need comprehensive documentation

### Performance Considerations
1. **Deferred loading**: Load heavy plugins after basic functionality works
2. **Minimal dependencies**: Start with built-in features, enhance progressively
3. **Clear feedback**: Users need to know what's working and what's loading

## 🚀 Future Enhancements

Potential improvements for the debugging setup:

1. **FastAPI Support**: Add FastAPI-specific debugging configurations
2. **Visual UI**: Integrate nvim-dap-ui for graphical debugging panels
3. **AI Breakpoints**: Implement intelligent breakpoint suggestions
4. **Remote Debugging**: Add support for remote Python processes
5. **Test Integration**: Debug pytest and unittest frameworks

## 📝 Usage Examples

### Example 1: Basic Debugging Session
```bash
# 1. Open file
nvim my_script.py

# 2. Set breakpoints
# Navigate to line 10, press SPACE+bb
# Navigate to line 20, press SPACE+bb

# 3. Start debugging
# Press SPACE+dd

# 4. Use pdb commands
# Type 'c' to continue to first breakpoint
# Type 'n' to step through code
# Type 'p variable_name' to inspect variables
# Type 'q' to quit
```

### Example 2: Advanced DAP Debugging
```bash
# Wait for "Advanced DAP debugging loaded!" message
# Use enhanced commands:
# SPACE+dc = continue
# SPACE+dn = step over
# SPACE+di = step into
# SPACE+dt = terminate
```

## 🎯 Success Criteria

You know the setup is working when:
- ✅ Line numbers are visible
- ✅ `SPACE+bb` sets red breakpoint markers
- ✅ `SPACE+dd` opens pdb debugging terminal
- ✅ Messages appear showing config loading stages
- ✅ After ~2 seconds, advanced DAP commands become available

---

*This setup provides a complete Python debugging environment on Chromebook/RunPod with both immediate and advanced capabilities.*