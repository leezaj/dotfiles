-- Bootstrap lazy.vim (copy-pasted from https://github.com/folke/lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Remap the leader key to space bar
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

----------------------------------------------
-----MAKE RECORDING WORK WITH cmdheight=0-----
----------------------------------------------
local function get_recording ()
  local reg = vim.fn.reg_recording()
  return reg == "" and reg or "Recording @"..reg
end

vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    require("lualine").refresh({place = {"statusline"}})
  end
})
-- thanks to /u/Treatybreaker on /r/neovim for the idea
-- https://old.reddit.com/comments/xy0tu1/-/irfegvd/
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    vim.loop.new_timer():start( 1, 0, vim.schedule_wrap(function()
      require("lualine").refresh({ place = { "statusline" },})
    end)
    )
  end,
})

----------------------------------------------
---END MAKE RECORDING WORK WITH cmdheight=0---
----------------------------------------------

----------------------------------------------
---------------PLUGIN SETUP-------------------
----------------------------------------------
require('lazy').setup({
  -- latex utilities
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.g.vimtex_view_method = "zathura"
    end
  },
  -- status line, winbar and tabline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      -- winbar at the top to show code context
      "SmiteshP/nvim-navic",
      dependencies = {"neovim/nvim-lspconfig"},
      config = function()
        require("nvim-navic").setup({
          highlight = true,
          icons = {
            File = ' ',
            Module = ' ',
            Namespace = ' ',
            Package = ' ',
            Class = ' ',
            Method = ' ',
            Property = ' ',
            Field = ' ',
            Constructor = ' ',
            Enum = ' ',
            Interface = ' ',
            Function = ' ',
            Variable = ' ',
            Constant = ' ',
            String = ' ',
            Number = ' ',
            Boolean = ' ',
            Array = ' ',
            Object = ' ',
            Key = ' ',
            Null = ' ',
            EnumMember = ' ',
            Struct = ' ',
            Event = ' ',
            Operator = ' ',
            TypeParameter = ' '
          },
        })
      end
    },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = false,
          component_separators = { left = "|", right = "|"},
          section_separators = { left = "", right = ""},
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'filename', "vim.fn['zoom#statusline']()", },
          lualine_c = {
            'branch',
            { 'diagnostics', sources = {'nvim_diagnostic', 'nvim_lsp'} },
            {"get-recording-status", fmt = get_recording}
          },
          lualine_x = {"encoding", "fileformat", "filetype"},
          lualine_y = {},
          lualine_z = {"%l/%L,%c"}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {"%l/%L,%c"},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {
          lualine_a = {
          {
            "tabs",
            mode = 2, -- Shows tab_nr + tab_name
            max_length = vim.o.columns,
          },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        winbar = {
          lualine_c = {
            "navic",
          },
        },
      })
    end,
  },
  -- zoom split panes
  {"dhruvasagar/vim-zoom",
  config = function ()
    vim.keymap.set("n", "<C-w>z", "<Plug>(zoom-toggle)")
  end},
  -- required for telescope (PLEASE MAKE THIS A DEPENDENCY)
  "nvim-lua/plenary.nvim",
  -- LSP setup
  "neovim/nvim-lspconfig",
  -- show indents as vertical lines
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        scope = {
          exclude = {
            language = {"cpp", "swift"}
          }
        }
      })
    end,
  },
  -- color theme
  {
    "bluz71/vim-moonfly-colors", name="moonfly", lazy=false, priority = 1000,
    config = function()
      -- Make the split separators thin with our color scheme
      vim.g.moonflyWinSeparator = 2
      -- Enable transparent background
      vim.g.moonflyTransparent = true
      -- Matching parenthesis will be underlined
      vim.g.moonflyUnderlineMatchParen = true
      vim.cmd [[colorscheme moonfly]]
    end
  },
  -- autocomplete brackets or quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/nvim-cmp",
      dependencies = {
        { "hrsh7th/cmp-buffer"},  {"hrsh7th/cmp-path"},
        {"hrsh7th/cmp-cmdline"},  {"hrsh7th/cmp-nvim-lsp"},
        {"L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
        {"saadparwaiz1/cmp_luasnip"}, {"hrsh7th/cmp-nvim-lsp-signature-help"},
      },
    },
    config = function()
      require("nvim-autopairs").setup {}
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  -- lsp symbol renamer
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", {silent=true} },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", {silent=true}},
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", {silent=true}},
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", {silent=true}},
      { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", {silent=true}},
    },
    config = function ()
      vim.g.tmux_navigator_disable_when_zoomed=1
    end
  },
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {"c", "lua", "vim", "vimdoc", "query"},
        sync_install = false,
        auto_install = true,
        highlight = {enable = true, disable = {}},
      })
    end
  },
  {
    "danymat/neogen",
    dependencies = {"L3MON4D3/LuaSnip"},
    config = function()
      require("neogen").setup({ {snippet_engine = "luasnip"}, })
      vim.keymap.set("n", "<Leader>@", require("neogen").generate,
        {noremap = true, silent = true})
    end,
  },
})
----------------------------------------------
---------------END PLUGIN SETUP---------------
----------------------------------------------

-- always show the status line
vim.opt.laststatus = 2

