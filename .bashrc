#############################################
# ~/.bashrc - Configuración avanzada y modular
# Ubuntu WSL2 - Prompt pro con Git + K8s + funciones externas
#############################################

# Salir si no es shell interactiva
case $- in
    *i*) ;;
    *) return ;;
esac

#############################################
# Limpieza preventiva del PROMPT_COMMAND corrupto
#############################################
if [[ "$PROMPT_COMMAND" == *git_prompt_status_auto* ]]; then
  if ! declare -F git_prompt_status_auto >/dev/null; then
    unset PROMPT_COMMAND
  fi
fi

#############################################
# HISTORIAL Y AJUSTES DE SHELL
#############################################
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s checkwinsize
shopt -s globstar

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#############################################
# CHROOT si aplica
#############################################
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#############################################
# COLORES PARA LS Y GREP
#############################################
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='eza --color=always --group-directories-first'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#############################################
# CARGAR ALIAS, PROMPT Y FUNCIONES MODULARES
#############################################
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_prompt  ] && source ~/.bash_prompt
[ -f ~/.bash_functions ] && source ~/.bash_functions

# Asegurar que PROMPT_COMMAND solo se asigne si existe la función
if declare -F git_prompt_status_auto >/dev/null; then
    if [[ -z "$PROMPT_COMMAND" ]]; then
        PROMPT_COMMAND="git_prompt_status_auto"
    else
        PROMPT_COMMAND="$PROMPT_COMMAND; git_prompt_status_auto"
    fi
fi

#############################################
# AUTOCOMPLETADO AVANZADO
#############################################
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#############################################
# Integración de fzf (opcional pero potente)
#############################################
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

