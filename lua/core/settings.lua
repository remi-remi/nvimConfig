-- Enable syntax highlighting
vim.cmd("syntax on")

-- Set leader key
vim.g.mapleader = ' '

-- UI
vim.opt.number = true                      -- Show line numbers
vim.opt.relativenumber = false            -- Show relative line numbers
vim.opt.cursorline = true                 -- Highlight current line
vim.opt.signcolumn = 'yes'                -- Always show sign column
vim.opt.scrolloff = 5                     -- Keep 5 lines visible above/below cursor
vim.opt.termguicolors = true              -- Enable true colors in terminal
vim.opt.wrap = false                      -- Disable line wrapping
vim.opt.mouse = 'a'                       -- Enable mouse in all modes

-- Encoding
vim.opt.encoding = 'utf-8'                -- Set internal encoding
vim.opt.fileencoding = 'utf-8'            -- Set file encoding

-- Indentation
vim.opt.expandtab = true                  -- Use spaces instead of tabs
vim.opt.shiftwidth = 3                    -- Indent width
vim.opt.softtabstop = 3                   -- Tab key inserts 3 spaces
vim.opt.tabstop = 3                       -- Tab character is 3 spaces
vim.opt.smartindent = true                -- Smart autoindenting

-- Search
vim.opt.ignorecase = true                 -- Ignore case in search
vim.opt.smartcase = true                  -- But override if uppercase in pattern
vim.opt.incsearch = true                  -- Show search matches as you type

-- Split behavior
vim.opt.splitbelow = true                 -- Horizontal splits open below
vim.opt.splitright = true                 -- Vertical splits open right

-- Undo
vim.opt.undofile = true                   -- Persistent undo
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

