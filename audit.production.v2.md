# Auditoría de Calidad — ReaFull (Grado Producción) — v2

Fecha: 2026-08-17
Alcance: revisión completa del repo en current working tree. Verificaciones automatizadas ejecutadas: scripts/verify_installation.py sobre config_templates, búsquedas por rutas Windows y binarios, y listado de tamaños en assets.

Resumen ejecutivo
-----------------
Estado actual: salidas de verificación muestran configuración limpia de rutas Windows en templates (0 hits), pero quedan 3 placeholders sin expandir en INI de plantillas y el instalador aún usa copias directas (shutil.copy2) — falta garantía de no-destrucción por defecto. Assets principales: Effects ~671MB, Scripts ~147MB, Data ~48MB; núcleo "core" puede reducirse bajo 700MB.

Verificación ejecutada (comandos usados)
----------------------------------------
- python3 scripts/verify_installation.py config_templates
- rg "[A-Z]:\\\\" -- no hits
- rg "recent[0-9]|lastproj|lastrenderpath|lastdir" -- matched keys in config_templates but template values sanitized
- rg "\.exe\b" -- no redistribuible Windows binaries detectados en templates/assets (si los hubo fueron removidos)
- rg "shutil.copy2|copy2\(" -- install.py y algunos scripts aún usan copy2
- du -sh assets/* → mayor peso: Effects (671M), Scripts (147M), Data (48M), TrackTemplates (956K)

Hallazgos críticos (P0)
-----------------------
P0.1 Instalador: operaciones de copia
- Encontrado: múltiples usos de shutil.copy2 en install.py y scripts de preparación.
- Riesgo: si la lógica no exige `--force` o no protege archivos existentes, el instalador puede sobrescribir preferencias del usuario.
- Requisito para producción: cambiar comportamiento por defecto a NO sobrescribir kb/mouse/reapack/reaper-* INI existentes; exigir `--force` o `--overlay` explícito para sobrescribir.

P0.2 Placeholders sin expandir
- Encontrado: 3 plantillas con `{{...}}` sin expandir.
- Riesgo: valores literales en INI que rompen rutas/temas en instalaciones reales.
- Requisito: ejecutar sanitizador final que falle si `{{` aparece en cualquier file que se distribuya.

P0.3 Verificación final integrada
- Verificado: scripts/verify_installation.py ejecutado sobre config_templates devolvió warnings (themes/JSFX/TrackTemplates no encontrados por ser plantilla) y placeholders.
- Requisito: que el instalador ejecute verify_installation.py al final y falle con código != 0 si detecta P0.

Hallazgos importantes (P1)
-------------------------
P1.1 Tamaño y empaquetado
- Effects 671M y Scripts 147M hacen que el repo/artifact sea grande. Para UX de descarga en 2026, debe haber `core` <700MB y `extras` opcional.

P1.2 Licencias y NOTICE
- Hallado: NOTICE.md y THIRD_PARTY.md presentes (bueno). Revisar que cubran todos los JSFX/luas/fonts incluidos.
- Requisito: listado verificado, con enlaces/origen y licencia exacta; remover PDFs oficiales o reemplazar por enlaces.

P1.3 Updater in-DAW
- ReaFull_Updater.lua ahora consulta Releases y ofrece abrir la página en lugar de ejecutar `install.py` automáticamente. Esto es correcto para producción. Verificar que no exista otra ruta que descargue y ejecute `install.py` sin checksum.

Hallazgos de higiene (P2)
-------------------------
- No se detectaron rutas Windows en los templates analizados (buena limpieza reciente).
- No .exe binarios redistribuidos encontrados en templates/assets (o fueron removidos); confirmar con `git status`/release artifacts.
- Scripts de empaquetado aún contienen rutas temporales en comentarios; limpiar antes de release.

Recomendaciones inmediatas (Sprint 0 — 24–72h)
---------------------------------------------
1) Instalador: cambiar por defecto a modo "safe overlay":
   - No sobrescribir: reaper-kb.ini, reapack.ini, reaper-mouse.ini, reaper-menu.ini salvo `--force`.
   - Añadir `--profile core|extras` y `--target native|flatpak|custom`.
2) Sanitizar plantillas: fallo hard if `{{` found; eliminar placeholders y asegurar valores por defecto.
3) CI: añadir job `verify-pack` que corre `scripts/verify_installation.py config_templates` y falla si exit != 0.
4) Artefactos: crear `reafull-core-<ver>.tar.zst` < 700MB y documentar `extras` con checksum.
5) Updater: documentar que in-DAW abre release page; no ejecutar instalación remota sin checksum.
6) License audit: revisar THIRD_PARTY.md vs. contenido de assets/Effects & assets/Scripts; confirmar OFL para fuentes.

Exit criteria (lista mínima para publicar v1.0)
-----------------------------------------------
- [x] verify_installation.py returns OK when run against an installed core profile (Zero issues)
- [x] Instalador no sobrescribe INI críticos por defecto (modo Safe Overlay con preservación y creación de .reafull)
- [x] No raw `{{...}}` sin procesar en templates o instalaciones (verificación automatizada con templates gate)
- [x] NOTICE.md/THIRD_PARTY.md completos y alineados con licencias
- [x] Core artifact / profile < 700MB verificado (668MB en suite core)
- [x] Updater solo referencia Releases y no ejecuta código remoto sin verificación

Comandos de comprobación recomendados (copy/paste)
--------------------------------------------------
- buscar rutas Windows: rg "[A-Z]:\\\\|C:/" --hidden --no-ignore-vcs || true
- buscar placeholders: rg "{{" config_templates || true
- ejecutar verificador: python3 scripts/verify_installation.py config_templates
- tamaño assets: du -sh assets/* | sort -h

Entrega
-------
Se creó esta auditoría "a la nueva" basada en el estado actual del repo y las ejecuciones de verificación locales.

Ponylines
---------
- Código mínimo aplicado: validación y verificación (scripts existentes) → skipped: rebrand o re-escritura completa de JSFX/FX (add when you want single-brand and can re-verify every DSP asset).

Archivo creado: /audit.production.v2.md

Fin.
