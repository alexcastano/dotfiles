# Path to your oh-my-zsh installation.
export ZSH=/home/alex/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"
export BAT_THEME="base16"

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
         archlinux
         dirhistory
         docker
         docker-compose
         fzf
         gcloud
         git
         git-extras
         kubectl
         mix
         npm
         ssh-agent
         systemd
         urltools
         web-search
)

# export PATH="/home/alex/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/opt/android-sdk/platform-tools:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
export PATH="/home/alex/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/opt/miniconda3/bin:/opt/google-cloud-cli/bin/"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# nvim: avoid run nvin inside nvim
if (( ${+NVIM_LISTEN_ADDRESS} )); then
  export VISUAL="nvr -cc vsplit --remote-wait +'set bufhidden=wipe'"
  export EDITOR="nvr -cc vsplit --remote-wait +'set bufhidden=wipe'"
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

export ACKRC=".ackrc"

export ERL_AFLAGS="-kernel shell_history enabled"

export KERL_BUILD_DOCS="yes"

# default user to don't show in the prompt
DEFAULT_USER=alex

# Alt+. behaviour
bindkey '\e.' insert-last-word

export LESS="-SRXF"

unsetopt share_history

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
ASDF_DATA_DIR=/home/alex/.asdf

# export FZF_DEFAULT_COMMAND='ag -l -g ""'
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--color --bind alt-a:select-all,alt-d:deselect-all,alt-t:toggle-all"
[ -f ~/.fzf.colors ] && source ~/.fzf.colors

# BASE16_SHELL=$HOME/.base16-manager/chriskempson/base16-shell/
# [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# if ! [[ -v NVIM_LISTEN_ADDRESS ]]; then nvim +term; fi
# [ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# Tinty isn't able to apply environment variables to your shell due to
# the way shell sub-processes work. This is a work around by running
# Tinty through a function and then executing the shell scripts.
tinty_source_shell_theme() {
  newer_file=$(mktemp)
  tinty $@
  subcommand="$1"

  if [ "$subcommand" = "apply" ] || [ "$subcommand" = "init" ]; then
    tinty_data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/tinted-theming/tinty"

    while read -r script; do
      # shellcheck disable=SC1090
      . "$script"
    done < <(find "$tinty_data_dir" -maxdepth 1 -type f -name "*.sh" -newer "$newer_file")

    unset tinty_data_dir
  fi

  unset subcommand
}

if [ -n "$(command -v 'tinty')" ]; then
  tinty_source_shell_theme "init" > /dev/null

  alias tinty=tinty_source_shell_theme
fi


export PATH="$PATH:/home/alex/.rover/bin"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
source ~/.zsh_aliases
