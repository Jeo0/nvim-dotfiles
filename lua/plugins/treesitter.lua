
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        -- ── Neovim 0.12 compat patch ──────────────────────────────────────
        -- Nvim 0.12 changed match[id] passed into custom query predicate/
        -- directive handlers: it can now be a *list* of nodes instead of a
        -- bare TSNode. nvim-treesitter's `master` branch (frozen/archived,
        -- see nvim-treesitter/nvim-treesitter#8636) never got updated for
        -- this, so its markdown-injection directives crash with
        -- "attempt to call method 'range' (a nil value)" on every redraw
        -- of a buffer with a fenced code block (incl. LSP hover / cmp docs).
        -- This re-registers safe versions that unwrap the list first.
        do
            local ts_query = require("vim.treesitter.query")
            local opts = { force = true, all = false }

            local function get_node(match, id)
                local val = match[id]
                if not val then return nil end
                if type(val) == "table" and val.range == nil then
                    return val[1]
                end
                return val
            end

            ts_query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
                local id = pred[2]
                local node = get_node(match, id)
                if not node then return end
                local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
                metadata[id] = metadata[id] or {}
                metadata[id].text = string.lower(text)
            end, opts)

            ts_query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
                local node = get_node(match, pred[2])
                if not node then return end
                metadata["injection.language"] = vim.treesitter.get_node_text(node, bufnr):lower()
            end, opts)

            ts_query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
                local node = get_node(match, pred[2])
                if not node then return end
                local value = vim.treesitter.get_node_text(node, bufnr)
                metadata["injection.language"] = vim.split(value, "/", {})[2] or value
            end, opts)
        end
        -- ────────────────────────────────────────────────────────────────

        local treesitter = require("nvim-treesitter.configs")

        treesitter.setup({
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true, disable = { "c", "cpp" } },
            autotag = {
                enable = true,
            },
            ensure_installed = {
                "json", "javascript", "typescript", "tsx", "yaml", "html", "css",
                "markdown", "markdown_inline", "bash", "python", "lua", "vim",
                "dockerfile", "gitignore", "c", "cpp", "rust",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
