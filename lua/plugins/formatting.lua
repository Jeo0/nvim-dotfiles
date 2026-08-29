-- Wires up the formatters/linters mason-tool-installer already installs
-- (see plugins/mason.lua: prettier, stylua, isort, black, pylint, eslint_d).
-- No format-on-save here on purpose, since lspconfig.lua's on_attach note
-- says that was disabled deliberately — use <leader>lf to format manually.
-- Linting runs automatically (it only reports, it never rewrites your buffer).

return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>lf",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = { "n", "v" },
                desc = "Format buffer/selection",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                jsonc = { "prettier" },
                yaml = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                markdown = { "prettier" },
                -- c/cpp/rust: no formatter listed → falls back to the LSP
                -- formatter (clangd / rust_analyzer) via lsp_format above.
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufWritePost", "BufReadPost", "InsertLeave" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                python = { "pylint" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
