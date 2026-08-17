# ReaFull 🎛️🐧

> **The Ultimate REAPER Production, Mixing & Mastering Suite for Linux.**  
> *100% Native, Modular, Battery-Included, and Automated.*

![ReaFull Splash](assets/branding/Splash%20ReaFull.png)

---

## 🌟 Overview

**ReaFull** is a comprehensive, modular digital audio workstation distribution tailored specifically for **Cockos REAPER on Linux**.

- **100% Linux Native**: Eradicates all Windows path artifacts (`C:\...`), backslashes, user-specific caches, and broken VST references.
- **Modular & Interactive**: Choose exactly which components to install with real-time size calculations, transparent transfer notifications, and detailed logging.
- **Battery-Included**: Ships with full analog and digital JSFX processing suites, GUI assets, and curated presets.
- **Smart Non-Destructive Installer**: Backs up your existing environment and preserves your ALSA/JACK audio device settings, buffer sizes, licenses, and recent projects.

---

## 🧩 Modularity & Component Breakdown

| # | Componente | Descripción | Tamaño Aprox. |
| :-: | :--- | :--- | :-: |
| **1** | **Temas y Splash** | `ReaFull Pro`, `Dark`, `Gray`, `Light` y splash de inicio | ~15 MB |
| **2** | **ReaFull Analog FX** | SolidBus, DisTres-C, Pulse-EQ, Tape, Tube-Pre, FET-76, Summing | ~380 MB |
| **3** | **ReaFull Digital FX** | D-DynEQ, D-MSComp, D-Meter LUFS, Reflex 1/2/3 Reverbs, T-FFT | ~220 MB |
| **4** | **Community FX Suites**| Saike, Sonic Anomaly, Tilr, Liteon, Loser, Stillwell | ~65 MB |
| **5** | **Plantillas (Templates)**| 17 categorías de TrackTemplates + Proyectos por Género | ~6.5 MB |
| **6** | **SWS AutoColor & Icons**| 310+ reglas de auto-color, iconos de pista eduserra/, toolbar icons HiDPI | ~49 MB |
| **7** | **Menús y Screensets** | Barras de herramientas flotantes, atajos de teclado y espacios de trabajo | ~4.3 MB |
| **8** | **ReaScripts Suite** | FTC Tools, HeDa Track Inspector 2, Lokasenna GUI v2, Zaibuyidao, ReaFull Updater | ~156 MB |
| **9** | **Presets y FXChains** | Presets de fábrica analógicos y digitales, cadenas de master/mezcla | ~12 MB |
| **10**| **Tipografías (Fonts)** | Fuentes TrueType/OpenType instaladas en `~/.local/share/fonts/ReaFull/` | ~1.1 MB |
| **11**| **Audio Engine Tuning** | Prioridad Realtime (90), ALSA 48kHz, RAM memory lock y HQ Resampling | 0 B |
| **12**| **Manuales y Docs PDF** | Guía de usuario completa de REAPER y manuales técnicos | ~29 MB |

---

## 🚀 Quick Start (Modo Interactivo)

```bash
# 1. Clonar el repositorio
git clone https://github.com/julesklord/ReaFull.git
cd ReaFull

# 2. Iniciar el instalador interactivo
./install.sh
```

El instalador abrirá una interfaz interactiva donde podrás:
- Activar o desactivar componentes individuales mediante casillas `[X]`.
- Ver en tiempo real el tamaño exacto en disco que ocupará cada elemento.
- Seleccionar perfiles rápidos: **Completo (`a`)**, **Mínimo (`m`)** o **Solo Efectos (`f`)**.

---

## ⚙️ Perfiles y Opciones CLI

Para instalaciones automatizadas, servidores o entornos CI/CD:

```bash
# Instalar con un perfil predefinido
./install.sh --preset full         # Todos los componentes (~1.5 GB)
./install.sh --preset minimal      # Solo Temas, Audio Tuning, Atajos y Fuentes (~20 MB)
./install.sh --preset fx-only      # Solo Suites de Plugins JSFX y Presets (~1.2 GB)
./install.sh --preset themes-only  # Solo Temas e Iconos

# Instalar componentes específicos
./install.sh --components themes,analog_fx,audio_tuning

# Simular sin escribir en disco (Dry-Run)
./install.sh --dry-run --preset full

# Especificar directorio destino personalizado (ej: Flatpak)
./install.sh --target ~/.var/app/fm.reaper.Reaper/config/REAPER

# Modo silencioso no interactivo
./install.sh --quiet --no-backup
```

---

## 📜 Registros Transparentes (Logs)

Cada instalación genera automáticamente un archivo de registro detallado con fecha y hora:
- Ubicación por defecto: `~/.config/REAPER/reafull_install_<TIMESTAMP>.log`
- Contiene: cada archivo copiado con su tamaño en bytes, plantillas procesadas, hardware de audio detectado y estado del respaldo.

---

## 🛡️ Restauración de Copias de Seguridad

Si en algún momento deseas volver al estado anterior:
```bash
./uninstall.sh
```
El script listará todos los respaldos automáticos disponibles (`REAPER_backup_pre_reafull_*`) y te permitirá restaurar con un solo clic.

---

## 🙏 Créditos & Atribución

**ReaFull** es mantenido, empaquetado y adaptado para Linux por **Jules Martins** ([@julesklord](https://github.com/julesklord)).

Crédito y agradecimiento especial a:
- **Edu Serra** (*ReArtist Pro*): Diseño conceptual original, estructura de flujos de trabajo y algoritmos de procesamiento DSP en JSFX.
- **Cockos**: Por la plataforma REAPER y el lenguaje JSFX.
- **Comunidad de desarrolladores**: *FeedTheCat (FTC), HeDa, Lokasenna, Archie, MPL, X-Raym, Saike, Sonic Anomaly, Tilr, StevieKeys*, y los equipos de **SWS Extension** y **ReaPack**.

---

## 📄 Licencia

Este repositorio y sus herramientas de instalación están licenciados bajo la [Licencia MIT](LICENSE).
