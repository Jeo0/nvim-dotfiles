-- Helper function for mappings
-- (Combines both your previous functions: defaults to silent, but allows custom opts)
local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    if opts.silent == nil then opts.silent = true end
    vim.keymap.set(mode, lhs, rhs, opts)
end

---------------------------------------
-- KEYMAPS
---------------------------------------

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ctrl backspace or <c-H> delete word
vim.api.nvim_set_keymap('i', '<C-BS>', '<C-W>', {noremap=true})

local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Window Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })

-- Resize Windows
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")

-- Ctrl+Backspace (Delete Word)
-- Note: <C-H> is essentially the same as <C-BS> in many terminals
map("i", "<C-H>", "<C-W>", { noremap = true })

-- NeoTree
map("n", "<leader>e", "<CMD>Neotree toggle<CR>", { desc = "Toggle NeoTree" })
map("n", "<leader>r", "<CMD>Neotree focus<CR>", { desc = "Focus NeoTree" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Fuzzy find recent files" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find string in cwd" })
map("n", "<leader>fs", "<cmd>Telescope git_status<cr>", { desc = "Find string under cursor in cwd" })
map("n", "<leader>fc", "<cmd>Telescope git commits<cr>", { desc = "Find todos" })

-- copy all
map("n", "<leader>c", "ggVGy", { desc = "copy all" })

-- search the word under the cursor (yank it)
-- map("n", "<leader>yw", "bvey<Esc>/<C-V><CR>", {desc = "word search under cursor"})
-- explanation: 
-- viw → select inner word
-- y → yank
-- / → search
-- <C-r>" → insert contents of the unnamed register
-- <CR> → run search
vim.keymap.set("n", "<leader>yw", "viwy/<C-r>\"<CR>", {
  desc = "yank + search word under cursor"
})

-- toggle comment 
map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment line" })
-- map("n", "<C-.>", "gcc", { remap = true, desc = "Toggle comment line" })

-- Toggle comment for the visual selection
map("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment selection" })
-- map("v", "<C-.>", "gc", { remap = true, desc = "Toggle comment selection" })


-- Copy Operations
map("n", "<leader>c", 'ggVG"+y', { desc = "Copy entire file" })

-- AI COPY 
-- grab lines, wrap them, and copy to system clipboard
-- without modifying the actual buffer
map("n", "<leader>C", function()
  -- 1. Get the path relative to CWD 
  --    %:p  = absolute path
  --    %:.  = relative to current directory
  local filename = vim.fn.expand("%:.")
  
  -- 2. Get the filetype (e.g., "lua", "python") for markdown code block
  local filetype = vim.bo.filetype 

  -- 3. Get all lines
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- 4. Construct the string
  --    Format:
  --    src/main.rs
  --    ```rust
  --    <code content>
  --    ```
  local content = filename .. ":\n```" .. filetype .. "\n" .. table.concat(lines, "\n") .. "\n```"

  -- 5. Copy to system clipboard
  vim.fn.setreg("+", content)

  -- 6. Notify
  vim.notify("Copied " .. filename, vim.log.levels.INFO)
end, { desc = "Copy file with AI formatting" })
