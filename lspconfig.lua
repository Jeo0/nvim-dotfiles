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
        -- NOTE: mason.setup() is already called in mason.lua — removed duplicate call here

        local mason_lspconfig = require("mason-lspconfig")

        -- FIX #2: Tell mason-lspconfig which servers to auto-install on first launch.
        -- Without this list, NO servers are ever installed automatically and LSP
        -- never attaches, so gd / Ctrl+] / hover all silently do nothing.
        mason_lspconfig.setup({
            ensure_installed = {
                "clangd",   -- C / C++
                "pyright",  -- Python
                "lua_ls",   -- Lua (handy for editing your own config)
            },
        })

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Add borders to LSP hover windows
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, { border = "rounded" }
        )
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help, { border = "rounded" }
        )

        local formatting_augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }

            -- KEYMAPS FOR NAVIGATION
            vim.keymap.set('n', 'K',          vim.lsp.buf.hover,        opts)
            vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,   opts)
            -- FIX #1: Ctrl+] was the old *ctags* jump — it needs a tags file, not LSP.
            -- Remap it here so it calls LSP definition instead.
            vim.keymap.set('n', '<C-]>',      vim.lsp.buf.definition,   opts)
            vim.keymap.set('n', 'gD',         vim.lsp.buf.declaration,  opts)
            vim.keymap.set('n', 'gi',         vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', 'gr',         vim.lsp.buf.references,   opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,       opts)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,  opts)
            vim.keymap.set('i', '<C-k>',      vim.lsp.buf.signature_help, opts)

            require("lsp_signature").on_attach({
                bind = true,
                handler_opts = { border = "rounded" },
                hint_enable = false,
            }, bufnr)

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

        -- Setup handlers for all Mason-managed servers
        mason_lspconfig.setup_handlers({
            -- Default handler — runs for every installed server not listed below
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end,

            -- C / C++ — clangd works best when a compile_commands.json exists at
            -- the project root. Generate one with cmake (-DCMAKE_EXPORT_COMPILE_COMMANDS=ON)
            -- or Bear (bear -- make). Without it, cross-file navigation is unreliable.
            ["clangd"] = function()
                lspconfig.clangd.setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                    },
                })
            end,

            -- Python
            ["pyright"] = function()
                lspconfig.pyright.setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end,
        })

        -- FIX #3: Godot / GDScript LSP is NOT available through Mason.
        -- The language server is built into Godot itself and listens on a local port
        -- (default 6005). TWO things are required:
        --   1. Godot must be running.
        --   2. In Godot: Editor → Editor Settings → Network → Language Server
        --      → "Use Built-in Server" must be ON, then restart Godot.
        -- After both are true, opening a .gd file here will attach automatically.
        lspconfig.gdscript.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
    end,
}
