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
vim.api.nvim_set_keymap('i', '<C-H>', '<C-W>', {noremap=true})


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
