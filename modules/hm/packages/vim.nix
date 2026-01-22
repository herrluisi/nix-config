{ pkgs, nixvim, programs, ... }:

{
  programs.nixvim = {
    enable = true;
    globals.mapleader = " ";

    relativenumber = true;
    incsearch = true;

    plugins = {
      lualine.enable = true;
      nix.enable = true;

      treesitter.enable = true;

      telescope.enable = true;
      mini-icons.enable = true;
      mini-icons.mockDevIcons = true;

      vim-nix.enable = true;
      lsp = {
        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lsBuf = {
            gd = "definition";
            K = "hover";
          };
        };
      };

      cmp = {
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        autoLoad = true;  
      };
    };
    clipboard.providers.wl-copy.enable = true;
  };
}
