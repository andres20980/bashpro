#############################################
# ~/.bash_functions - Funciones personalizadas nivel PRO
# Modular complementario a ~/.bashrc y ~/.bash_aliases
# Incluye utilidades, Git, FZF, GitHub, K8s/OC y ayuda interactiva
#############################################

########## 📁 UTILIDADES GENERALES ##########

# mkcd <directorio>: crea una carpeta y entra en ella
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# extract <archivo>: extrae archivos comprimidos según extensión
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "❌ '$1' no puede extraerse automáticamente" ;;
    esac
  else
    echo "❌ '$1' no es un archivo válido"
  fi
}

# extract_all: extrae todos los archivos comprimidos del directorio actual
extract_all() {
  for file in *; do
    extract "$file"
  done
}

# timer <comando>: mide el tiempo de ejecución de un comando
timer() {
  start=$(date +%s)
  "$@"
  end=$(date +%s)
  echo "⏱ Tiempo total: $((end - start)) segundos"
}

# ipinfo_local: muestra IP local y pública
ipinfo_local() {
  echo "📡 IP local:"
  ip -4 addr show | grep inet
  echo "🌍 IP pública:"
  curl -s https://icanhazip.com
}

# cleanup: elimina archivos temporales y backups
cleanup() {
  echo "🧹 Limpiando archivos temporales y backups..."
  find . -type f \( -name '*~' -o -name '*.bak' -o -name '*.tmp' \) -delete
}

# ffind <texto>: búsqueda recursiva por nombre (ignora mayúsculas)
ffind() {
  find . -iname "*$1*"
}

########## 🌿 FUNCIONES GIT / GITHUB ##########

# gitinfo: muestra información útil del repositorio actual
gitinfo() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "⚠ No estás dentro de un repositorio Git."
    return 1
  fi
  echo -e "\n📂 Ruta del repositorio: \033[1;34m$(git rev-parse --show-toplevel)\033[0m"
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  echo -e "🌿 Rama actual: \033[1;33m$branch\033[0m"
  echo -e "🔍 Último commit:"
  git log -1 --pretty=format:"  📌 Hash: %h%n  📝 Mensaje: %s%n  👤 Autor: %an%n  🕓 Fecha: %ad" --date=short
  echo -e "\n📄 Estado del repositorio:"
  if [[ -n $(git status --porcelain) ]]; then
    echo "  ⚠ Hay cambios sin confirmar:"
    git status --short
  else
    echo "  ✅ El repositorio está limpio"
  fi
  echo
}

# gitupdate: flujo completo de add + commit + push con interacción
gitupdate() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "❌ No estás en un repositorio Git."
    return 1
  fi

  echo -e "\n📂 Estado actual del repo:"
  git status -sb

  local changes_staged=$(git diff --cached --name-only)
  local changes_unstaged=$(git diff --name-only)
  local untracked=$(git ls-files --others --exclude-standard)

  if [[ -z "$changes_staged" && -z "$changes_unstaged" && -z "$untracked" ]]; then
    echo "✅ Todo limpio. No hay cambios que subir."
    return 0
  fi

  echo -e "\n🔍 Cambios detectados:"
  [[ -n "$changes_staged" ]] && echo "✅ Cambios listos para commit."
  [[ -n "$changes_unstaged" ]] && echo "📝 Cambios sin añadir al staging."
  [[ -n "$untracked" ]] && echo "🆕 Archivos nuevos no seguidos."

  read -p "¿Añadir TODOS los cambios al commit? (s/N): " addresp
  [[ "$addresp" =~ ^[sS]$ ]] && git add -A || { echo "❌ No se han añadido archivos."; return 0; }

  read -p "🗒️  Escribe mensaje de commit: " msg
  [[ -z "$msg" ]] && echo "❌ Mensaje vacío. Abortando." && return 1
  git commit -m "$msg"

  read -p "⬆ ¿Push al remoto? (s/N): " pushresp
  [[ "$pushresp" =~ ^[sS]$ ]] && git push && echo "🚀 Push hecho." || echo "✅ Commit local realizado."
}

