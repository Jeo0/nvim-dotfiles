return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "ray-x/lsp_signature.nvim",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")

        mason.setup()
        mason_lspconfig.setup()

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        
        -- Add borders to LSP hover windows
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, { border = "rounded" }
        )
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help, { border = "rounded" }
        )

        -- Create augroup outside on_attach so it isn't cleared 
        -- every time a new buffer is opened.
        local formatting_augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

        -- 1. Create the on_attach function to fix K and gd
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }
            
            -- KEYMAPS FOR NAVIGATION
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)           -- Hover docs
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)    -- Go to definition
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)   -- Go to declaration
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)-- Go to implementation
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)    -- Show references
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)-- Smart rename
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- Code actions

            vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts) -- Manual signature help in Insert mode
            
            -- Initialize automatic signature help
            require("lsp_signature").on_attach({
                bind = true,
                handler_opts = {
                    border = "rounded"
                },
                hint_enable = false, -- Disable the virtual text hint if you only want the floating window
            }, bufnr)
            
            -- Format on save logic
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_clear_autocmds({ group = formatting_augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = formatting_augroup,
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
