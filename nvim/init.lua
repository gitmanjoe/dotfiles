-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{'nvim-telescope/telescope.nvim', tag = '0.1.8',dependencies = { 'nvim-lua/plenary.nvim' }},
	{"mason-org/mason.nvim", opts = {}},
	{"neovim/nvim-lspconfig"},
	{ 'RaafatTurki/hex.nvim' },
	{"hrsh7th/nvim-cmp",dependencies = { "hrsh7th/cmp-nvim-lsp" }},
	{'romgrk/barbar.nvim',dependencies = {'lewis6991/gitsigns.nvim'}, init = function() vim.g.barbar_auto_setup = false end, opts = {},version = '^1.0.0', },
	{"nvim-tree/nvim-tree.lua"},
	{"registerGen/clock.nvim"},
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{ 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }},
--	{'nvimdev/dashboard-nvim',event = 'VimEnter',config = function() require('dashboard').setup {} end, dependencies = { {'nvim-tree/nvim-web-devicons'}},
	{ "nvim-treesitter/nvim-treesitter",dependencies = { "OXY2DEV/markview.nvim" }, lazy = false,}

  },
  -- Configure any other settings here. See the documentation for more detais.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = true, -- disables setting the background color.
    float = {
        transparent = false, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
    },
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    auto_integrations = false,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

--Set Color scheme
vim.cmd.colorscheme "catppuccin"

--Enable Line Numbers
vim.wo.number = true

--Configure Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })

-- Basic completion setup
local cmp = require("cmp")

cmp.setup({
  completion = {
    autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
    completeopt = "menu,menuone,noinsert",
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
})

-- Needed to improve LSP capabilities for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.enable("pyright", { capabilities = capabilities })
vim.lsp.enable("omnisharp", { capabilities = capabilities })
vim.lsp.enable("clangd", { capabilities = capabilities })
vim.lsp.enable("asm-lsp", { capabilities = capabilities })
vim.lsp.enable("lua-language-server", { capabilities = capabilities })

-- Recommended UX tweaks
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.updatetime = 300

vim.diagnostic.config({
  update_in_insert = true
})

--Init File Browser
require("nvim-tree").setup()

--Set Keymaps
vim.keymap.set('n', '<C-z>', '<C-w>w', { noremap = true })
vim.keymap.set("n", "<leader>to", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>ct", ":ClockToggle<CR>")

--init Clock
require("clock").setup({
  auto_start = false,
  float = {
    border = "single",
    col_offset = 1,
    padding = { 1, 1, 0, 0 }, -- left, right, top, bottom padding, respectively
    position = "top", -- or "top"
    row_offset = 2,
    zindex = 40,
  },
  font = {
    -- the "font" of the clock text
    -- see lua/clock/config.lua for details
  },
  -- fun(c: string, time: string, position: integer): string
  -- <c> is the character to be highlighted
  -- <time> is the time represented in a string
  -- <position> is the position of <c> in <time>
  hl_group = function(c, time, position)
    return "NormalText"
  end,
  -- nil | fun(c: string, time: string, position: integer, pixel_row: integer, pixel_col: integer): string
  -- This function has higher priority than hl_group.
  hl_group_pixel = nil,
  separator = "  ", -- separator of two characters
  separator_hl = "NormalText",
  time_format = "%H:%M:%S",
  update_time = 500, -- update the clock text once per <update_time> (in ms)
})


-- Set kemaps for tabs
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)

map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)

-- Setup Bottom Line
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'nightfly',
--    component_separators = { left = '', right = ''},
--    section_separators = { left = '', right = ''},
    component_separators = { left = '|', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- hex viewer
require 'hex'.setup()
