vim.g.mapleader = " "

local keymap = vim.keymap

-- <Space>g is moving the cursor, cancelling
keymap.set("n", "<leader>g", "<Nop>", { silent = true })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- windows management
keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
keymap.set("n", "<leader>wx", "<C-W>c", { desc = "Delete Window", remap = true })
keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })

-- Resize window using <ctrl> arrow keys
keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- buffers
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>bx", "<cmd>bd<cr>", { desc = "Close Buffer" })

-- Clear search with <esc>
keymap.set("n", "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- new file
keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Quickfix
keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
