{
  apps = [
    # Основные утилиты
    { name = "coreutils"; type = "nix"; description = "GNU coreutils"; }
    { name = "curl"; type = "nix"; description = "Transfer tool"; }
    { name = "unzip"; type = "nix"; description = "Unzip files"; }
    { name = "zip"; type = "nix"; description = "Zip files"; }
    { name = "wget"; type = "nix"; description = "Downloader"; }
    { name = "tree"; type = "nix"; description = "Directory tree viewer"; }
    { name = "eza"; type = "nix"; description = "Enhanced ls"; }
    { name = "jq"; type = "nix"; description = "JSON processor"; }
    { name = "yq-go"; type = "nix"; description = "YAML processor"; }
    { name = "fzf"; type = "nix"; description = "Fuzzy finder"; }
    { name = "ripgrep"; type = "nix"; description = "Fast search"; }
    { name = "fd"; type = "nix"; description = "Find replacement"; }
    { name = "bat"; type = "nix"; description = "Syntax highlighting"; }
    { name = "zoxide"; type = "nix"; description = "Directory jumper"; }
    { name = "mkalias"; type = "nix"; description = "Alias creator"; }
    { name = "neofetch"; type = "nix"; description = "System info"; }
    { name = "gnupg"; type = "nix"; description = "Encryption tool"; }
    { name = "tmux"; type = "nix"; description = "Terminal multiplexer"; }
    { name = "ranger"; type = "nix"; description = "Terminal file manager"; }

    # Инструменты форматирования кода
    { name = "nixpkgs-fmt"; type = "nix"; description = "Nix code formatter"; }
    { name = "stylua"; type = "nix"; description = "Lua code formatter"; }
    { name = "prettier"; type = "nix"; description = "Code formatter for JS/JSON/YAML"; }
    { name = "shfmt"; type = "nix"; description = "Shell script formatter"; }
    { name = "sublime-text"; type = "cask"; description = "text editorx"; }

    # Разработка и DevOps
    { name = "docker"; type = "nix"; description = "Docker"; }
    { name = "qemu"; type = "brew"; description = "virtualization"; }
    { name = "neovim"; type = "nix"; description = "Text editor"; }
    { name = "zsh"; type = "nix"; description = "Shell"; }
    { name = "vagrant"; type = "cask"; description = "VM automation"; }
    #    { name = "vagrant-vmware-utility"; type = "cask"; description = "VM automation"; }
    { name = "git"; type = "nix"; description = "Version control"; }
    { name = "pyenv"; type = "nix"; description = "Python version manager"; }
    { name = "go"; type = "nix"; description = "Go language"; }
    { name = "rustup"; type = "nix"; description = "Rust manager"; }
    { name = "lua-language-server"; type = "nix"; description = "Lua LSP"; }
    { name = "kubectl"; type = "nix"; description = "Kubernetes CLI"; }
    { name = "kubernetes-helm"; type = "nix"; description = "K8s package manager"; }
    { name = "k9s"; type = "nix"; description = "K8s terminal UI"; }
    { name = "kubescape"; type = "nix"; description = "K8s security scanner"; }
    { name = "opentofu"; type = "nix"; description = "Terraform-compatible IAC"; }
    { name = "packer"; type = "nix"; description = "Machine image builder"; }
    { name = "colima"; type = "nix"; description = "Container runtime on macOS"; }
    { name = "talosctl"; type = "nix"; description = "Talos OS CLI"; }
    { name = "kustomize"; type = "nix"; description = "K8s YAML overlay tool"; }
    { name = "hubble"; type = "nix"; description = "K8s observability"; }
    { name = "hcloud"; type = "nix"; description = "Hetzner CLI"; }
    { name = "tenv"; type = "nix"; description = "Terraform version manager"; }
    { name = "awscli"; type = "nix"; description = "AWS CLI"; }
    { name = "vault"; type = "nix"; description = "Secrets manager"; }
    { name = "sops"; type = "nix"; description = "Secrets encryption tool"; }
    { name = "act"; type = "nix"; description = "Run GitHub Actions locally"; }
    { name = "bun"; type = "nix"; description = "JS/TS runtime"; }
    { name = "sqlc"; type = "nix"; description = "SQL codegen for Go"; }
    { name = "templ"; type = "nix"; description = "Template engine"; }
    { name = "nil"; type = "nix"; description = "Functional language"; }
    { name = "postgresql_16"; type = "nix"; description = "PostgreSQL 16"; }
    { name = "wireshark-app"; type = "cask"; description = "Network protocol analyzer"; }
    { name = "burp-suite"; type = "cask"; description = "Web security testing toolkit"; }
    { name = "postman"; type = "cask"; description = "Collaboration platform for API development"; }

    # Сетевые утилиты
    { name = "wireguard-tools"; type = "nix"; description = "WireGuard tools"; }
    { name = "wireguard-go"; type = "nix"; description = "Go WireGuard impl"; }
    { name = "iperf"; type = "nix"; description = "Bandwidth tester"; }
    { name = "nmap"; type = "nix"; description = "Network scanner"; }
    { name = "rclone"; type = "nix"; description = "Cloud storage sync"; }
    { name = "pass"; type = "nix"; description = "Password manager"; }
    { name = "zmap"; type = "brew"; description = "Network scanner for Internet-wide network studies"; }

    # Медиа и прочее
    { name = "ffmpeg"; type = "nix"; description = "Media processor"; }
    { name = "spicetify-cli"; type = "nix"; description = "Spotify theming"; }
    { name = "stripe-cli"; type = "nix"; description = "Stripe API CLI"; }

    # Homebrew brews
    { name = "mas"; type = "brew"; description = "Mac App Store CLI"; }
    { name = "nvm"; type = "brew"; description = "Node Version Manager"; }
    { name = "goenv"; type = "brew"; description = "Go version manager"; }
    { name = "tetra"; type = "brew"; description = "Terminal Tetris game"; }
    { name = "cdk8s"; type = "brew"; description = "K8s CDK"; }

    # Homebrew casks
    { name = "appcleaner"; type = "cask"; description = "Application uninstaller"; }
    { name = "yabai"; type = "nix"; description = "Tiling window manager"; }
    { name = "hammerspoon"; type = "cask"; description = "macOS automation"; }
    { name = "altserver"; type = "cask"; description = "Install iOS apps"; }
    { name = "gns3"; type = "cask"; description = "Network simulation"; }
    { name = "discord"; type = "cask"; description = "Chat app"; }
    { name = "telegram"; type = "cask"; description = "Messenger"; }
    { name = "spotify"; type = "cask"; description = "Music streaming"; }
    { name = "iterm2"; type = "cask"; description = "Terminal emulator"; }
    { name = "kitty"; type = "cask"; description = "Terminal emulator"; }
    { name = "arc"; type = "cask"; description = "Web browser"; }
    { name = "yandex"; type = "cask"; description = "Web browser"; }
    #        { name = "google-chrome"; type = "cask"; description = "Web browser"; }
    #        { name = "librewolf"; type = "cask"; description = "Privacy Web browser"; }
    #        { name = "firefox"; type = "cask"; description = "Web browser"; }
    { name = "intellij-idea"; type = "cask"; description = "Java IDE"; }
    { name = "cursor"; type = "cask"; description = "Write, edit, and chat about your code with AI"; }
    { name = "notion"; type = "cask"; description = "Notes & docs"; }
    { name = "obsidian"; type = "cask"; description = "Notes & docs"; }
    { name = "chatgpt"; type = "cask"; description = "ChatGPT for macOS"; }
  ];
}
