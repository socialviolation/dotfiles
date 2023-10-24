return {
    {
        'folke/neodev.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local neodev_status_ok, neodev = pcall(require, 'neodev')

            if not neodev_status_ok then
                return
            end

            neodev.setup()
        end
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        cmd = 'Mason',
        branch = 'v2.x',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            {
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end
            },
            { 'williamboman/mason-lspconfig.nvim', },

            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            {
                'L3MON4D3/LuaSnip',
                dependencies = { "rafamadriz/friendly-snippets" },
                build = "make install_jsregexp"
            },
            { 'SmiteshP/nvim-navic' }
        },
        config = function()

            local lsp = require('lsp-zero').preset({})

            local navic = require('nvim-navic')

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({buffer = bufnr})
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end)

            require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
            require("mason").setup({})
            require("mason-lspconfig").setup({
                    -- Replace the language servers listed here
                    -- with the ones you want to install
                ensure_installed = {'gopls'},
                handlers = {
                    lsp.default_setup,
                    lua_ls = function()
                        local lua_opts = lsp.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                },
            })


            lsp.setup()
            local cmp = require('cmp')
            -- local cmp_action = require('lsp-zero').cmp_action()
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_snipmate').lazy_load()
            local cmp_select = {behavior = cmp.SelectBehavior.Select}
            cmp.setup({
                sources = {
                    {name = 'path'},
                    {name = 'nvim_lsp'},
                    {name = 'nvim_lua'},
                },
                formatting = lsp.cmp_format(),
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
            })        
        end
        },
    { 'saadparwaiz1/cmp_luasnip' },
        -- {
            --     'dgagn/diagflow.nvim',
            --     opts = {
                --         -- placement = 'inline',
                --         scope = 'line',
                --         padding_right = 5
                --     }
                -- }
}
