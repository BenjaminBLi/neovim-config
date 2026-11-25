return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup({
            options = {
                -- follows the active colorscheme (rose-pine)
                theme = 'auto'
            }
        })
    end
}
