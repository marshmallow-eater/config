local vim = vim

vim.o.background = "dark"
vim.o.shell = "/bin/fish"

vim.g.shiftwidth = 2
vim.g.encoding = 'UTF-8'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.netrw_banner = 0
vim.wo.wrap = false
vim.g.rooter_patterns = {
  '.git',
  'Makefile',
  '*.sln',
  'build/env.sh',
}

-- Set Neotree as the default file explorer
vim.g.explorer_open_file_with = 'neotree'
vim.g.neotree_show_hidden = 1

vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_scroll_animation_length = 0


-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)
vim.opt.clipboard = 'unnamedplus'

require('lazy').setup({
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "c", "gdscript" },
        sync_install = true,
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = { enable = true },
      })
    end,
  },
  -- NOTE: First, some plugins that don't require any configuration
  'ryanoasis/vim-devicons',
  'ThePrimeagen/harpoon',
  -- Git related plugins
  'airblade/vim-rooter',
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
  },
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  'mhinz/vim-startify',
  'mbbill/undotree',
  'tribela/vim-transparent',
  'ray-x/lsp_signature.nvim',
  {
    "mfussenegger/nvim-jdtls",
  },
  {
    "microsoft/java-debug",
  },
  {
    "microsoft/vscode-java-test",
  },
  {
    "hrsh7th/cmp-nvim-lsp"
  },
  {
    "hrsh7th/cmp-vsnip"
  },
  {
    "hrsh7th/vim-vsnip"
  },
  {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      -- Use eslint_d for faster linting and formatting
      formatters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      },
      -- This is the key part for "fix on save"
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    opts = {},
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
  },
  {
    "onsails/lspkind.nvim"
  },
  {
    'sainnhe/everforest',
    config = function()
      vim.cmd "colorscheme everforest"
    end
  },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    'nvim-neo-tree/neo-tree.nvim',
    opts = {
      window = {
        position = "float",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  },
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = "legacy", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip'
    },
  },

  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    config = function()
      vim.fn["mkdp#util#install"]()
    end
  },
  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
    },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  },

  {
    'Pocco81/auto-save.nvim',
  }

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  --
  --    An additional note is that if you only copied in the `init.lua`, you can just comment this line
  --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
}, {})

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = true,
    virtual_text = {
      spacing = 5,
      severity_limit = 'Warning',
    },
    update_in_insert = true,
  }
)

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

vim.wo.relativenumber = true
-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.opt.clipboard = "unnamedplus"

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = true,
        ['<C-d>'] = true,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(
  require('telescope').load_extension,
  'fzf',
  'live_grep_args'
)


vim.keymap.set('n', '<C-l>', '<C-W>l', { desc = 'move right' })
vim.keymap.set('n', '<C-h>', '<C-W>h', { desc = 'move left' })
vim.keymap.set('n', '<C-j>', '<C-W>j', { desc = 'move down' })
vim.keymap.set('n', '<C-k>', '<C-W>k', { desc = 'move up' })

vim.keymap.set('n', '<leader>=', 'ggvG=', { desc = 'indente all file' })
vim.keymap.set('n', '<leader>v', ':vsplit<CR><C-W>l', { desc = 'split [V]ertically' })

vim.keymap.set('n', '<leader>ha', ':lua require("harpoon.mark").add_file()<CR>', { desc = '[H]arpoon [A]dd' })
vim.keymap.set('n', '<leader>hd', ':lua require("harpoon.mark").rm_file()<CR>', { desc = '[H]arpoon [D]elete' })
vim.keymap.set('n', '<leader>hm', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { desc = '[H]arpoon [M]enu' })

vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = '[Q]uit' })
vim.keymap.set('n', '<leader>l', ':noh<CR>', { desc = 'remove high[L]ight', silent = true })
vim.keymap.set('n', '<leader>e', ':Neotree reveal position=float<CR>', { desc = '[E]xplorer here' })

-- begin Terminal
vim.keymap.set('t', '<leader>q', '<C-\\><C-n>:q<CR>', { desc = 'Quit insert mode in terminal' })

vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-W>l', { desc = 'move right' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-W>h', { desc = 'move left' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-W>j', { desc = 'move down' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-W>k', { desc = 'move up' })

vim.keymap.set('n', '<leader>tv', ':vsplit<CR><C-W>l:terminal<CR>i', { desc = '[T]erminal [V]ertical' })
vim.keymap.set('n', '<leader>th', ':split<CR><C-W>j:terminal<CR>i', { desc = '[T]erminal [H]orizontal' })
vim.keymap.set('n', '<leader>tt', ':tabnew<CR>:terminal<CR>i', { desc = '[T]erminal [T]ab' })
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { desc = "toggle [U]ndotree" })
-- end Terminal

vim.keymap.set('n', '<leader>td', '<cmd>Trouble diagnostics toggle<cr>', { desc = '[T]rouble [D]ocument' })

vim.keymap.set('n', '<leader>bn', ':tabNext<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', ':tabprevious<CR>', { desc = '[B]uffer [P]revious' })
vim.keymap.set('n', '<leader>bx', ':tabclose<CR>', { desc = '[B]uffer [X]close' })
vim.keymap.set('n', '<leader>bc', ':tabnew<CR>', { desc = '[B]uffer [C]reate' })

-- See `:help telescope.builtin`
--
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').oldfiles, { desc = '[S]earch [R]ecent files' })
vim.keymap.set('n', '<leader>sj', require('telescope.builtin').jumplist, { desc = '[S]earch [J]umplist' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set("n", "<leader>sg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostic' })
vim.keymap.set('n', '<leader>sv', require('telescope.builtin').lsp_document_symbols, { desc = '[S]earch [V]ariables' })

vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('ga', vim.diagnostic.open_float, 'Open Diagnostics')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  eslint = {},
  gopls = {},
  ts_ls = {},
  lua_ls = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        }
      },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      }
    end,
  }
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

local lspkind = require 'lspkind'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
      before = function(_, vim_item)
        return vim_item
      end
    })
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'vsnip' }
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