# git_prompt_status_auto: muestra status automáticamente al entrar en un repo nuevo
__last_git_repo_root=""
git_prompt_status_auto() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    current_git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ "$current_git_root" != "$__last_git_repo_root" ]]; then
      __last_git_repo_root="$current_git_root"
      echo -e "\n📂 Git status en $(basename "$current_git_root"):\n"
      git status -sb
      UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
      if [ $? -eq 0 ]; then
        AHEAD=$(git rev-list "$UPSTREAM"..HEAD --count)
        BEHIND=$(git rev-list HEAD.."$UPSTREAM" --count)
        [[ "$AHEAD" -gt 0 && "$BEHIND" -gt 0 ]] && echo "🔁 Adelantado $AHEAD y atrasado $BEHIND commits respecto a '$UPSTREAM'"
        [[ "$AHEAD" -gt 0 ]] && echo "⬆ $AHEAD commit(s) por subir"
        [[ "$BEHIND" -gt 0 ]] && echo "⬇ $BEHIND commit(s) nuevos en remoto"
        [[ "$AHEAD" -eq 0 && "$BEHIND" -eq 0 ]] && echo "✅ Repo sincronizado con '$UPSTREAM'"
      else
        echo "⚠ No hay upstream configurado para esta rama."
      fi
    fi
  else
    __last_git_repo_root=""
  fi
}

# === ghconn: reconecta GitHub restaurando credenciales
ghconn() {
  if [ -f ~/.git-credentials.disabled ]; then
    mv ~/.git-credentials.disabled ~/.git-credentials
    echo "🔐 Credenciales GitHub restauradas."
  else
    echo "✅ Las credenciales ya estaban activas."
  fi

  echo "🔍 Verificando conexión con GitHub..."
  local token_url=$(grep 'github.com' ~/.git-credentials | sed 's/https:\/\///g')
  if curl -s -o /dev/null -w "%{http_code}" "https://${token_url}" | grep -q "200\|301"; then
    echo "🐙 GitHub ${token_url%%:*} conectado correctamente."
  else
    echo "❌ GitHub ${token_url%%:*} - token inválido o sin acceso."
  fi
}

# === ghtokenupdate: cambia el token de acceso GitHub
ghtokenupdate() {
  echo "🔑 Actualizando token de GitHub..."
  read -p "👤 GitHub username: " ghuser
  read -s -p "🔑 Nuevo GitHub Token (PAT): " newtoken
  echo
  echo "✅ Guardando token en ~/.git-credentials"
  echo "https://${ghuser}:${newtoken}@github.com" > ~/.git-credentials
  git config --global credential.helper store
  echo "🔄 Probando conexión con GitHub..."
  if git ls-remote https://github.com &>/dev/null; then
    echo "🐙 Nuevo token GitHub válido. ¡Listo!"
  else
    echo "❌ El nuevo token parece inválido o hay error de red."
  fi
}

########## 🔍 FUNCIONES CON FZF ##########

catf() {
  local file
  file=$(ls | fzf --prompt="📂 Elige archivo para ver: ")
  [[ -n "$file" ]] && cat "$file"
}

catfp() {
  local file
  file=$(ls | fzf --preview 'head -n 20 {}' --prompt="📂 Archivo con preview: ")
  [[ -n "$file" ]] && cat "$file"
}

cdf() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf --prompt="📁 Carpeta destino: ")
  [[ -n "$dir" ]] && cd "$dir"
}

vimf() {
  local file
  file=$(ls | fzf --prompt="📝 Editar archivo: ")
  [[ -n "$file" ]] && vim "$file"
}

