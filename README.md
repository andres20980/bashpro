# bashpro ✨

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Una configuración profesional de terminal Bash para Ubuntu en WSL2, diseñada para maximizar la productividad en DevOps y mejorar la experiencia del usuario.

## Características Principales 🚀

- **Prompt Inteligente:** Muestra información contextual de Git (rama, estado), Kubernetes (contexto/namespace) y OpenShift (proyecto). *(Requiere Nerd Font)*.
- **Alias Productivos:** Atajos para comandos comunes y tareas repetitivas.
- **Funciones Avanzadas:** Scripts Bash para simplificar operaciones DevOps.
- **Integración con FZF:** Búsqueda 'fuzzy' en historial (`Ctrl+R`), archivos (`Ctrl+T`), y más.
- **Automatización Git:** Alias y funciones para flujos de trabajo eficientes.

## Prerrequisitos 📋

- **WSL2** con Ubuntu instalado.
- **git**: `sudo apt update && sudo apt install git`
- **fzf**: `sudo apt install fzf` (recomendado).
- **Nerd Font**: Instala y configura una Nerd Font (ej. Fira Code Nerd Font).

## Instalación ⚙️

⚠️ **Haz un respaldo de tus archivos actuales antes de continuar.**

1. **Crea un directorio de respaldo:**
    ```bash
    mkdir -p ~/dotfiles_backup
    cp ~/.bashrc ~/.bash_aliases ~/.bash_functions ~/.bash_prompt ~/dotfiles_backup/ 2>/dev/null || true
    echo "Backups guardados en ~/dotfiles_backup."
    ```

2. **Clona el repositorio:**
    ```bash
    git clone https://github.com/andres20980/bashpro.git ~/.bashpro
    ```

3. **Crea enlaces simbólicos:**
    ```bash
    rm ~/.bashrc ~/.bash_aliases ~/.bash_functions ~/.bash_prompt 2>/dev/null || true
    ln -s ~/.bashpro/.bashrc ~/.bashrc
    ln -s ~/.bashpro/.bash_aliases ~/.bash_aliases
    ln -s ~/.bashpro/.bash_functions ~/.bash_functions
    ln -s ~/.bashpro/.bash_prompt ~/.bash_prompt
    echo "Enlaces simbólicos creados."
    ```

4. **Recarga la configuración:**
    ```bash
    source ~/.bashrc
    ```

## Uso 💡

- **Prompt:** Muestra [Usuario@Host] [Ruta] [Estado Git] [Contexto K8s] [Proyecto OC].
- **Alias Útiles:**
  - `l`, `ll`, `la`: Variantes de `ls`.
  - `ga`: `git add .`
  - `gcmsg "mensaje"`: `git commit -m "mensaje"`
  - `gp`: `git push`
  - `gst`: `git status`
  - `k`: Alias para `kubectl`.
- **Funciones Destacadas:**
  - `kctx`: Cambia contextos de Kubernetes.
  - `update_dotfiles`: Actualiza la configuración desde el repositorio.
- **FZF Integrado:**
  - `Ctrl+R`: Búsqueda en historial.
  - `Ctrl+T`: Búsqueda de archivos.

## Personalización 🔧

- Añade alias en `~/.bash_aliases`.
- Define funciones en `~/.bash_functions`.
- Modifica el prompt en `~/.bash_prompt`.

## Contribuciones 🙏

1. Revisa los Issues existentes.
2. Crea un nuevo Issue para sugerencias o bugs.
3. Para contribuciones de código:
    - Haz un Fork.
    - Crea una rama (`feature/nueva-caracteristica`).
    - Envía un Pull Request.

## Licencia 📜

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

## Autor 👤

**asanchez (andres20980)**  
[GitHub](https://github.com/andres20980)
