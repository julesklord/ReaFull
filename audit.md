# Auditoría de calidad de producto — ReaFull

| Campo | Valor |
|---|---|
| Producto | **ReaFull** — suite de producción, mezcla y mastering para REAPER en Linux |
| Versión auditada | `2025.1.0-linux` (`install.py`) · rama `main` @ `c4ac8de` |
| Fecha | 17 de agosto de 2026 |
| Alcance | Repositorio completo: instalador, desinstalador, plantillas, assets, branding, licencias, updater in-DAW, documentación y empaquetado |
| Tipo | Auditoría de calidad de producto (no solo de código) |
| Veredicto | **No listo para un lanzamiento público como “suite profesional 100 % nativa”.** El contenido es valioso; el empaquetado, la higiene legal y la promesa de no-destrucción no están a la altura. |

---

## 1. Resumen ejecutivo

ReaFull es un *port* y rebrand de **ReArtist Pro** (Edu Serra) hacia Linux. La proposición de valor es clara y atractiva: convertir REAPER nativo (o Flatpak) en una estación de trabajo lista para producir, mezclar y masterizar, con temas, JSFX analog/digital, plantillas, keymaps, grooves y un instalador que promete no romper el entorno del usuario.

Esa promesa es, hoy, **parcialmente falsa**.

El repositorio es un *dump* casi completo de una instalación Windows de ReArtist (13 383 archivos, **2,1 GB**), con una capa de rebranding incompleta y un instalador Python que sí tiene ideas buenas (backup, merge de `reaper.ini`, detección ALSA), pero que:

1. **Sobrescribe** keymaps, menús, ReaPack y decenas de INI del usuario.
2. **Filtra mal** datos personales y rutas de Windows del autor original.
3. **Duplica** ~605 MB de suites JSFX (ReArtist + ReaFull idénticas).
4. **Afirma** en el README que las rutas `C:\…` “están completamente erradicadas”. No lo están.
5. **No tiene** tests, CI, changelog, releases de GitHub, guía de usuario propia ni onboarding post-instalación.

Como *kit interno* o *preview para early adopters que conocen REAPER*, es usable y generoso. Como producto público que se presenta como “The Ultimate REAPER Production Suite for Linux”, está a **una o dos iteraciones serias** de higiene, legal y UX de poder decirlo con la cara limpia.

### Puntuación global

**5,8 / 10** — *contenido rico, empaquetado inmaduro*.

| Dimensión | Nota | Comentario corto |
|---|---:|---|
| Propuesta de valor | 8,5 | El problema que resuelve es real y el bundle es generoso. |
| Contenido / profundidad | 8,0 | Temas, 200 track templates, 19 project templates, suites JSFX, grooves, render presets. |
| Promesa vs. realidad | 4,0 | El README sobrevende sanitización, no-destrucción y “100 % native”. |
| Instalación y recuperación | 6,0 | Backup e instalador existen; overwrite, Flatpak y uninstall son frágiles. |
| Identidad de marca | 4,5 | Rebrand a medias: ReaFull por fuera, ReArtist por dentro. |
| Higiene y privacidad | 3,5 | Rutas, proyectos y logs de Edu Serra siguen en el paquete. |
| Legal / licencias | 4,0 | MIT en raíz vs LGPL/GPL embebidos; PDFs de Cockos; binarios Windows; fuentes sin OFL. |
| UX in-DAW | 6,5 | Workflow heredado de ReArtist es sólido; onboarding y updater no. |
| Operaciones / release | 2,5 | Sin tests, CI, changelog, tags ni releases. Updater inseguro. |
| Documentación de producto | 4,0 | README de marketing. Cero guía de usuario ReaFull. |

---

## 2. Qué es el producto (y qué no es)

### 2.1 Definición observada

ReaFull no es un DAW ni un plugin. Es una **distribución de configuración** para Cockos REAPER:

- Temas (`ReaFull Pro/Dark/Gray/Light`)
- Suites JSFX Analog + Digital (skins de Tukan / Sonic Anomaly / REEQ / etc.)
- ~200 track templates por instrumento y rol
- 19 project templates por género (salsa, ranchera, metal, jazz, mastering…)
- Keymaps, menús, mouse maps, screensets, FX chains, grooves
- Miles de ReaScripts de terceros (ReaTeam, MPL, X-Raym, FTC, HeDa, Sexan…)
- Instalador Linux + updater in-DAW

El ADN creativo y de workflow es de **Edu Serra / ReArtist Pro**. El trabajo de empaquetado Linux, sanitización y rebrand es de **Jules Martins**. Esa dualidad no está resuelta: el producto no decide si es un *fork* con identidad propia o un *port oficial/no oficial* de ReArtist.

### 2.2 Usuario objetivo implícito

1. Productor/mezclador en Linux que quiere REAPER “listo” sin semanas de setup.
2. Usuario de ReArtist en Windows que migra a Linux.
3. Alguien que busca una consola analog-modeled (SSL/Neve/Pultec/1176/LA-2A) en JSFX.

