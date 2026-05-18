-- Packages
vim.pack.add({
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/github/copilot.vim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
})

require("oil").setup()
require("mason").setup()
require("telescope").setup({})

-- LSP
vim.lsp.enable('basedpyright')
vim.lsp.enable('marksman')
vim.lsp.enable('lua_ls')
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})
vim.lsp.enable("lua_ls")

-- theme & transparency
vim.cmd.colorscheme("unokai")
vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
vim.api.nvim_set_hl(0, "NormalNC", {bg = "none"})
vim.api.nvim_set_hl(0, "EndOfBuffer", {bg = "none"})

-- Basic settings
vim.opt.number = true             -- Line numbers
vim.opt.relativenumber = true     -- Relative numbers
vim.opt.cursorline = true         -- Highlight current line
vim.opt.wrap = false              -- no wrapping
vim.opt.scrolloff = 10            -- keep 10 lines above/below the cursor
vim.opt.sidescrolloff = 8         -- 8 columns left/right cursor

--indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 2
vim.opt.expandtab = true           -- use spaces instead of tab
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.api.nvim_create_autocmd("FileType", { -- set tabstop to 2 spaces in javascript files
    pattern = "javascript",
    command = "setlocal ts=2 sw=2 sts=2"})
    vim.api.nvim_create_autocmd("FileType", { -- set tabstop to 2 spaces in lua files
        pattern = "lua",
        command = "setlocal ts=2 sw=2 sts=2"})
        vim.api.nvim_create_autocmd("FileType", { -- set maximum width of text to 80 characters in  markdown files
            pattern = "markdown",
            command = "setlocal textwidth=80"})

            -- search settings
            vim.opt.ignorecase = true
            vim.opt.smartcase = true
            vim.opt.hlsearch = false           -- geen highlight search
            vim.opt.incsearch = true           -- show matches as you type

            -- visual settings
            vim.opt.termguicolors = true
            vim.opt.signcolumn = "yes"
            -- vim.opt.colorcolumn = "100"
            vim.opt.showmatch = true          -- show matching brackets
            vim.opt.matchtime = 2             -- how long matching brackets shown
            vim.opt.cmdheight = 1
            vim.opt.completeopt = "menuone,noinsert,noselect"
            vim.opt.showmode = false
            vim.opt.pumheight = 10
            vim.opt.pumblend = 10
            vim.opt.winblend = 0
            vim.opt.conceallevel = 0
            vim.opt.concealcursor = ""
            vim.opt.lazyredraw = true
            vim.opt.synmaxcol = 300

            -- Filehandling
            vim.opt.backup = false
            vim.opt.writebackup = false
            vim.opt.swapfile = false
            vim.opt.undofile = true
            vim.opt.undodir = vim.fn.expand("~/.local/share/nvimundo")
            vim.opt.updatetime = 300
            vim.opt.timeoutlen = 500
            vim.opt.ttimeoutlen = 0
            vim.opt.autoread = true
            vim.opt.autowrite = false        -- don't autosave

            -- Behavior
            vim.opt.hidden = true
            vim.opt.errorbells = false
            vim.opt.backspace = "indent,eol,start"
            vim.opt.autochdir = false
            vim.opt.iskeyword:append("-")
            vim.opt.path:append("**")
            vim.opt.selection = "exclusive"
            vim.opt.mouse = "a"
            vim.opt.clipboard = "unnamedplus"
            vim.opt.modifiable = true
            vim.opt.encoding = "UTF-8"

            -- Y to EOL
            vim.keymap.set("n", "Y", "y$", { desc = "Yank to the endo fo line" })

            -- Center screen when jumping
            vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result" })
            vim.keymap.set("n", "N", "Nzzzv", { desc = "Next search result" })
            vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
            vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

            -- Key mappings
            vim.g.mapleader = " "
            vim.g.maplocalleader = " "

            -- window navigation
            vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "window below" })
            vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "window left" })
            vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "window above" })
            vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "window right" })

            -- Buffer navigation
            vim.keymap.set("n", "<c-right>", ":bn<CR>", { desc = "Next buffer" })
            vim.keymap.set("n", "<c-left>", ":bp<CR>", { desc = "Previous buffer" })


            vim.keymap.set("n", "<Up>", ":resize +2<CR>", { desc = "Increase window height" })
            vim.keymap.set("n", "<Down>", ":resize -2<CR>", { desc = "Decrease window height" })
            vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", { desc = "Decrease window height" })
            vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", { desc = "Increase window height" })

            -- Regels verplaatsen
            vim.keymap.set("n", "<M-j>", ":m .+1<CR>==", { desc = "Move line down"})
            vim.keymap.set("n", "<M-k>", ":m .-2<CR>==", { desc = "Move line up" })
            vim.keymap.set("x", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
            vim.keymap.set("x", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

            -- orientatie
            --
            vim.keymap.set ('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>', {desc ="Set working directory to current file"})
            -- telescope
            vim.keymap.set("n", "<leader>ff", function()
                require("telescope.builtin").find_files()
            end)

            vim.keymap.set("n", "<leader>fg", function()
                require("telescope.builtin").live_grep()
            end)

            vim.keymap.set("n", "<leader>fb", function()
                require("telescope.builtin").buffers()
            end)

            -- Oil
            vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "Open Oil file explorer" })

            -- commandline completion
            vim.opt.wildmenu = true
            vim.opt.wildmode = "longest:full,full"
            vim.opt.wildignore:append({"*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

            -- Better indenting in visual mode
            vim.keymap.set("x", "<", "<gv", { desc = "Indent left and reselect" })
            vim.keymap.set("x", ">", ">gv", { desc = "Indent right and reselect" })

            -- copilot
            vim.api.nvim_set_keymap('i', '<m-c>', 'copilot#Accept("<CR>")', {expr = true, silent = true, desc = "Accept Copilot suggestion"})
            vim.api.nvim_set_keymap('i', '<m-e>', 'copilot#Dismiss()', {expr = true, silent = true, desc = "Dismiss Copilot suggestion"})

            -- toggle spellcheck
            vim.keymap.set('n', '<leader>sp', ':setlocal spell!<CR>', { desc = "Toggle spellcheck" })

            -- Performance
            vim.opt.diffopt:append("linematch:60")
            vim.opt.redrawtime = 10000
            vim.opt.maxmempattern = 20000

            -- Verbeteringen
            local augroup = vim.api.nvim_create_augroup("UserConfig", {})
            vim.api.nvim_create_autocmd("TextYankPost", {
                group = augroup,
                callback = function()
                    vim.highlight.on_yank()
                end,
            })

            -- create undodir 
            local undodir = vim.fn.expand("~/.local/share/nvimundo")
            if vim.fn.isdirectory(undodir) == 0 then
                vim.fn.mkdir(undodir, "p")
            end

            -- ============================================================================
            -- FLOATING TERMINAL
            -- ============================================================================

            -- terminal
            local terminal_state = {
                buf = nil,
                win = nil,
                is_open = false
            }

            local function FloatingTerminal()
                -- If terminal is already open, close it (toggle behavior)
                if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
                    vim.api.nvim_win_close(terminal_state.win, false)
                    terminal_state.is_open = false
                    return
                end

                -- Create buffer if it doesn't exist or is invalid
                if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
                    terminal_state.buf = vim.api.nvim_create_buf(false, true)
                    -- Set buffer options for better terminal experience
                    vim.bo[terminal_state.buf].bufhidden = 'hide'
                end

                -- Calculate window dimensions
                local width = math.floor(vim.o.columns * 0.8)
                local height = math.floor(vim.o.lines * 0.8)
                local row = math.floor((vim.o.lines - height) / 2)
                local col = math.floor((vim.o.columns - width) / 2)

                -- Create the floating window
                terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
                    relative = 'editor',
                    width = width,
                    height = height,
                    row = row,
                    col = col,
                    style = 'minimal',
                    border = 'rounded',
                })

                -- Set transparency for the floating window
                vim.wo[terminal_state.win].winblend = 0
                vim.wo[terminal_state.win].winhighlight = 'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder'

                -- Define highlight groups for transparency
                vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
                vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none", })

                -- Start terminal if not already running
                local has_terminal = false
                local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
                for _, line in ipairs(lines) do
                    if line ~= "" then
                        has_terminal = true
                        break
                    end
                end

                if not has_terminal then
                    local shell

                    if vim.loop.os_uname().sysname == "Windows_NT" then
                        if vim.fn.executable("pwsh") == 1 then
                            shell = "pwsh"
                        else
                            shell = os.getenv("COMSPEC") or "cmd.exe"
                        end
                    else
                        shell = os.getenv("SHELL") or "/bin/sh"
                    end

                    vim.fn.termopen(shell)  
                end

                terminal_state.is_open = true
                vim.cmd("startinsert")

                -- Set up auto-close on buffer leave 
                vim.api.nvim_create_autocmd("BufLeave", {
                    buffer = terminal_state.buf,
                    callback = function()
                        if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
                            vim.api.nvim_win_close(terminal_state.win, false)
                            terminal_state.is_open = false
                        end
                    end,
                    once = true
                })
            end

            -- Function to explicitly close the terminal
            local function CloseFloatingTerminal()
                if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
                    vim.api.nvim_win_close(terminal_state.win, false)
                    terminal_state.is_open = false
                end
            end

            -- Key mappings
            vim.keymap.set("n", "<leader>t", 
            FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
            vim.keymap.set("t", "<Esc>", 
            CloseFloatingTerminal, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })


            -- ============================================================================
            -- Separate configs 
            -- ============================================================================
            require("statusline")
            require("neovide")

            -- ============================================================================
            -- BUFFER/FILE UTILITIES
            -- ============================================================================
            -- Close all buffers except current
            vim.keymap.set('n', '<leader>bo', ':%bd|e#|bd#<CR>', { desc = 'Close all buffers except current' })


