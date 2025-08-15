-- PyCharm-Level Python Debugging Setup for Chromebook
print("🚀 LOADING PYCHARM-LEVEL DEBUG CONFIG! 🚀")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "88"
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 300
vim.g.mapleader = " "

-- Manual breakpoint tracking (works immediately)
local breakpoints = {}

-- Simple breakpoint toggle function (immediate fallback)
local function toggle_simple_breakpoint()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local buf = vim.api.nvim_get_current_buf()
    
    if breakpoints[line] then
        vim.fn.sign_unplace('SimpleBreakpoint', {buffer = buf, id = line})
        breakpoints[line] = nil
        print("🔴 Breakpoint removed from line " .. line)
    else
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
    vim.cmd('split')
    vim.cmd('terminal python3 -m pdb ' .. vim.fn.shellescape(file))
    print("📋 pdb commands: (n)ext, (s)tep, (c)ontinue, (l)ist, (p)rint var, (q)uit")
end

-- Immediate keybindings (work right away)
vim.keymap.set('n', '<leader>bb', toggle_simple_breakpoint, { desc = 'Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dd', start_python_debug, { desc = 'Start Python Debug (pdb)' })

print("✅ Basic debugging ready!")
print("📋 Immediate commands: SPACE+bb (breakpoint), SPACE+dd (debug)")

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend("/root/.local/share/nvim/lazy/lazy.nvim")

-- Enhanced PyCharm-level debugging setup
vim.defer_fn(function()
    local ok, lazy = pcall(require, "lazy")
    if not ok then
        print("❌ Lazy.nvim not available - using basic debugging only")
        return
    end
    
    print("📦 Loading PyCharm-level debugging plugins...")
    
    lazy.setup({
        -- Core debugging with UI
        {
            "mfussenegger/nvim-dap",
            dependencies = {
                "rcarriga/nvim-dap-ui",
                "nvim-neotest/nvim-nio",
                "theHamsta/nvim-dap-virtual-text", 
                "mfussenegger/nvim-dap-python",
                "nvim-telescope/telescope-dap.nvim",
            },
            config = function()
                local dap = require('dap')
                local dapui = require('dapui')
                local dap_python = require('dap-python')
                require('nvim-dap-virtual-text').setup()
                
                -- Setup Python debugging with correct virtual environment
                local python_path = '/root/dev/ai_l7_kb/.venv/bin/python3'
                dap_python.setup(python_path)
                
                -- Python adapter configuration
                dap.adapters.python = {
                    type = 'executable',
                    command = python_path,
                    args = { '-m', 'debugpy.adapter' },
                }
                
                -- Comprehensive Python debug configurations
                dap.configurations.python = {
                    {
                        type = 'python',
                        request = 'launch',
                        name = 'Launch file',
                        program = '${file}',
                        pythonPath = python_path,
                        console = 'integratedTerminal',
                        justMyCode = false,
                    },
                    {
                        type = 'python',
                        request = 'launch', 
                        name = 'Launch with arguments',
                        program = '${file}',
                        args = function()
                            return vim.split(vim.fn.input('Arguments: '), " ")
                        end,
                        pythonPath = python_path,
                        console = 'integratedTerminal',
                        justMyCode = false,
                    },
                    {
                        type = 'python',
                        request = 'launch',
                        name = 'Debug FastAPI (uvicorn)',
                        module = 'uvicorn',
                        args = {
                            'main:app',
                            '--reload',
                            '--host', '127.0.0.1',
                            '--port', '8000',
                            '--log-level', 'debug'
                        },
                        pythonPath = python_path,
                        console = 'integratedTerminal',
                        justMyCode = false,
                    },
                    {
                        type = 'python',
                        request = 'launch',
                        name = 'Debug Django',
                        program = '${workspaceFolder}/manage.py',
                        args = { 'runserver', '--noreload', '127.0.0.1:8000' },
                        pythonPath = python_path,
                        django = true,
                        console = 'integratedTerminal',
                        justMyCode = false,
                    },
                    {
                        type = 'python',
                        request = 'launch',
                        name = 'Debug Flask',
                        module = 'flask',
                        env = {
                            FLASK_APP = 'app.py',
                            FLASK_ENV = 'development',
                            FLASK_DEBUG = '0'
                        },
                        args = { 'run', '--no-debugger', '--no-reload', '--host', '127.0.0.1' },
                        pythonPath = python_path,
                        console = 'integratedTerminal',
                        justMyCode = false,
                    },
                    {
                        type = 'python',
                        request = 'launch',
                        name = 'Debug Tests (pytest)',
                        module = 'pytest',
                        args = { '${workspaceFolder}', '-v', '-s' },
                        pythonPath = python_path,
                        console = 'integratedTerminal',
                        justMyCode = false,
                    },
                    {
                        type = 'python',
                        request = 'attach',
                        name = 'Attach remote',
                        connect = function()
                            local host = vim.fn.input('Host [127.0.0.1]: ')
                            host = host ~= '' and host or '127.0.0.1'
                            local port = tonumber(vim.fn.input('Port [5678]: ')) or 5678
                            return { host = host, port = port }
                        end,
                        justMyCode = false,
                    },
                }
                
                -- Setup DAP UI with PyCharm-like layout
                dapui.setup({
                    icons = { 
                        expanded = "▾", 
                        collapsed = "▸", 
                        current_frame = "▸" 
                    },
                    mappings = {
                        expand = { "<CR>", "<2-LeftMouse>" },
                        open = "o",
                        remove = "d",
                        edit = "e",
                        repl = "r",
                        toggle = "t",
                    },
                    layouts = {
                        {
                            elements = {
                                { id = "scopes", size = 0.30 },       -- Variable inspection
                                { id = "breakpoints", size = 0.20 },  -- Breakpoint list
                                { id = "stacks", size = 0.25 },       -- Call stack
                                { id = "watches", size = 0.25 },      -- Watch expressions
                            },
                            size = 50,  -- 50 columns for left panel
                            position = "left",
                        },
                        {
                            elements = {
                                { id = "repl", size = 0.60 },      -- Debug console
                                { id = "console", size = 0.40 },   -- Application output
                            },
                            size = 15,  -- 15 lines for bottom panel
                            position = "bottom",
                        },
                    },
                    controls = {
                        enabled = true,
                        element = "repl",
                        icons = {
                            pause = "⏸",
                            play = "▶",
                            step_into = "⏬",
                            step_over = "⏭",
                            step_out = "⏮",
                            step_back = "b",
                            run_last = "↻",
                            terminate = "⏹",
                        },
                    },
                    floating = {
                        max_height = nil,
                        max_width = nil,
                        border = "single",
                        mappings = {
                            close = { "q", "<Esc>" },
                        },
                    },
                    windows = { indent = 1 },
                    render = {
                        max_type_length = nil,
                        max_value_lines = 100,
                    }
                })
                
                -- PyCharm-style keybindings (Chromebook compatible)
                vim.keymap.set('n', '<leader>bb', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
                vim.keymap.set('n', '<leader>bc', function()
                    local condition = vim.fn.input('Breakpoint condition: ')
                    dap.set_breakpoint(condition)
                end, { desc = 'Conditional Breakpoint' })
                
                vim.keymap.set('n', '<leader>dd', dap.continue, { desc = 'Debug: Continue/Start' })
                vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = 'Debug: Step Over (Next)' })
                vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
                vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'Debug: Step Out' })
                vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Debug: Terminate' })
                vim.keymap.set('n', '<leader>dp', dap.pause, { desc = 'Debug: Pause' })
                vim.keymap.set('n', '<leader>dr', dap.restart, { desc = 'Debug: Restart' })
                
                -- UI controls
                vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })
                vim.keymap.set('n', '<leader>de', dapui.eval, { desc = 'Debug: Evaluate Expression' })
                vim.keymap.set('v', '<leader>de', dapui.eval, { desc = 'Debug: Evaluate Selection' })
                vim.keymap.set('n', '<leader>df', dapui.float_element, { desc = 'Debug: Float Element' })
                vim.keymap.set('n', '<leader>dc', function() dapui.open_repl() end, { desc = 'Debug: Open Console' })
                
                -- Advanced debugging
                vim.keymap.set('n', '<leader>dw', function()
                    local expr = vim.fn.input('Watch expression: ')
                    if expr ~= '' then
                        dap.set_breakpoint(nil, nil, expr)
                    end
                end, { desc = 'Debug: Add Watch Expression' })
                
                vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Debug: Run Last Configuration' })
                vim.keymap.set('n', '<leader>dh', function() dapui.toggle_element("scopes") end, { desc = 'Debug: Toggle Variables' })
                
                -- Python-specific debugging
                vim.keymap.set('n', '<leader>dpt', dap_python.test_method, { desc = 'Debug: Test Method' })
                vim.keymap.set('n', '<leader>dpc', dap_python.test_class, { desc = 'Debug: Test Class' })
                vim.keymap.set('v', '<leader>dps', dap_python.debug_selection, { desc = 'Debug: Selection' })
                
                -- Auto-open/close UI
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open()
                    print("🎯 Debug session started - UI opened")
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close()
                    print("⏹️ Debug session ended - UI closed")
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close()
                    print("🚪 Debug session exited - UI closed")
                end
                
                -- Enhanced breakpoint signs
                vim.fn.sign_define('DapBreakpoint', {
                    text = '🔴',
                    texthl = 'DapBreakpoint',
                    linehl = '',
                    numhl = 'DapBreakpoint'
                })
                vim.fn.sign_define('DapBreakpointCondition', {
                    text = '🔶',
                    texthl = 'DapBreakpointCondition',
                    linehl = '',
                    numhl = 'DapBreakpointCondition'
                })
                vim.fn.sign_define('DapLogPoint', {
                    text = '🔷',
                    texthl = 'DapLogPoint',
                    linehl = '',
                    numhl = ''
                })
                vim.fn.sign_define('DapStopped', {
                    text = '👉',
                    texthl = 'DapStopped',
                    linehl = 'DapStoppedLine',
                    numhl = 'DapStopped'
                })
                vim.fn.sign_define('DapBreakpointRejected', {
                    text = '❌',
                    texthl = 'DapBreakpointRejected',
                    linehl = '',
                    numhl = ''
                })
                
                print("🎉 PyCharm-level debugging loaded!")
                print("📋 Enhanced Commands Available:")
                print("  SPACE+bb = Toggle breakpoint")
                print("  SPACE+bc = Conditional breakpoint") 
                print("  SPACE+dd = Start/Continue debugging")
                print("  SPACE+dn = Step over (next)")
                print("  SPACE+di = Step into")
                print("  SPACE+do = Step out")
                print("  SPACE+dt = Terminate")
                print("  SPACE+du = Toggle debug UI")
                print("  SPACE+de = Evaluate expression")
                print("  SPACE+dw = Add watch expression")
                print("  SPACE+dpt = Debug test method")
            end
        },
        
        -- Telescope for advanced debugging
        {
            "nvim-telescope/telescope.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                require('telescope').load_extension('dap')
                vim.keymap.set('n', '<leader>ds', '<cmd>Telescope dap configurations<cr>', { desc = 'Debug: Select Configuration' })
                vim.keymap.set('n', '<leader>db', '<cmd>Telescope dap list_breakpoints<cr>', { desc = 'Debug: List Breakpoints' })
                vim.keymap.set('n', '<leader>dv', '<cmd>Telescope dap variables<cr>', { desc = 'Debug: Variables' })
                vim.keymap.set('n', '<leader>df', '<cmd>Telescope dap frames<cr>', { desc = 'Debug: Frames' })
            end
        },
        
        -- Enhanced syntax highlighting
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                require('nvim-treesitter.configs').setup({
                    ensure_installed = { "python", "lua", "vim", "vimdoc", "json", "yaml", "markdown" },
                    auto_install = true,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end
        },
        
        -- Status line with debugging info
        {
            "nvim-lualine/lualine.nvim", 
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require('lualine').setup({
                    options = {
                        theme = 'auto',
                        component_separators = { left = '', right = ''},
                        section_separators = { left = '', right = ''},
                    },
                    sections = {
                        lualine_a = {'mode'},
                        lualine_b = {'branch', 'diff', 'diagnostics'},
                        lualine_c = {'filename'},
                        lualine_x = {
                            function()
                                local dap = package.loaded['dap']
                                if dap and dap.session() then
                                    return '🐛 DEBUG'
                                end
                                return ''
                            end,
                            'encoding', 'fileformat', 'filetype'
                        },
                        lualine_y = {'progress'},
                        lualine_z = {'location'}
                    },
                })
            end
        },
        
        -- Color scheme
        {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd[[colorscheme tokyonight]]
            end
        },
    })
    
    print("⚡ All PyCharm-level plugins loaded!")
    
end, 1000)  -- Load after 1 second