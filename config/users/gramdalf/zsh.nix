{ config, lib, pkgs, ... }: {
  home = {
    file = {
      # zsh prompt. See `~/.zprompt`
      ".zprompt".source = ./legacyDotfiles/.zprompt;
      # zsh colors. See `~/.zcolors`
      ".zcolors".source = ./legacyDotfiles/.zcolors;
    };
    packages = with pkgs; [];
  };
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      #path = "~/.zsh_history";
      size = 1000;
      save = 2000;
      #share = true;
    };
    completionInit = ''
      # enable completion features
      autoload -Uz compinit
      compinit -d ~/.cache/zcompdump
      zstyle ':completion:*:*:*:*:*' menu select
      zstyle ':completion:*' auto-description 'specify: %d'
      zstyle ':completion:*' completer _expand _complete
      zstyle ':completion:*' format 'Completing %d'
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' list-colors ""
      zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' rehash true
      zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
      zstyle ':completion:*' use-compctl false
      zstyle ':completion:*' verbose true
      zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
    '';
    # Extra ~/.zshrc style options
    initExtra = ''
      setopt interactivecomments # allow comments in interactive mode
      setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
      setopt nonomatch           # hide error message if there is no match for the pattern
      setopt notify              # report the status of background jobs immediately
      setopt numericglobsort     # sort filenames numerically when it makes sense
      setopt promptsubst         # enable command substitution in prompt
      bindkey ' ' magic-space                           # do history expansion on space
      bindkey '^U' backward-kill-line                   # ctrl + U
      bindkey '^[[3;5~' kill-word                       # ctrl + Supr
      bindkey '^[[3~' delete-char                       # delete
      bindkey '^[[1;5C' forward-word                    # ctrl + ->
      bindkey '^[[1;5D' backward-word                   # ctrl + <-
      bindkey '^[[5~' beginning-of-buffer-or-history    # page up
      bindkey '^[[6~' end-of-buffer-or-history          # page down
      bindkey '^[[H' beginning-of-line                  # home
      bindkey '^[[F' end-of-line                        # end
      bindkey '^[[Z' undo                               # shift + tab undo last action
      # ~/.zprompt 
      [ -f ~/.zprompt ] && source ~/.zprompt || echo "Error: ~/.zprompt does not exist."
      # ~/.zcolors
      [ -f ~/.zcolors ] && source ~/.zcolors || echo "Error: ~/.zcolors does not exist."
      # enable auto-suggestions based on the history
      if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
          . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          # change suggestion color
          ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
      fi
      # enable command-not-found if installed
      if [ -f /etc/zsh_command_not_found ]; then
          . /etc/zsh_command_not_found
      fi
      # Configure the shell prompt
      configure_prompt
    '';
    sessionVariables = {
      TIMEFMT = "$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'";
      # Don't consider certain characters part of the word
      #WORDCHARS = ''${WORDCHARS//\/}'';
      # hide EOL sign ('%')
      PROMPT_EOL_MARK = "";
    };
  };
}