{ pkgs, nixvim, programs, ... }:

{
  programs.nixvim = {
    enable = true;
    globals.mapleader = " ";

    relativenumber = true;
    incsearch = true;

    plugins.lualine.enable = true;
    plugins.nix.enable = true;

    plugins.treesitter.enable = true;

    plugins.telescope.enable = true;
    plugins.mini-icons.enable = true;
    plugins.mini-icons.mockDevIcons = true;

    plugins.lsp = {
      keymaps = {
        silent = true;
        diagnostic = {
          "<leader>k" = "goto_prev";
          "<leader>j" = "goto_next";
        };

        lspBuf = {
          gd = "definition";
          K  = "hover";
        };
      };
    };
  };
}
