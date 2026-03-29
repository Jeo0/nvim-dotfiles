---------------------------------------
-- KEYMAPS
---------------------------------------
-- cheatsheet 
-- <C-h> 	backspace
-- <C-i> 	tab
-- <C-[>	esc
-- <C-m>	enter
-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ctrl backspace or <c-H> delete word
vim.api.nvim_set_keymap('i', '<C-BS>', '<C-W>', {noremap=true})

local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Window Navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

-- Resize Windows
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")

-- NeoTree
map("n", "<leader>e", "<CMD>Neotree toggle<CR>")
map("n", "<leader>r", "<CMD>Neotree focus<CR>")

-- telescope
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
