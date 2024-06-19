function ColorMeDaddy(color)
    color = color or "rose-pine" 
    vim.cmd.colorscheme(color)
end 
return {
    {
        "oncomouse/lushwal.nvim",
        cmd = { "LushwalCompile" },
        dependencies = {
            { "rktjmp/lush.nvim" },
            { "rktjmp/shipwright.nvim" },
        },
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })

            vim.cmd("colorscheme rose-pine")

            ColorMeDaddy('lushwal')
        end
    },
}