########## DASHBOARD #############
dashboard() {
  clear
  C1='\033[1;95m'; C2='\033[1;96m'; CK='\033[1;92m'; CV='\033[0;37m'; CI='\033[1;90m'; R='\033[0m'

  # Imprime clave y valor con padding visible correcto
  P() {
    local key="$1:"; local val="$2"
    local pad=18
    local clean_len=${#key}
    local spacing=$(printf '%*s' $((pad - clean_len)) "")
    printf "  ${CK}%s${spacing}${CV}%s${R}\n" "$key" "$val"
  }

  S() { echo -e "\n${C2}▶ $1${R}"; }

  HOST=$(hostname)
  USER=$(whoami)
  SO=$(lsb_release -ds 2>/dev/null | tr -d '"')
  KERNEL=$(uname -r)
  CPU=$(lscpu | awk -F: '/Model name/ {print $2}' | sed 's/^ *//')
  UPTIME=$(uptime -p | sed 's/^up //')
  MEM=$(free -h | awk '/Mem:/ {printf "%.1f%s libres de %.1f%s", $4, substr($4,length($4)), $2, substr($2,length($2))}')
  DISK=$(df -h / | awk 'NR==2 {printf "%.1f%s usados de %.1f%s (%s)", $3, substr($3,length($3)), $2, substr($2,length($2)), $5}')
  IFACE=$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}')
  IP_LOCAL=$(ip -4 -o addr show "$IFACE" | awk '{print $4}' | cut -d/ -f1)
  IP_PUB=$(curl -s https://api.ipify.org)

  echo -e "${C1}====== DASHBOARD DEL SISTEMA ======${R}"
  S "Información General"; P "Hostname" "$HOST"; P "Usuario" "$USER"; P "SO/Kernel" "$SO ($KERNEL)"
  P "CPU" "$CPU"; P "Tiempo Activo" "$UPTIME"
  S "Recursos"; P "Memoria Libre" "$MEM"; P "Disco Usado (/)" "$DISK"
  S "Red"; P "IP Local" "$IP_LOCAL"; P "IP Pública" "$IP_PUB"
  echo -e "\n${CI}[$USER@$HOST]${R}\n"
}








########## 📚 AYUDA GLOBAL ##########
# === ayuda: muestra ayuda extendida de funciones + alias personalizados ===
ayuda_completa() {
  echo -e "\n\033[1;36m=========== 📚 AYUDA COMPLETA - FUNCIONES & ALIAS ===========\033[0m"

  echo -e "\n\033[1;33m🧠 FUNCIONES PERSONALIZADAS:\033[0m"

  echo -e "\n🔧 Utilidades generales:"
  echo "  mkcd <dir>         → Crea una carpeta y entra en ella (ej: mkcd nueva_carpeta)"
  echo "  extract <archivo>  → Extrae un archivo comprimido (ej: extract archivo.zip)"
  echo "  extract_all        → Extrae todos los archivos comprimidos del directorio actual"
  echo "  cleanup            → Elimina temporales (*.tmp *.bak *~)"
  echo "  ipinfo_local       → Muestra IP local y pública"
  echo "  ffind <texto>      → Busca archivos por nombre (ej: ffind nginx)"
  echo "  timer <cmd>        → Mide tiempo ejecución (ej: timer sleep 3)"

  echo -e "\n🔍 Funciones con fzf:"
  echo "  catf               → Elige archivo y muestra con cat"
  echo "  catfp              → Como catf pero con preview (head -n 20)"
  echo "  vimf               → Edita archivo elegido con fzf (usa vim)"
  echo "  cdf                → Cambia a carpeta elegida con fzf"

  echo -e "\n🌿 Git & GitHub:"
  echo "  gitinfo            → Info del repo actual (rama, último commit, cambios...)"
  echo "  gitupdate          → Commit interactivo (status, mensaje, push)"
  echo "  git_prompt_status_auto → Muestra estado git al cambiar de repo"
  echo "  ghconn             → Activa credenciales GitHub (restaura .git-credentials)"
  echo "  ghdisconn          → Desactiva temporalmente credenciales GitHub"

  echo -e "\n🖥️ Info del sistema:"
  echo "  dashboard          → Panel técnico general + Git info"

  echo -e "\n\033[1;33m🧩 ALIAS DISPONIBLES:\033[0m"

  echo -e "\n📁 Navegación rápida:"
  echo "  .., ..., ....      → Subir niveles"
  echo "  gohome             → Ir a Documentos"

  echo -e "\n📂 Listados mejorados (usa eza):"
  echo "  ls, ll, la, lt     → Listados coloridos, árbol, git, ocultos..."

  echo -e "\n🧹 Limpieza y terminal:"
  echo "  cls                → Limpiar pantalla"
  echo "  reload             → Recargar configuración bash (source ~/.bashrc)"

  echo -e "\n📊 Información sistema:"
  echo "  cpu, mem, disk     → CPU, RAM, espacio disco"
  echo "  ipinfo, ports      → IPs y puertos en uso"
  echo "  neoinfo            → Mostrar info completa con neofetch"

  echo -e "\n📦 Paquetes (apt):"
  echo "  update, up         → Actualizar sistema"
  echo "  install, remove    → Instalar / eliminar paquetes"
  echo "  purge, autoremove  → Limpieza completa"
  echo "  clean              → Vaciar caché apt"

  echo -e "\n🔍 Procesos y red:"
  echo "  psg <texto>        → Buscar procesos"
  echo "  topc               → Lanzar htop"
  echo "  pingg              → Ping a 8.8.8.8"
  echo "  netcheck           → IP pública rápida"
  echo "  speed              → Test de velocidad terminal"

  echo -e "\n🌿 Git rápido:"
  echo "  gs, ga, gc, gp     → status, add, commit, push"
  echo "  gl, gco, gb, gd    → log, checkout, branch, diff"

  echo -e "\n🧰 Utilidades varias:"
  echo "  mkdir              → mkdir -pv (con -p y verbose)"
  echo "  h, hgrep           → Historial / filtrar historial"
  echo "  f <texto>          → find por nombre"
  echo "  v                  → Abrir con nano"
  echo "  bat                → Usar batcat para ver archivos"
  echo "  getgh              → Ir a carpeta github local"

  echo -e "\n☸️ OpenShift / Kubernetes:"
  echo "  oclogin            → Login rápido a clúster OC"
  echo "  ocp, ocs, ocns     → Pods, servicios, proyecto OC"
  echo "  occtx, ocwho       → Contexto y usuario OC"
  echo "  k, kgp, kgs, kctx, kns → Alias para kubectl"
  echo "  opentoken <fqdn>   → Abre token OC (ej: opentoken cluster...opentlc.com)"
  echo "  clusterstatus      → Estado del clúster K8s/OC"
  echo "  clusterlogout      → Salir del clúster actual"

  echo -e "\n🆘 Esta ayuda también se puede mostrar con:\n  ayuda, help o ayudame"

  echo -e "\n\033[1;36m============================================================\033[0m"
}
alias ayudame='ayuda'

# === ayuda <palabra>: busca coincidencias en la ayuda completa ===
ayuda() {
  local filtro="$1"
  local actual=""
  local imprimir_seccion=false

  highlight() {
  if [[ -n "$filtro" ]]; then
    echo "$1" | grep --color=always -i "$filtro" || echo "$1"
  else
    echo "$1"
  fi
  }


  while IFS= read -r linea; do
    if [[ "$linea" =~ ^(🔧|📁|🌿|🧹|📦|☸️|📂|🧰|📊|🧠|🖥️|🆘|🔍|📚|🧩|📄|📝|🗒️|🐙|🚀) ]]; then
      actual="$linea"
      imprimir_seccion=false
    elif [[ -z "$filtro" ]]; then
      [[ -n "$actual" ]] && echo -e "\n\033[1;33m$actual\033[0m" && actual=""
      echo "$(highlight "$linea")"
    elif echo "$linea" | grep -i -q "$filtro"; then
      if [[ "$imprimir_seccion" = false ]]; then
        echo -e "\n\033[1;33m$actual\033[0m"
        imprimir_seccion=true
      fi
      echo "$(highlight "$linea")"
    fi
  done < <(ayuda_completa)
}




