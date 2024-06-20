
return {
    {
        'VonHeikemen/lsp-zero.nvim', branch = 'v3.x',
        dependencies = {
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            "j-hui/fidget.nvim",
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            local cmp = require('cmp')
            local cmp_lsp = require('cmp_nvim_lsp')
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())

            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({buffer = bufnr})
            end)

            local lspconfig = require("lspconfig")

            require("fidget").setup({})
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {"lua_ls", "tsserver", "pkgbuild_language_server"},
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,

                    ["lua_ls"] = function ()
                        lspconfig.lua_ls.setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim", }
                                    }
                                }
                            }
                        }
                    end,

                    ["tsserver"] = function ()
                        lspconfig.tsserver.setup({})
                    end,

                    ["pkgbuild_language_server"] = function ()
                        lspconfig.pkgbuild_language_server.setup({})
                    end,
                },
            })

            cmp.setup({
                preselect = 'item',
                completion = {
                    completeopt = 'menu,menuone,noinsert'
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item({behaviour = 'select'}),
                    ['<C-n>'] = cmp.mapping.select_next_item({behaviour = 'select'}),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({select = false}),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'buffer' },
                },
            })

            vim.diagnostic.config({
                float = {
                    border = 'rounded',
                },
            })

        end
    }
}
