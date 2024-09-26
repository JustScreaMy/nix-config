{ config, pkgs, ... }:

{
  home.username = "krop";
  home.homeDirectory = "/home/krop";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    gnomeExtensions.grand-theft-focus
    gnomeExtensions.vitals
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/krop/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          grand-theft-focus.extensionUuid
          vitals.extensionUuid
        ];
        favorite-apps = [
          "firefox.desktop"
          "Alacritty.desktop"
          "thunderbird.desktop"
          "org.gnome.Nautilus.desktop"
        ];
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        show-battery-percentage = true;
      };
      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        edge-tiling = true;
        workspaces-only-on-primary = true;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        natural-scroll = false;
        click-method = "areas";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        resize-with-right-button = true;
      };
      "org/gnome/desktop/search-providers" = {
        disabled = [
          "org.gnome.Contacts.desktop"
          "org.gnome.Calculator.desktop"
          "org.gnome.Calendar.desktop"
          "org.gnome.Characters.desktop"
          "org.gnome.clocks.desktop"
          "org.gnome.Software.desktop"
        ];
      };
      "org/gnome/shell/extensions/vitals" = {
        position-in-panel = 0;
        show-battery = true;
        icon-style = 1;
        hot-sensors = [
          "__temperature_max__"
          "_memory_available_"
          "_storage_free_"
        ];
      };
      "org/gnome/desktop/background" =
        let
          bgPath = "file://${./nyan_cat.jpg}";
        in
        {
          picture-options = "zoom";
          picture-uri = bgPath;
          picture-uri-dark = bgPath;
        };
    };
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita"; # TODO: fix themes
    style.name = "adwaita-dark";
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      tamasfe.even-better-toml
    ];
  };

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
      bindkey "^[[1;3D" backward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;5C" forward-word
      bindkey "^[[3~" delete-char

      autoload -Uz vcs_info
      setopt auto_menu
      setopt complete_in_word
      setopt always_to_end

      # zstyle command format
      # zstyle :<namespace>:<function>:<completer>:<command>:<argument>:<tag> <style> <value>
      zstyle ':completion:*' menu select
      zstyle ':completion:*' special-dirs true
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$ZSH/.zsh/.zcompcache"


      precmd() {
          vcs_info
          is_toolbx_container
      }

      setopt PROMPT_SUBST

      zstyle ':vcs_info:git:*' formats '[%b] '

      is_toolbx_container() {
          if [[ -f /run/.containerenv ]]; then
              CONTAINER_NAME=$(grep -oP 'name="\K[^"]+' /run/.containerenv)
              TOOLBX_INDICATOR="[%F{magenta}''${CONTAINER_NAME}%f] "
          else
              TOOLBX_INDICATOR=""
          fi
      }

      PROMPT='%2~ ''${TOOLBX_INDICATOR}''${vcs_info_msg_0_}»%b '
    '';
    dotDir = ".zsh";
    completionInit = "autoload -U compinit; compinit -d $ZSH/.zcompdump";
    history.path = "$ZDOTDIR/.zsh_history";
    shellAliases = {
      lg = "lazygit";
      cls = "clear";
      open = "xdg-open";
      fire = "firefox";
      la = "ls -al --color=auto";
      gs = "git status";
      ga = "git add";
      gaa = "git add --all";
      cg-run = "cargo run";
      cg-build = "cargo build";
      cg-test = "cargo test";
      dc = "docker compose";
      dc-build = "dc build";
      dc-run = "dc run --rm";
      dc-runr = "dc-run -u root";
      dc-up = "dc up";
      dc-upd = "dc up -d";
      dc-down = "dc down";
      dc-ls = "dc ls";
      dc-pull = "dc pull";
      ds-env = "env $(cat .env | grep \"^[A-Z]\" | xargs) docker stack";
      bw-unlock = "BW_SESSION=$(bw unlock --raw) && export BW_SESSION";
      t = "tmux";
      pc = "pre-commit";
      tb = "toolbox";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      import = [ "${pkgs.alacritty-theme}/gnome_terminal.toml" ];
      font = {
        size = 16;
      };
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      sensible
    ];
    extraConfig = ''
      # Move status bar to top
      set -g status-position top

      # Indexing from 1 instead of 0
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
    '';
  };

  programs.git = {
    enable = true;
    userName = "Jakub Kropáček";
    userEmail = "kropikuba@gmail.com";
    includes =
      let
        workcfg = {
          user = {
            email = "jakub.kropacek@olc.cz";
            name = "Jakub Kropáček";
          };
        };
      in
      [
        {
          condition = "gitdir:~/Repositories/OLC/**";
          contents = workcfg;
        }
        {
          condition = "gitdir:~/Repositories/OLC-Hexpol/**";
          contents = workcfg;
        }
      ];
    extraConfig = {
      init = {
        defaultBranch = "master";
      };
      push = {
        autoSetupRemote = true;
      };
      status = {
        submoduleSummary = true;
      };
      diff = {
        submodule = "log";
      };
      core = {
        autocrlf = "input";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
