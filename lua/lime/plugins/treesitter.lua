return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local treesitter = require("nvim-treesitter")

        treesitter.setup({})

        -- A list of parser names to keep installed
        local ensure_installed = {
            "vimdoc", "javascript", "typescript", "c", "lua", "rust",
            "jsdoc", "bash", "markdown", "markdown_inline", "templ",
        }

        -- Install the parsers that are missing (async, only on first start)
        local installed = treesitter.get_installed("parsers")
        local missing = vim.tbl_filter(function(lang)
            return not vim.tbl_contains(installed, lang)
        end, ensure_installed)
        if #missing > 0 then
            treesitter.install(missing)
        end

        -- Languages that still want `:h syntax` on top of tree-sitter
        local additional_vim_regex_highlighting = { "markdown" }

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("Lime_Treesitter", { clear = true }),
            callback = function(e)
                local lang = vim.treesitter.language.get_lang(vim.bo[e.buf].filetype)
                if not lang or not vim.tbl_contains(treesitter.get_installed("parsers"), lang) then
                    return
                end

                -- highlighting
                if not pcall(vim.treesitter.start, e.buf, lang) then
                    return
                end

                -- indentation
                vim.bo[e.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                if vim.tbl_contains(additional_vim_regex_highlighting, lang) then
                    vim.bo[e.buf].syntax = "on"
                end
            end,
        })
    end,
}