-- only show the tabline if there is more than one tab
vim.opt.showtabline = 1

-- spawn splits on the right and on the bottom
vim.opt.splitbelow = true
vim.opt.splitright = true

-- hide the command line
vim.opt.cmdheight = 0

-- Set tab to two spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
vim.opt.softtabstop = -1
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.autoindent = true

-- TESTING
vim.g.editorconfig = false

-- Add a column margin of 120 characters and wrap text if it is exceeded
local width = 120
vim.opt.colorcolumn = tostring(width)
vim.opt.tw = width

-- relative line numbers
vim.opt.relativenumber = true

-- Automatically go a file's directory when we open it
vim.opt.autochdir = true

-- Not sure what this is, but we don't need it
vim.opt.modeline = false

-- Better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Combine signs and numbers
vim.opt.signcolumn = "number"

-- FOLDING TEST, DELETE IF USELESS
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Clears search highlights when pressing Backslash
vim.keymap.set("n", "\\", ":noh<CR>", {noremap=true, silent=true})

-- Toggle spellcheck
vim.keymap.set("n", "<F3>", function()
  vim.opt.spell = not(vim.opt.spell:get())
end)

-- Go to tab with ALT+number
for i=1, 9 do
  vim.keymap.set("n", "<A-"..i..">", i.."gt")
end

-- Pop the tag stack with 'gb' (go back)
vim.keymap.set("n", "gb", ":pop<CR>")

-- Leader B for buffers
vim.keymap.set("n", "<Leader>b", ":buffers<CR>:buffer<Space>", {noremap=true})

-- Make functions italic
local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "moonfly",
  callback = function()
    vim.api.nvim_set_hl(0, "Function", { fg = "#74b2ff", italic = true })
  end,
  group = custom_highlight,
})

-- Show relative line numbers in explorer mode
vim.g.netrw_bufsettings = "nonu noma nomod nobl nowrap ro rnu"

-- Save without letting go of the shift button as we are lazy
vim.api.nvim_create_user_command("W", "write", {})

-- Hide line numbers in terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
  command = "setlocal nonumber norelativenumber"
})

----------------------------------------------------------------------------

-- nvim-cmp supports additional completion capabilities
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities()

--  Enable the following language servers
local servers = { 'clangd' , 'pyright', 'sourcekit' }
local command = {}
command.clangd = {
  "clangd",
  "--pch-storage=memory",
  "--header-insertion=never",
  "--j=8",
  "--malloc-trim",
  "--background-index",
  "--background-index-priority=normal",
  "--clang-tidy"
}

local lspconfig = require 'lspconfig'
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    cmd = command[lsp]
  }
end

-- lua is special I guess
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      diagnostics = {
        globals = {'vim'}
      }
    },
  },
}

local cmp = require 'cmp'
local luasnip = require 'luasnip'
local neogen = require("neogen")
cmp.setup {
  enabled = function ()
    local context = require("cmp.config.context")
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    else
      return not context.in_treesitter_capture("comment")
        and not context.in_syntax_group("Comment")
    end
  end,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-j>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if luasnip.expandable() then
          luasnip.expand()
        else
          cmp.confirm({
            select = true,
          })
        end
      else
        fallback()
      end
    end),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if neogen.jumpable() then
        neogen.jump_next()
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if neogen.jumpable(true) then
        neogen.jump_prev()
      elseif cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-e>'] = cmp.mapping(function()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      end
    end, {'i', 's' }),
  }),
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip' },
    {name = 'nvim_lsp_signature_help'},
    {name = "buffer"},
    {name = "path"},
  }
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local attach_opts = { silent = true, buffer = bufnr }
    if client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, bufnr)
    end
    if(client.name == 'clangd') then
      vim.keymap.set('n', '<leader>w', '<cmd>ClangdSwitchSourceHeader<cr>', attach_opts)
    end
    if client.server_capabilities.inlayHintProvider then
      local function toggle_inlay_hints()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
          { bufnr = bufnr }
        )
      end
      vim.keymap.set("n", "<Leader>i", toggle_inlay_hints, attach_opts)
    end
    local function toggle_diagnostics()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled(), {bufnr = bufnr})
    end
    vim.keymap.set("n", "<Leader><C-i>", toggle_diagnostics, attach_opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, attach_opts)
    vim.keymap.set('n', 'gr', function()
      vim.lsp.buf.references({ includeDeclaration = false })
    end, attach_opts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
    vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
   -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, attach_opts)
   -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, attach_opts)
   -- vim.keymap.set('n', '<leader>wl', function()
   --    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
   --  end, attach_opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
    -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
    vim.keymap.set('n', '<C-.>', vim.lsp.buf.code_action, attach_opts)
    -- vim.keymap.set('n', 'so', require('telescope.builtin').lsp_references, attach_opts)
    vim.keymap.set('n', '<F2>', ":IncRename ", attach_opts)
    vim.opt_local.pumheight = 25
  end,
})

-- Diagnostic keymaps
vim.diagnostic.config({
  underline = true,
  signs = true,
  float = {
    show_header = true,
    source = "always",
  },
})
vim.keymap.set('n', 'gh', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setqflist)