El instalador y el README **no segmentan** a estos tres. Un usuario REAPER veterano con keymap propio sufrirá más que un usuario nuevo.

### 2.3 Promesas del README vs. evidencia

| Promesa | Realidad | Veredicto |
|---|---|---|
| “100 % Linux Native” | Quedan rutas `J:\`, `F:\`, `C:/Program Files (x86)/ReArtist/ffmpeg.exe`, logs `C:\Users\EDU SERRA\…`, 5 `.exe` de Windows, fonts Windows (`MS Shell Dlg`, `Segoe UI`). | **Incumplida** |
| “Fully Sanitized” | `reaper.template.ini` conserva 13 proyectos recientes de Edu Serra y paths de mastering. | **Incumplida** |
| “Smart Non-Destructive Installer” | Backup sí. Luego `shutil.copy2` de 17 INI encima de los del usuario (`reaper-kb.ini`, `reaper-menu.ini`, `reapack.ini`…). | **Parcial** |
| “Preserves ALSA, JACK, Pipewire, licenses, recent projects” | El merge de `reaper.ini` sí protege un set de keys. El resto de configs no. | **Parcial** |
| “Battery-Included” | Cierto: temas, JSFX, templates, scripts, grooves, fonts. | **Cumplida** |
| “In-DAW Updater” | Existe, pero no hay releases en GitHub; descarga `install.py` de `main` y lo ejecuta en background **sin checksum ni `--target`**. | **Cumplida en forma, fallida en fondo** |
| “4 curated theme flavors” | Los 4 `.ReaperThemeZip` de ReaFull son **copias byte-idénticas** de los ReArtist 2.0. | **Cumplida como asset, no como rebrand** |

---

## 3. Fortalezas (lo que sí está bien)

No es un proyecto vacío. Hay sustancia de producto:

1. **Propuesta concreta.** “REAPER en Linux, listo para estudio” es un hueco real. REAPER nativo en Linux llega desnudo.
2. **Profundidad de workflow.** 200 track templates bien taxonomizados (00 Default → 16 Separators), project templates por género latino/rock/electrónica, FX chains de bus/tape, render presets LUFS (Spotify −8/−10/−12/−14, CD). Eso no se improvisa.
3. **Suites JSFX con GUI.** Analog (SolidBus, Distres, Pulse-EQ, Fat-Tape, FET-76, Opto-2A, Mix-Chan, Sum-Desk…) y Digital (D-Comp, D-DynEQ, Reflex 1/2/3, T-FFT, T-Meter). Para un usuario Linux sin Waves/UAD, esto es el corazón del producto.
4. **Instalador con ideas correctas.** Detección native/Flatpak, dry-run, `--no-backup`, `--no-fonts`, `--quiet`, merge selectivo de `reaper.ini`, detección ALSA de UMC404HD / AudioBox, defaults de resampling r8brain, `linux_mlockall`, `alsa_rtprio`.
5. **Backup + restore.** `create_backup()` + `uninstall.sh` dan un camino de vuelta. Pocos configuradores de DAW lo tienen.
6. **Créditos visibles.** README nombra a Edu Serra, Cockos, FTC, HeDa, Lokasenna, MPL, X-Raym, Archie, Saike, Tilr, StevieKeys, SWS, cfillion. Eso es ético y necesario.
7. **ReaPack remotes bien elegidos.** 15 remotos coherentes con lo empaquetado (ReaTeam, MPL, X-Raym, FTC, Sexan, Suzuki, Tilr, Saike…).
8. **Tipografía automatizada.** Copia a `~/.local/share/fonts/ReaFull` + `fc-cache`. Detalle de producto, no de script.

Estas fortalezas son la razón por la que vale la pena arreglar el resto, no tirarlo.

---

## 4. Hallazgos

Severidad:

- **P0** — Bloquea un lanzamiento público o puede dañar al usuario / al autor.
- **P1** — Rompe la promesa de producto o genera soporte recurrente.
- **P2** — Deuda visible; no bloquea, pero erosiona confianza.
- **P3** — Pulido.

---

### P0 — Bloqueantes

#### P0.1 El instalador no es no-destructivo

`deploy_configurations()` hace `shutil.copy2` de 17 INI sobre el directorio vivo de REAPER:

`reaper-kb.ini`, `reaper-menu.ini`, `reaper-mouse.ini`, `reapack.ini`, `reaper-fxfolders.ini`, `reaper-screensets.ini`, `BR.ini`, `Xenakios_Commands.ini`, etc.

Un usuario con años de atajos, menús custom o remotos ReaPack **los pierde** (salvo que restaure el backup). El README dice lo contrario.

El merge inteligente existe **solo** para `reaper.ini`, y ni siquiera ahí es completo (ver P1.2).

**Impacto de producto:** un power user Linux que pruebe ReaFull una tarde puede sentir que le “han formateado REAPER”. Eso mata adopción y genera issues de pánico.

**Remedio:** merge por archivo (o al menos no tocar `reaper-kb.ini` / `reapack.ini` / `reaper-mouse.ini` si ya existen, salvo `--force`). Ofrecer perfiles: *Fresh studio* vs *Overlay on my setup*.

#### P0.2 Datos personales y de sesión de terceros en el paquete

`config_templates/reaper.template.ini` incluye:

- `importpath=J:\Antonio Dorado`
- `lastprojuiref=J:\REARTIST.NET\Test RA2025 Borrar\…`
- 13 `recent0N=` con proyectos reales (`Lazy Dogs LP`, `Psicophony_Peste de Silicio`, `Aston Maio-Mamacita-Urbano`, `Gaga`, paths en `H:\`, `E:\`, `K:\`)
- `lastrenderpath3/5/6` a discos de mastering
- `lastdir=G:\Cab Impulses\BOGREN\Bogren.Digital.Jens.Bogren.Signature.IR.Pack…`

Además:

- `assets/Scripts/HeDaScripts/HeDaScripts Manager.log` — log de sesión de **EDU SERRA** en Windows, con rutas `C:\Users\EDU SERRA\AppData\…`, versión de curl, tests de 7-Zip.
- `reaper-extstate.template.ini` → `ffmpeg path=C:/Program Files (x86)/ReArtist/ffmpeg/bin/ffmpeg.exe`
- Decenas de `ReaImGui/*.ini` con geometría de ventanas de esa sesión.

Si el usuario instala en una máquina limpia, **hereda el historial de proyectos de otra persona**. Si publica el repo, publica metadatos de sesiones ajenas.

**Remedio:** allowlist de keys en el template. Borrar `recent*`, `lastproj*`, `lastdir`, `lastrenderpath*`, logs, `ReaImGui/*.ini` de runtime. Regenerar `reaper.template.ini` desde un perfil *factory*.

#### P0.3 Conflicto legal y de atribución no resuelto

| Capa | Licencia observada | Problema |
|---|---|---|
| Raíz del repo | MIT (Jules Martins, 2025) | MIT no cubre el bundle. |
| ReArtist | LGPL v3 (Edu Serra, 2023) — el archivo dice “LGLP” (typo) | Un Combined Work LGPL + MIT requiere avisos, GPL/LGPL adjuntos y no puede “relicenciarse” como MIT. |
| ReaScripts embebidos | En su mayoría GPL-3 (ReaTeam, MPL, X-Raym…) | Redistribuir 5 000+ scripts como snapshot viola el espíritu (y a veces la letra) de “instala vía ReaPack”. Varios autores lo piden explícitamente. |
| JSFX Analog/Digital | Skins de Tukan Studios (John Matthews), Sonic Anomaly (Stige T), REEQ (Justin Johnson), Cockos | El `ABOUT` lo admite. Rebrand a “ReaFull Analog FX” + logos ReArtist en GUI + MIT en raíz es una cadena de atribución rota. |
| `assets/Docs/ReaperUserGuide734e.pdf`, `Reaper FX Manual v2022.pdf` | Copyright Cockos | Redistribuir el user guide oficial en un repo de terceros es, como mínimo, zona gris. Cockos no suele autorizarlo. |
| `ogler.clap` (13 MB) | Binario CLAP de terceros | Sin licencia, sin fuente, sin nota de procedencia. |
| `7za.exe`, `curl.exe` (HeDa) | Binarios Windows | Basura en un producto Linux; además redistribución de 7-Zip/curl. |
| Fuentes | OFL para Open Sans, Orbitron, Roboto | **Sin licencia** para Electrolize, FrozenCrystal, “alarm clock”. |

El README dice: *“Bundled JSFX and ReaScripts maintain their respective open-source licenses.”* Eso es una nota al pie, no un *NOTICE* / *THIRD_PARTY.md*. Para un producto que se clona y se instala entero, no basta.

**Remedio mínimo para un v1 público:**

1. `NOTICE.md` + `THIRD_PARTY.md` con autor, licencia y origen de cada bloque.
2. Raíz: “installer MIT; bundled content under original licenses”.
3. Quitar PDFs de Cockos (enlazar a la web oficial).
4. Quitar `.exe`, `.log`, `ogler.clap` si no hay licencia clara.
5. Añadir OFL/licencias de las 3 fuentes que faltan, o no empaquetarlas.
6. Preferir ReaPack para scripts de terceros en vez de vendorar 156 MB.

#### P0.4 Updater in-DAW inseguro e incompleto

`assets/Scripts/ReaFull/ReaFull_Updater.lua`:

- Consulta `/releases/latest`. **No hay releases.** Siempre cae al fallback.
- El “update” real es:

  ```lua
  python3 -c "…urlretrieve('…/main/install.py', '/tmp/reafull_install.py');
              os.system('python3 /tmp/reafull_install.py --quiet --no-backup')"
  ```

  Problemas: sin verificación de integridad, corre `--no-backup`, **no pasa `--target`** (rompe Flatpak), corre en background mientras REAPER está abierto (el propio instalador avisa de que REAPER debe estar cerrado), y el OS-detect es un nudo:

  ```lua
  local is_linux = reaper.GetOS():match("Other") or reaper.GetOS():match("OSX") == nil and reaper.GetOS():match("Win") == nil
  ```

  `is_linux` **nunca se usa**. El menú está en español, el resto del producto en inglés.

**Impacto:** un usuario que pulse “actualizar” puede pisar su config **sin backup** y, en Flatpak, escribir en `~/.config/REAPER` en vez del sandbox.

---

### P1 — Rompen la promesa de producto

#### P1.1 Rebrand incompleto: el usuario compra ReaFull y recibe ReArtist

El rebrand es una **copia de archivos**, no una transformación de producto.

| Superficie | Estado |
|---|---|
| Splash, README, `install.py`, carpeta `Scripts/ReaFull/` | ReaFull |
| Temas `ReaFull *.ReaperThemeZip` | Copias idénticas de `ReArtist 2.0 *` (se siguen embarcando las 8) |
| Suites `ReaFull Analog/Digital FX` | Copias idénticas de `ReArtist *` (**+605 MB**) |
| Nombres internos de plugins | `SolidBus (ReArtist Pro)`, `D-Comp (ReArtist Pro)`, … |
| Logos en GUI | `ReArtist Logo BLUE.png` / `GREY.png` en decenas de JSFX |
| `ABOUT THIS PLUGIN COLLECTION.txt` | Habla de ReArtist, Edu Serra, carpeta “REARTIST” |
| `MouseMaps/` | Solo `ReArtist Pro.ReaperMouseMap` — no hay ReaFull |
| `Scripts/Cockos/ReArtist_theme_adjuster.lua` | Sin equivalente ReaFull |
| `S&M.template.ini` theme slots | Siguen apuntando a `ReArtist 2.0 *.ReaperThemeZip` |
| `reaper-fxoptions.ini` | Cientos de entradas `ReARTIST/…` y `ReArtist Analog FX/…` |

El usuario ve “ReaFull Pro” en el splash y “ReArtist Pro” en cada plugin. Eso no es un easter egg: es un producto que no ha terminado de nacer.

**Coste de no decidir:** 605 MB × 2 de JSFX + 4 themes duplicados. En un clone de GitHub / un backup del instalador, duele.

**Decisión de producto necesaria (elegir una):**

- **A. Port fiel de ReArtist** — mantener el nombre ReArtist en plugins (crédito correcto), ReaFull solo como “Linux edition / installer”.
- **B. Marca propia** — rebrand real de slugs JSFX, ABOUT, theme adjuster, mouse map, fxoptions; dejar de embarcar el árbol ReArtist.

Hoy es A y B a la vez, peor que cualquiera de las dos.

#### P1.2 `reaper.template.ini` no es una plantilla

Es un `REAPER.ini` de una máquina Windows de 2025, con placeholders solo en `lastthemefn5` y `splashimage`. Conserva:

- Geometría de ventanas de un monitor concreto (`iconpicker_x=-1275`, docks, prefs en coords absolutas).
- Fuentes Windows (`Segoe UI`, `Arial Narrow`, `alarm clock`).
- Historial de proyectos y renders (P0.2).
- Keys de hardware/UI que el merge intenta preservar *si ya existen*, pero que se instalan tal cual en un perfil nuevo.

El merge **no expande** `{{REAPER_CONFIG_DIR}}` en las líneas del template: reescribe theme/splash a mano. Si alguien añade más placeholders, se quedarán literales.

#### P1.3 Detección de destino y de proceso, incompleta para Linux real

```python
def detect_reaper_dir():
    if os.path.exists(native_dir):
        return native_dir
    elif os.path.exists(flatpak_dir):
        return flatpak_dir
    return native_dir
```

Si el usuario tiene **las dos** (muy común: probó nativo y se pasó a Flatpak, o al revés), siempre gana nativo. No pregunta.

`is_reaper_running()` usa `pgrep -x reaper`. Un binario Flatpak o un `reaper.exe` bajo Wine no se detectan. El usuario puede instalar encima de una sesión viva.

`uninstall.sh` **solo** mira `$HOME/.config/REAPER` (o `$1`). No hay Flatpak, no hay `--quiet`, no hay listado de backups `*_backup_pre_reafull_*` documentado en el README de forma simétrica.

`install.sh` avisa de deps que faltan pero **sigue igual**. `curl` se marca como dependencia y el instalador Python no lo usa.

#### P1.4 Defaults de audio agresivos y demasiado específicos

`detect_best_audio_settings()` está bien intencionado y mal generalizado:

- Hardcodea `hw:U192k` (Behringer UMC404HD) y `hw:USB` (AudioBox). Cualquier otra interfaz se ignora.
- `alsa_rtprio=90` + `linux_mlockall=1` fallan en silencio sin `rtirq` / `limits.conf` / grupo `audio`. El usuario ve xruns o REAPER que no abre ALSA, no un mensaje.
- Fuerza 48 kHz / 256 / 3 buffers. Legítimo como default de estudio; no se documenta ni se pregunta.
- Si el usuario *ya* tiene device, igual pisa `playresamplemode`, `afxb`, `workthreads` cuando valen `"0"` / `"50"`.

Un producto “pro Linux” debería detectar PipeWire/JACK primero (es el stack 2026), no solo `aplay -l` + dos marcas de interfaz.

#### P1.5 Startup scripts sin consentimiento

`assets/Scripts/__startup.lua` lanza al arrancar:

1. Lil Chordbox (FTC)
2. Adaptive grid (background)
3. Gridbox

En un producto “studio console”, abrir dos overlays MIDI/grid en cada launch es una decisión de autor, no un default universal. No hay toggle, no hay wizard, no está documentado.

#### P1.6 Verificación desconectada del flujo de producto

`scripts/verify_installation.py` existe y es la semilla correcta de un health-check. El instalador **no lo llama**. El README no lo menciona. Comprueba 6 cosas superficiales (carpeta, un theme, dos dirs FX, dos nombres de fuente, ≥10 track templates, un INI). No valida:

- que los JSFX resuelven
- que no quedaron `{{REAPER_CONFIG_DIR}}` literales
- que no hay `C:\` en el `reaper.ini` instalado
- que SWS/ReaPack quedaron linkeados
- que las fuentes *alarm clock* / Orbitron (las que usa el theme) están

Además acepta el fallback ReArtist como “OK”, lo que esconde un rebrand a medias.

#### P1.7 Scripts de empaquetado no son producto, son leftover de cocina

`scripts/sanitize_and_prepare.py`, `apply_rebranding.py`, `clean_templates_final.py` tienen:

```python
REPO_DIR = "/mnt/DEV/projects/repos/julesklord/ReaFull"
SRC_EXTRACTED = "/home/julesklord/.cache/reartist_extracted_files"
```

Rutas de la máquina del autor. Si un contributor (o el propio updater mental) los corre en otro sitio, no hacen nada o escriben fuera. No hay `Makefile` / `justfile` que distinga *build del paquete* vs *install del usuario*.

Esto no es solo deuda de código: es señal de que **el repo *es* el working copy de una migración**, no un artefacto reproducible.

---

### P2 — Deuda visible

#### P2.1 El repo es un dump, no un paquete

| Árbol | Peso | Comentario |
|---|---:|---|
| `Effects/` | 1,3 GB | Mitad duplicada ReArtist/ReaFull |
| `Scripts/` | 156 MB | ~5 042 `.lua` de todo ReaTeam + HeDa + MPL + X-Raym… |
| `Data/` | 49 MB | Incluye `tilr_*` **y** `tilr8_*` (muestras duplicadas) + 1 788 toolbar icons |
| `Docs/` | 29 MB | Manuales oficiales de REAPER |
| `ReaPack/` | 15 MB | `registry.db` snapshot de abril 2025 + cache |
| `UserPlugins/FX/ogler.clap` | 13 MB | Binario suelto |
| `ColorThemes/` | 15 MB | 8 zips, 4 de ellos clones |
| **Total** | **2,1 GB** | Un `git clone` es hostil. Un backup del instalador duplica eso otra vez. |

`create_backup()` hace `copytree` del **directorio REAPER entero**. Tras instalar ReaFull, el siguiente update copia ~2 GB+ otra vez. En un SSD de portátil eso es un bug de producto.

**Dirección correcta:** perfil *core* (temas + JSFX ReaFull + templates + kb/menu) de ~400–500 MB, y un perfil *full* opcional. Scripts de terceros vía ReaPack, no vendorizados.

#### P2.2 Documentación de producto inexistente

Hay README de marketing y dos PDFs de Cockos. Falta:

- Guía de primeros 15 minutos (qué theme, qué screenset, dónde están los analog FX)
- Mapa de keymaps (el producto *es* un keymap)
- Diferencias ReaFull Pro / Dark / Gray / Light
- Qué hace cada project template
- Qué JSFX usar en un bus vocal vs. un mixbus
- Troubleshooting Linux (PipeWire, rtprio, Flatpak permissions, fuentes que no cargan)
- Changelog / semver real
- Política de updates

El keymap se llama `ReaFull Pro Full Keymap` y no hay una sola página que lo explique. Un usuario nuevo no puede adoptar un keymap que no entiende.

`AGENTS.md` en la raíz es un volcado de skills de Claude Code, no documentación del proyecto. En un repo público es ruido (y un poco confuso).

#### P2.3 Operaciones de release ausentes

- Sin `.github/workflows`
- Sin issue / PR templates
- Sin `CHANGELOG.md`
- Sin tags / GitHub Releases (el updater depende de ellos)
- Sin tests (ni siquiera un `--dry-run` asertado)
- Versión `2025.1.0-linux` en un repo auditado en 2026, sin calendario
- 5 commits, todos de setup. No hay rastro de feedback de usuarios.

Un producto “suite” sin canal de update fiable **envejece el día que se clona**. Los scripts de ReaTeam del snapshot se quedan congelados; ReaPack luego peleará con copias locales.

#### P2.4 UX del instalador / desinstalador

- `install.sh` imprime un ASCII art y delega. Bien.
- `--quiet` no es quiet: sigue imprimiendo el banner cyan.
- No hay progress bar. Copiar 2 GB en silencio parece un cuelgue.
- No resume; si peta a mitad, deja un REAPER a medio pintar + un backup.
- `uninstall.sh` es restore, no uninstall. No borra fuentes de `~/.local/share/fonts/ReaFull`. El nombre miente.
- `ls -d ${CONFIG_DIR}_backup_pre_*` sin quotes rompe si el path tiene espacios.
- No hay `set -u` ni validación de que REAPER no está abierto en el uninstall.

#### P2.5 Identidad visual inconsistente

- Dos splashes (ReaFull + ReArtist) se instalan ambos (el de ReArtist queda en `assets/branding/` y no se copia, pero vive en el clone).
- Theme adjuster, mouse map y logos internos siguen siendo ReArtist.
- Menú del updater en español; CLI y README en inglés; scripts de Edu en inglés/español mezclado.
- Typo “LGLP v3” en la licencia de ReArtist.
- `install.py` VERSION year 2025 vs. copyright 2025 vs. fecha real 2026.

#### P2.6 Superficie de scripts de terceros sin curaduría

Embarcar HeDa Track Inspector 2 + HeDaScripts Manager (con `7za.exe`, `curl.exe` y un `.log` de Windows) dentro de un producto Linux es lastre. Track Inspector es de pago / con manager propio: redistribuir su árbol de settings y binarios es un riesgo comercial además de técnico.

Lo mismo aplica a snapshots de Sexan Pie3000, ReaSpaghetti, McSequencer, etc. Un producto curado elige 20 herramientas y las documenta. Un dump embarca 5 000 y reza.

#### P2.7 Calidad de “verify” y de sanitizers

Los sanitizers (`clean_fxfolders.py`, `sanitize_and_prepare.py`) son one-shots de migración, no gates. Prueba: después de correrlos, `reaper.template.ini` **sigue** teniendo `J:\` y `F:\`. El gate no existe.

`apply_rebranding.py` hace `content.replace("ReArtist", "ReaFull")` en menús. Eso es un replace ciego: puede romper créditos, comentarios o IDs que debían quedarse.

---

### P3 — Pulido

- `__startup.lua` tiene líneas en blanco de más y cero cabecera de producto.
- `Grooves/` está duplicado: `assets/Grooves` y `assets/Data/Grooves`.
- `tilr_*` y `tilr8_*` conviven (muestras wav × 2).
- `MouseMaps` no tiene variante ReaFull.
- `LangPack/` (10 MB) se instala sin preguntar idioma.
- `reaper_www_root/` (5,4 MB) no se menciona en el README.
- Keymaps extra (`DK keymap`, `German Keymap`) sin documentación de cuándo usarlos.
- `pgrep -x reaper` no cubre `reaper.bin` / AppImage.
- `fc-cache` se llama aunque `fc-cache` no exista (`install.sh` solo avisa).
- Links SWS/ReaPack solo buscan 4 paths x86_64. No ARM64, no `/usr/lib64`, no `~/.local`.
- `safe_copy_tree` silencia errores de copia: un JSFX a medio copiar se instala “OK”.
- No hay `CONTRIBUTING`, ni política de “qué se acepta en el bundle”.

---

## 5. Recorrido de usuario (journey audit)

### 5.1 Descubrimiento

El README se lee bien: hero, bullets, lista de FX con nombres que suenan a hardware, CLI. El splash ayuda. Falta una captura **real** de REAPER ya tematizado (TCP/MCP/mixer), que es lo que vende una suite de DAW. Un usuario de Ardour/Bitwig no puede imaginar el look.

### 5.2 Instalación (primeros 10 minutos)

1. Clone de **2,1 GB**. Fricción alta. No hay release zip “core”.
2. `./install.sh` — OK para Linux.
3. Si REAPER está abierto, pregunta. Bien.
4. Backup silencioso de todo `~/.config/REAPER`. En una instalación ya grande, el usuario no sabe que acaba de gastar otros 2 GB.
5. Copia masiva sin progreso.
6. Fin: “Start REAPER now”. Cero checklist (cierra sesión PipeWire? instala SWS? cierra y abre?).

**Momento de verdad:** al abrir REAPER, el theme Pro debería cargarse y el splash verse. Eso probablemente funciona. Luego:

- Tres tools de FTC se auto-lanzan.
- El browser de FX muestra “ReArtist Pro” en cada analog.
- Recent projects puede listar discos `J:\` que no existen.
- El keymap ha sustituido al del usuario.

No hay tour, ni “ReaFull Hub”, ni página de bienvenida. El updater está enterrado en `Scripts/ReaFull/`.

### 5.3 Uso diario

Aquí el producto **gana**, si el usuario acepta el workflow ReArtist:

- Templates de pista con iconos y autocolor SWS.
- Mix-Chan / Mix-Bus / Sum-Desk como metáfora de consola.
- Screensets de mezcla vs. edición.
- Render presets LUFS listos.
- Grooves MPC/SP1200/ASR10 — un detalle de productor, no de informático.

Eso es el *core loop* y está heredado, no inventado. Está bien heredarlo. Hay que **nombrarlo y documentarlo**.

### 5.4 Update / uninstall

Update: roto (no hay releases) o peligroso (main + `--no-backup`).
Uninstall: restore de backup, no desinstalación. Las fuentes quedan. Flatpak no está cubierto.

### 5.5 Soporte

Sin ISSUE_TEMPLATE, sin FAQ, sin “known Linux issues”. El usuario irá a GitHub Issues o a Discord de REAPER hablando de ReArtist y de ReaFull a la vez. Soporte imposible de escalar.

---

## 6. Arquitectura de producto (cómo está hecho vs. cómo debería)

```
Hoy:
  [Dump Windows ReArtist]
        │  scripts/*_prepare.py  (rutas hardcodeadas de /home/julesklord)
        ▼
  [Repo 2.1 GB, dual brand]
        │  install.py  (copytree + merge parcial)
        ▼
  [~/.config/REAPER  o  Flatpak, a veces el equivocado]
        │  updater.lua  (git main, no-backup)
        ▼
  [Deriva / overwrite]

Debería:
  [Fuente ReArtist versionada + parches Linux/ReaFull]
        │  pipeline reproducible (sanitize → audit paths → pack)
        ▼
  [Artefacto "reafull-core-x.y.z.tar.zst" + opcional "reafull-extras"]
        │  installer: perfil Fresh | Overlay, target nativo/Flatpak explícito
        ▼
  [REAPER]  +  health-check  +  updater por tag firmado
```

El gap no es técnico, es de **disciplina de producto**: dejar de tratar el working copy como el release.

---

## 7. Riesgos

| Riesgo | Prob. | Impacto | Nota |
|---|---|---|---|
| Usuario pierde keymap/menús y culpa a ReaFull en público | Alta | Alto | P0.1 |
| Takedown / roce con Cockos por los PDF oficiales | Baja | Alto | Fácil de evitar |
| Roce con Tukan / Sonic Anomaly / HeDa por redistribución + rebrand | Media | Alto | El ABOUT de Edu es honesto; el MIT de raíz no |
| Edu Serra no reconoce este port / conflicto de marca ReArtist | Media | Alto | Hay crédito, no hay evidencia de acuerdo escrito en el repo |
| Updater pisa una sesión Flatpak | Media | Alto | P0.4 |
| Clone de 2 GB + backups llenan el disco | Alta | Medio | P2.1 |
| “100 % sanitized” se desmiente en 30 segundos con `rg 'J:\\'` | Alta | Medio | Daña credibilidad |
| Snapshot de ReaTeam se pudre y choca con ReaPack | Alta | Medio | P2.3 / P2.6 |

---

## 8. Roadmap recomendado (para poder decir “v1.0”)

Ordenado por retorno de confianza, no por brillo.

### Sprint 0 — Dejar de hacer daño (antes de cualquier anuncio)

1. Limpiar `reaper.template.ini` / `reaper-extstate.template.ini` de rutas, recents, renders, ffmpeg.exe.
2. Borrar `HeDaScripts Manager.log`, `ReaImGui/*.ini` de runtime, `.exe`, PDFs de Cockos, `ogler.clap` si no hay licencia.
3. El instalador **no sobrescribe** `reaper-kb.ini`, `reaper-mouse.ini`, `reapack.ini` si existen, salvo `--force`.
4. Updater: desactivar download de `main` hasta tener releases. Dejar solo “sync ReaPack” + “reload theme”.
5. `NOTICE.md` + aclarar que MIT cubre el instalador, no el bundle.

### Sprint 1 — Producto honesto

6. Decidir A o B (port ReArtist vs. marca propia) y eliminar el árbol duplicado (605 MB).
7. Perfiles de instalación: `core` / `full`.
8. Wizard de target: Native vs Flatpak vs path.
9. Llamar a `verify_installation.py` al final, y endurecerlo (cero `C:\`, cero `{{…}}` literales).
10. README honesto: qué se pisa, qué se preserva, requisitos SWS/ReaPack/PipeWire, tamaño del clone.

### Sprint 2 — Se siente como un producto

11. Guía “First 15 minutes” + cheat sheet del keymap.
12. Screenshot real del mixer Pro.
13. `__startup.lua` opt-in, o un “ReaFull Setup” al primer launch.
14. Detección PipeWire/JACK + mensaje si `mlockall`/rtprio no están disponibles.
15. Progress en el instalador. Uninstall que desinstale (fuentes incluidas) además de restore.
16. Tag `v2026.1.0`, GitHub Release, changelog. Apuntar el updater a ese tag con checksum.

### Sprint 3 — Sostenible

17. Dejar de vendorar ReaTeam entero. ReaPack remotes + un pin de versiones.
18. CI: `python3 install.py --dry-run` + linter de paths Windows + test de placeholders.
19. Quitar `AGENTS.md` genérico o sustituirlo por convenciones reales del repo.
20. Acuerdo explícito (aunque sea un mail archivado / sección de créditos firmada) con el linaje ReArtist / Tukan / Sonic Anomaly.

---

## 9. Criterios de salida para un “Go” de lanzamiento

Un v1.0 público debería cumplir **todos**:

- [ ] `rg '[A-Z]:\\\\|C:/Program Files' config_templates assets/Scripts/ReaFull` → 0 hits de sesión
- [ ] Ningún `.exe`, `.log` de usuario, ni PDF copyright Cockos en el árbol
- [ ] Un solo árbol de FX (ReaFull **o** ReArtist), no los dos
- [ ] Instalador con perfiles Fresh / Overlay; Overlay no pisa kb/mouse/reapack
- [ ] `--target` / detección pregunta si hay native + Flatpak
- [ ] Health-check post-install con exit code ≠ 0 si falla
- [ ] Updater solo habla con un release tag + checksum, o está desactivado
- [ ] `NOTICE.md` / `THIRD_PARTY.md` revisados
- [ ] Guía de 15 minutos + 1 screenshot real
- [ ] Clone “core” < 700 MB (idealmente < 400 MB)

Hoy el producto **no pasa ninguno** de esos checks de forma limpia.

---

## 10. Conclusión

ReaFull tiene el material de un gran producto Linux: una consola analog-modeled, un vocabulario de templates que entiende géneros reales (no solo “EDM starter”), y un instalador que ya piensa en ALSA, backups y Flatpak. Eso es más de lo que ofrecen la mayoría de “REAPER configs” que circulan como zips opacos.

Lo que no tiene todavía es **disciplina de producto**.

Es un working copy de una migración Windows → Linux, publicado con un README que habla como si la migración hubiera terminado. El usuario paga esa distancia con un clone de 2 GB, un keymap pisado, un FX browser que dice ReArtist, un historial de proyectos ajenos y un botón de Update que no debería existir.

La buena noticia: casi todo lo P0/P1 es higiene y decisiones, no DSP ni diseño. En dos sprints cortos ReaFull puede pasar de “dump con aspiraciones” a “la forma canónica de usar REAPER en Linux”. Hasta entonces, el veredicto honesto es:

> **Úsalo en local, con backup, sabiendo que estás instalando ReArtist Pro sanitizado a medias.**  
> **No lo anuncies todavía como suite nativa, no-destructiva y battery-included.**

---

### Anexo A — Inventario rápido

| Componente | Cantidad / tamaño | Notas de calidad |
|---|---|---|
| Temas | 8 zips (4+4 clones) | Idénticos ReaFull/ReArtist |
| JSFX Analog | 382 MB × 2 | Nombres y logos ReArtist |
| JSFX Digital | 223 MB × 2 | Idem |
| Track templates | 200 / 16 categorías | Punto fuerte |
| Project templates | 19 | Punto fuerte; paths OK |
| Scripts Lua | ~5 042 | Dump, no curaduría |
| Grooves | 82 + copia en `Data/` | Duplicados |
| Fonts | 11 archivos | 3 sin licencia en el repo |
| Config templates | 22 INI | 2 aún con paths Windows |
| Binarios Windows | 5 `.exe` | HeDa Manager |
| Tests automatizados | 0 | — |
| Releases GitHub | 0 | Updater inútil |
| Guía de usuario ReaFull | 0 | — |

### Anexo B — Archivos clave revisados

- `README.md`, `LICENSE`, `install.py`, `install.sh`, `uninstall.sh`
- `scripts/{sanitize_and_prepare,apply_rebranding,clean_fxfolders,clean_templates_final,verify_installation}.py`
- `config_templates/reaper.template.ini`, `reaper-extstate.template.ini`, `S&M.template.ini`, `reapack.ini`, `reaper-kb.ini`
- `assets/Scripts/ReaFull/ReaFull_Updater.lua`, `assets/Scripts/__startup.lua`
- `assets/Licences/*`, `assets/Effects/ReaFull Analog FX/ABOUT THIS PLUGIN COLLECTION.txt`
- Inventario de `assets/{ColorThemes,Effects,Scripts,UserPlugins,ProjectTemplates,TrackTemplates,Docs}`

### Anexo C — Método

Auditoría estática del repositorio (lectura de instalador, plantillas, licencias, updater, README; medición de tamaños y duplicados; búsqueda de paths Windows, binarios y leftovers de sesión). No se ejecutó el instalador contra un REAPER vivo ni se validó DSP/audio de los JSFX. Las notas de UX in-DAW se infieren del arranque (`__startup.lua`), templates y configs, no de una sesión de mezcla.
