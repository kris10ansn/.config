vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/stevearc/oil.nvim" },
});

require "mini.pick".setup();
require "oil".setup()

require "catppuccin".setup()
vim.cmd("colorscheme catppuccin")


vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.signcolumn = "yes";
vim.opt.termguicolors = true;
vim.opt.wrap = false;
vim.opt.tabstop = 4;
vim.opt.swapfile = false;
vim.opt.winborder = "rounded";
vim.opt.clipboard = "unnamedplus";

vim.keymap.set('n', '<leader>w', ':write<CR>');
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')

vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")
vim.keymap.set('n', '<leader>e', ":Oil<CR>")
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)



