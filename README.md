# bashpro ✨

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Una configuración de terminal Bash profesional y potenciada para Ubuntu en WSL2, enfocada en la productividad para DevOps y una experiencia de usuario mejorada.

## Características Principales 🚀

* **Prompt Inteligente:** Muestra información contextual relevante de Git (rama, estado), Kubernetes (contexto/namespace) y OpenShift (proyecto). Mejora la conciencia situacional. *(Requiere Nerd Font)*
* **Alias Productivos:** Una cuidada selección de alias para acelerar comandos comunes y tareas repetitivas.
* **Funciones Avanzadas:** Utilidades y funciones Bash diseñadas para simplificar operaciones comunes en entornos DevOps.
* **Integración con FZF:** Potencia la búsqueda 'fuzzy' en el historial de comandos (`Ctrl+R`), archivos (`Ctrl+T`), y más.
* **Automatización Git:** Incluye alias y funciones para optimizar flujos de trabajo comunes con Git.

## Prerrequisitos 📋

* Windows Subsystem for Linux 2 (WSL2) instalado y funcionando correctamente.
* Una distribución de Ubuntu instalada en WSL2.
* `git` instalado: `sudo apt update && sudo apt install git`
* `fzf` instalado: `sudo apt install fzf` (Altamente recomendado para funcionalidad completa).
* **Nerd Font Instalada y Configurada:** Para que los iconos del prompt se muestren correctamente, necesitas instalar una "Nerd Font" (como Fira Code Nerd Font, MesloLGS NF, etc.) y configurarla en tu terminal (Windows Terminal, VS Code terminal, etc.).

## Instalación (Manual) ⚙️

⚠️ **¡MUY IMPORTANTE!** Este proceso implica reemplazar tus archivos de configuración de Bash existentes (`~/.bashrc`, `~/.bash_aliases`, etc.). Es **fundamental** que hagas una **copia de seguridad** de tus archivos actuales antes de continuar para poder restaurarlos si algo sale mal o si no te gusta la nueva configuración.

```bash
# 1. (Recomendado) Crea un directorio para guardar tus backups
mkdir -p ~/dotfiles_backup
echo "Directorio de backup creado (o ya existente) en ~/dotfiles_backup"

# 2. Copia tus archivos actuales a la carpeta de backup
#    (Ajusta esta lista si usas otros archivos de configuración principales)
cp ~/.bashrc ~/dotfiles_backup/bashrc.backup.<span class="math-inline">\(date \+%Y%m%d%H%M%S\) 2\>/dev/null \|\| true
cp \~/\.bash\_aliases \~/dotfiles\_backup/bash\_aliases\.backup\.</span>(date +%Y%m%d%H%M%S) 2>/dev/null || true
cp ~/.bash_functions ~/dotfiles_backup/bash_functions.backup.<span class="math-inline">\(date \+%Y%m%d%H%M%S\) 2\>/dev/null \|\| true
cp \~/\.bash\_prompt \~/dotfiles\_backup/bash\_prompt\.backup\.</span>(date +%Y%m%d%H%M%S) 2>/dev/null || true
echo "Intentado guardar backups de tus dotfiles actuales en ~/dotfiles_backup con fecha y hora."

Una vez hechos los backups, sigue estos pasos:

Clona el repositorio bashpro: Elige una ubicación (por ejemplo, ~/.bashpro):

Bash

git clone [https://github.com/andres20980/bashpro.git](https://github.com/andres20980/bashpro.git) ~/.bashpro
Crea enlaces simbólicos: (Método recomendado para facilitar actualizaciones futuras vía git pull en ~/.bashpro).

¡Con cuidado! Antes de crear un enlace simbólico, el archivo con el mismo nombre en tu directorio ~ no debe existir. Los comandos de backup anteriores no borran los originales. Asegúrate de tener el backup antes de borrar los archivos originales de tu home.
Bash

# Borra los archivos de configuración actuales en tu home (¡ASEGÚRATE DE TENER BACKUP!)
rm ~/.bashrc ~/.bash_aliases ~/.bash_functions ~/.bash_prompt 2>/dev/null || true

# Crea los enlaces simbólicos desde el repo clonado a tu home
ln -s ~/.bashpro/.bashrc ~/.bashrc
ln -s ~/.bashpro/.bash_aliases ~/.bash_aliases
ln -s ~/.bashpro/.bash_functions ~/.bash_functions
ln -s ~/.bashpro/.bash_prompt ~/.bash_prompt

echo "Enlaces simbólicos creados."
Recarga la configuración de Bash: Para que los cambios surtan efecto, ejecuta:

Bash

source ~/.bashrc
O simplemente cierra y vuelve a abrir tu terminal.

Uso 💡
Una vez instalado, tu terminal tendrá superpoderes. Aquí algunos puntos clave:

El Prompt: Muestra información útil como [Usuario@Host] [Ruta Actual] [Estado Git <Rama>] [Contexto K8s] [Proyecto OC]. Los iconos y colores indican estados (ej., rama Git modificada). Recuerda tener una Nerd Font configurada.
Alias Útiles:
l, ls, ll, la: Variantes mejoradas de ls para listar archivos.
ga: git add . - Añade todos los cambios al staging area.
gcmsg "mensaje": git commit -m "mensaje" - Crea un commit con mensaje.
gp: git push - Sube los cambios al remoto.
gst: git status - Muestra el estado del repositorio.
k: kubectl - Alias corto para el comando de Kubernetes.
(Revisa .bash_aliases para descubrir más)
Funciones Destacadas:
(Ejemplo - Necesita confirmación/detalle) kctx: Función para listar y cambiar contextos de Kubernetes fácilmente.
(Ejemplo - Necesita confirmación/detalle) update_dotfiles: Función para ir al directorio ~/.bashpro y hacer git pull para actualizar la configuración.
Integración FZF:
Ctrl+R: Búsqueda 'fuzzy' instantánea y mejorada en tu historial de comandos.
Ctrl+T: Busca archivos y directorios de forma 'fuzzy' y los inserta en la línea de comandos actual.
Personalización 🔧
Siéntete libre de adaptar la configuración a tus necesidades:

Añade tus propios alias personales en ~/.bash_aliases.
Define tus funciones personalizadas en ~/.bash_functions.
Ajusta la apariencia o comportamiento del prompt modificando ~/.bash_prompt.
Recuerda que como los archivos en ~ son enlaces simbólicos, estarás editando directamente los archivos dentro del repositorio ~/.bashpro, facilitando el control de versiones de tus propios cambios si lo deseas.

Contribuciones 🙏
¡Las contribuciones son bienvenidas! Si encuentras un bug, tienes una sugerencia o quieres añadir una nueva característica:

Revisa los Issues existentes para ver si tu idea ya está discutida.
Crea un nuevo Issue para describir el bug o la propuesta.
Si quieres contribuir con código:
Haz un Fork del repositorio.
Crea una nueva rama para tus cambios (git checkout -b feature/nueva-caracteristica o fix/bug-encontrado).
Haz tus cambios y haz commit.
Envía un Pull Request desde tu fork a la rama main de este repositorio.
Licencia 📜
Este proyecto está bajo la Licencia MIT. Mira el archivo LICENSE para más detalles.

Autor 👤
asanchez (andres20980)
