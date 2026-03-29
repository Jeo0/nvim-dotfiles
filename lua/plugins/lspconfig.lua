return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- 1. Create the on_attach function to fix K and gd
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }
            
            -- KEYMAPS FOR NAVIGATION
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)           -- Hover docs
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)    -- Go to definition
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)   -- Go to declaration
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)-- Go to implementation
            
            -- Format on save logic
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("Format", { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end
        end

        -- 2. Setup Mason-LSPConfig Handlers
        mason_lspconfig.setup_handlers({
            -- Default handler
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end,
            
            -- Specific overrides (if needed)
            ["clangd"] = function()
                lspconfig.clangd.setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    -- Add specific clangd flags here if you need them
                })
            end,
        })
    end,
}
