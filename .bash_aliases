#############################################
# ~/.bash_aliases - Alias útiles nivel pro
# Para Ubuntu WSL2 - Limpios y ordenados
#############################################

# === Navegación rápida ===
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias gohome='cd /mnt/d/Documentos'

# === Listado mejorado con eza ===
alias ls='eza --color=always --group-directories-first'
alias ll='eza -l --git --color=always --group-directories-first'
alias la='eza -la --git --color=always --group-directories-first'
alias lt='eza -T --color=always --level=2 --group-directories-first'

# === Limpieza de pantalla ===
alias cls='clear'

# === Información del sistema ===
alias cpu='lscpu'
alias mem='free -h'
alias disk='df -h'
alias ipinfo='ip -c a'
alias ports='ss -tuln'
alias neoinfo='neofetch'

# === Administración de paquetes ===
alias update='sudo apt update && sudo apt upgrade -y'
alias up='update'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias purge='sudo apt purge'
alias autoremove='sudo apt autoremove -y'
alias clean='sudo apt clean'

# === Procesos y red ===
alias psg='ps aux | grep -i'
alias topc='htop'
alias pingg='ping 8.8.8.8'
alias netcheck='curl -s https://icanhazip.com'
alias speed='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# === Git rápidos ===
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'

# === Utilidades varias ===
alias mkdir='mkdir -pv'
alias h='history'
alias hgrep='history | grep'
alias reload='source ~/.bashrc'
alias f='find . -name'
alias v='nano'
alias bat='batcat'
alias getgh='cd /mnt/d/Documentos/github'

# === OpenShift (oc) y Kubernetes (kubectl) ===
alias oclogin='oc login'
alias ocp='oc get pods'
alias ocs='oc get svc'
alias ocns='oc project'
alias occtx='oc config use-context'
alias ocwho='oc whoami'

alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'

# === Token de OpenShift desde dominio
opentoken() {
  if [ -z "$1" ]; then
    read -p "🛰️  Introduce el dominio completo del clúster (ej: cluster-ldqtf.ldqtf.sandbox2171.opentlc.com): " fqdn
  else
    fqdn="$1"
  fi
  url="https://oauth-openshift.apps.${fqdn}/oauth/token/display"
  echo "🌐 Abriendo: $url"
  explorer.exe "$url"
}

# === Logout de clúster universal
alias clusterlogout='
  echo -e "\n🔌 Cerrando sesión del clúster actual...";
  kubectl config unset current-context && echo "✅ Contexto eliminado. Ya no estás conectado."
'

# === Estado rápido del clúster
alias clusterstatus='
  echo -e "\n\033[1;34m🌐 Cluster Status (Kubernetes/OpenShift):\033[0m";
  if command -v oc >/dev/null 2>&1 && oc whoami &>/dev/null; then
    echo -n "⎈ Usuario:     "; oc whoami;
    echo -n "⎈ Contexto:    "; oc config current-context;
    echo -n "⎈ Cluster:     "; oc config view --minify -o jsonpath="{.clusters[0].name}"; echo;
    echo -n "⎈ Namespace:   "; oc project -q;
  elif command -v kubectl >/dev/null 2>&1; then
    echo -n "⎈ Usuario:     "; kubectl config view --minify -o jsonpath="{.users[0].name}"; echo;
    echo -n "⎈ Contexto:    "; kubectl config current-context;
    echo -n "⎈ Cluster:     "; kubectl config view --minify -o jsonpath="{.clusters[0].name}"; echo;
    echo -n "⎈ Namespace:   "; kubectl config view --minify -o jsonpath="{..namespace}"; echo;
  else
    echo "❌ No hay herramientas kube/oc disponibles.";
  fi;
  echo "";
'

