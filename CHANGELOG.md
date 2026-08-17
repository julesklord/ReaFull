# Changelog

Todas las modificaciones notables de **ReaFull** se documentan en este archivo.
El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y este proyecto sigue [Semantic Versioning](https://semver.org/lang/es/).

---

## [2026.1.0] - 2026-08-17

### 🚀 Añadido
- **Perfil de Instalación No Destructivo (`--profile overlay`)**:
  - Preserva intactos los atajos de teclado del usuario (`reaper-kb.ini`), modificadores de ratón (`reaper-mouse.ini`) y menús existentes.
  - Fusión inteligente de repositorios ReaPack (`reapack.ini`), añadiendo los repositorios comunitarios sin borrar los existentes del usuario.
- **Suite ReaFull Analog FX & Digital FX (JSFX)**:
  - Consola analógica completa: `SolidBus`, `DisTres-C`, `Pulse-EQ`, `Fat-Tape`, `FET-76`, `Opto-2A`, `Vari-Mu`, `Tube-Pre`, `Sum-Desk`.
  - Herramientas digitales quirúrgicas: `D-DynEQ`, `D-EQ`, `D-Comp`, `D-MSComp`, `D-Limit`, `D-Meter` (LUFS EBU R128), `T-FFT`.
- **Motor de Verificación de Salud (`scripts/verify_installation.py`)**:
  - Comprobación automática post-instalación de rutas POSIX, temas, plugins, plantillas y fuentes.
- **Desinstalador y Gestor de Respaldos (`uninstall.sh`)**:
  - Soporte automático para REAPER Nativo y Flatpak.
  - Menú para restaurar respaldos previos, desinstalar componentes de ReaFull o purgar respaldos antiguos.
- **Marco Legal y Atribuciones**:
  - `NOTICE.md` y `THIRD_PARTY.md` con desglose exhaustivo de licencias (MIT, GPL-3.0, LGPL-3.0, Apache 2.0, SIL OFL).
- **Integración Continua (CI)**:
  - Flujo de trabajo en GitHub Actions (`.github/workflows/ci.yml`) para linteo de rutas, compilación de sintaxis y pruebas automatizadas de instalación.

### 🔄 Modificado
- **Sanitización Total de Plantillas**:
  - Eliminadas todas las rutas absolutas de Windows (`C:\`, `J:\`, `F:\`, etc.), proyectos recientes y datos personales de sesión en `config_templates/`.
  - Normalizados todos los separadores de ruta a `/`.
- **Optimización del Repositorio**:
  - Eliminado árbol duplicado de JSFX y temas de ReArtist, reduciendo el tamaño de assets de 2.1 GB a ~858 MB.
  - Eliminada la copia redundante de `Data/Grooves/`.
- **ReaFull Manager In-DAW (`ReaFull_Updater.lua`)**:
  - Desactivadas las ejecuciones ciegas en background sin respaldo. Interfaz segura para consultar releases en GitHub, sincronizar ReaPack y recargar vistas.
- **Script de Inicio (`assets/Scripts/__startup.lua`)**:
  - Interruptores configurables para herramientas auxiliares (`ENABLE_ADAPTIVE_GRID`, `ENABLE_LIL_CHORDBOX`, `ENABLE_GRIDBOX`).

### 🗑️ Eliminado
- Eliminados binarios Windows innecesarios (`7za.exe`, `curl.exe`, DLL de Windows `ogler.clap`).
- Eliminados logs de sesión de depuración (`HeDaScripts Manager.log`) y cachés `.ini` de ventanas de ReaImGui.
- Eliminados manuales PDF con derechos de autor de Cockos, sustituidos por enlaces a la documentación oficial en línea.
