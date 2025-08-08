{ pkgs, ... }:
[
  {
    name = "zsh-autosuggestions";
    src = pkgs.zsh-autosuggestions;
    file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
  }
  {
    name = "zsh-completions";
    src = pkgs.zsh-completions;
    file = "share/zsh-completions/zsh-completions.zsh";
  }
  {
    name = "zsh-syntax-highlighting";
    src = pkgs.zsh-syntax-highlighting;
    file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
  }
  {
    name = "fzf-tab";
    src = pkgs.zsh-fzf-tab;
    file = "share/fzf-tab/fzf-tab.plugin.zsh";
  }
]
