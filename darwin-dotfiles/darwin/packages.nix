{ config, pkgs, ... }: {  # Обязательно передаем pkgs
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # Удаляет установленные пакеты при активации
    onActivation.autoUpdate = true;  # Включает автообновление пакетов
    brews = [
      "mas"  # Управление приложениями Mac App Store
      "nvm"  # Node Version Manager
      "goenv"  # Go environment manager
      "tetra"  # Тетрис
    ];
    casks = [
      # Утилиты
      "hammerspoon"  # Автоматизация с Hammerspoon
      "altserver"  # Инструмент для установки приложений на iOS
      "steam"  # Игровая платформа Steam
      "gns3"  # GNS3 — сетевое моделирование
      "virtualbox"  # Виртуализация через VirtualBox
      "discord"  # Discord
      "telegram"  # Telegram для macOS
      "spotify"  # Spotify

      # Браузеры
      "arc"  # Arc браузер
      "firefox"  # Firefox браузер

      # Программы для разработки
      "intellij-idea"  # IDE для разработки на Java
      "visual-studio-code"  # VS Code
      "notion"  # Notion для заметок
      "chatgpt"  # ChatGPT клиент для macOS
      "postman"  # Инструмент для API тестирования

      # Инструменты для работы с системой
      "karabiner-elements"  # Переназначение клавиш на macOS
    ];
  };

  environment.systemPackages = with pkgs; [
    # Основные утилиты
    yq-go # Portable command-line YAML processor
    coreutils  # Утилиты GNU coreutils
    curl  # Утилита для работы с URL
    unzip  # Утилита для разархивирования файлов
    zip  # Утилита для архивирования
    wget  # Утилита для скачивания файлов
    tree  # Отображение дерева каталогов
    eza  # Расширенная версия ls
    jq  # Утилита для обработки JSON
    nmap  # Сканер сети
    neofetch  # Информационный инструмент для терминала
    gnupg  # Инструмент для шифрования
    git  # Система контроля версий
    fzf  # Утилита для поиска и выбора
    yabai # wm

    # Разработка и DevOps
    neovim  # Редактор Neovim
    zsh  # Z shell
    ripgrep  # Быстрый поиск по файлам
    fd  # Быстрый аналог find
    bat  # Программа для подсветки синтаксиса файлов
    lua-language-server  # Сервер для поддержки Lua
    pyenv  # Менеджер версий Python
    go  # Язык программирования Go
    rustup  # Менеджер версий Rust
    kubectl  # Инструмент командной строки для Kubernetes
    kubernetes-helm  # Пакетный менеджер для Kubernetes
    kubescape #  Tool for testing if Kubernetes is deployed securely
    opentofu  # Управление инфраструктурой как код
    packer  # Инструмент для создания машинных образов
    colima  # Инструмент для работы с контейнерами на macOS
    k9s  # Инструмент для управления Kubernetes из терминала
    talosctl  # Инструмент для управления Talos OS
    kustomize  # Инструмент для работы с Kubernetes YAML
    hubble # cluster observe

    # Сетевые утилиты
    wireguard-tools  # Инструменты для работы с WireGuard VPN
    wireguard-go  # Реализация WireGuard на Go
    iperf  # Сетевой тестировщик пропускной способности
    rclone  # Работа с облачными хранилищами
    pass  # Менеджер паролей
    awscli  # AWS CLI
    act  # Запуск GitHub Actions локально
    vault  # Менеджер секретов
    sops  # Шифрование и расшифровка файлов
    ffmpeg  # Работа с аудио и видео файлами
    spicetify-cli  # Настройка интерфейса Spotify

    # Разное
    stripe-cli  # Клиент для работы с Stripe API
    bun  # JavaScript/TypeScript runtime
    sqlc  # Генерация SQL из Go структур
    zoxide  # Утилита для навигации по директориям
    tmux  # Мультиплексор терминала
    ranger  # Консольный файловый менеджер
    mkalias  # Утилита для создания alias в shell
    nil  # Простой функциональный язык
    templ  # Шаблонизатор для скриптов

    # Базы данных
    postgresql_16  # PostgreSQL 16
  ];
}