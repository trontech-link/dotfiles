{ pkgs, ... }: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  home = {
    stateVersion = "22.11";
    keyboard = { options = [ "caps:ctrl_modifier" ]; };
    file = let old-files-path = ../../../old-files;
    in {
      ".wakatime.cfg" = { source = old-files-path + /wakatime/.wakatime.cfg; };
      ".ldaprc" = { source = old-files-path + /ldap/.ldaprc; };
      ".curlrc" = { source = old-files-path + /downloader/.curlrc; };
    };
  };

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        indent_size = 2;
        end_of_line = "lf";
        insert_final_newline = true;
      };
      "*.{js,py}" = { charset = "utf-8"; };
      "*.css" = { charset = "utf-8"; };
      "*.{py,cpp,c,h,proto}" = {
        indent_style = "space";
        indent_size = 4;
      };

      "Makefile" = { indent_style = "tab"; };
      "lib/**.js" = { indent_style = "space"; };
      "{package.json,.travis.yml}" = { indent_style = "space"; };
    };
  };

  programs = {
    btop = {
      enable = true;
      settings = {
        graph_symbol = "braille";
        theme_background = "True";
        show_battery = "True";
        selected_battery = "Auto";
      };
    };

    # keychain = {
    #   enable = true;
    # };

    readline = { enable = true; };

    atuin = {
      enable = true;
      settings = {
        auto_sync = true;
        sync_frequency = "1m";
        sync_address = "https://atuin.inner.freeman.engineer";
      };
    };

    ssh = {
      enable = true;
      hashKnownHosts = false;
      compression = true;
      # tpm chips limitation
      extraConfig = ''
        GSSAPIAuthentication yes
        PasswordAuthentication yes
        PubkeyAcceptedKeyTypes rsa-sha2-256,ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-rsa
      '';
    };

    bat = { enable = true; };
    exa = { enable = true; };

    home-manager = { enable = true; };

    direnv = {
      enable = true;
      nix-direnv = { enable = true; };
    };

    git = {
      enable = true;
      lfs = { enable = true; };
      aliases = {
        trash =
          "!mkdir -p .trash && git ls-files --others --exclude-standard | xargs mv -f -t .trash";
        pushall = "!git remote | xargs -L1 git push --all";
        rank = "shortlog -s -n --no-merges";
      };

      difftastic = {
        enable = true;
        background = "dark";
      };

      extraConfig = {
        init = { defaultBranch = "main"; };
        # [url "ssh://git@github.com/"]
        # 	insteadOf = https://github.com/

      };

      ignores = [
        "tags"
        "*.DS_Store"
        "*.sw[nop]"
        ".bundle"
        ".env"
        "db/*.sqlite3"
        "log/*.log"
        "rerun.txt"
        "tmp/**/*"
        "workspace.xml"
        ".idea/"
        "node_modules/"
        "target"
        "!target/native/include/*"
        ".meteor/"
        ".vim/"
        "Debug/"
        "compile_commands.json"
        "tests/CMakeCache.txt"
        "**/.ensime*"
        ".metals/"
        ".bloop/"
        "dist"
        "dist-*"
        "cabal-dev"
        "*.o"
        "*.hi"
        "*.chi"
        "*.chs.h"
        "*.dyn_o"
        "*.dyn_hi"
        ".hpc"
        ".hsenv"
        ".cabal-sandbox/"
        "cabal.sandbox.config"
        "*.prof"
        "*.aux"
        "*.hp"
        "*.eventlog"
        ".stack-work/"
        "cabal.project.local"
        "cabal.project.local~"
        ".HTF/"
        ".ghc.environment.*"
        "nohup.out"
        ".attach_bid*"
      ];
    };

    jq = { enable = true; };

    man = { enable = true; };

    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        ale
        denite
        lightline-vim
        nerdtree
        tagbar
      ];
      settings = {
        expandtab = true;
        history = 1000;
        background = "dark";
      };

      extraConfig = ''
        set clipboard=unnamed,unnamedplus  " use the clipboards of vim and win
        set paste               " Paste from a windows or from vim
        set go+=a               " Visual selection automatically copied to the clipboard
      '';
    };

    navi = { enable = true; };

    zoxide = { enable = true; };

    pandoc = { enable = true; };

    sagemath = { enable = false; };

    sqls = { enable = true; };

    tmux = {
      enable = true;
      terminal = "screen-256color";
      shortcut = "space";
      plugins = with pkgs.tmuxPlugins; [ yank ];
      secureSocket = false;
      keyMode = "vi";
    };

    starship = {
      enable = true;
      settings = {
        # move the rest of the prompt to the right
        # format = "$character";
        # right_format = "$all";
        # A continuation prompt that displays two filled in arrows
        continuation_prompt = "▶▶";
        kubernetes = { disabled = false; };
        # directory = {
        #   truncation_length = 20;
        #   truncation_symbol = "…/";
        # };
        status = { disabled = false; };
        time = { disabled = false; };
        git_metrics = { disabled = false; };
        sudo = { disabled = false; };
      };
    };
  };
}
