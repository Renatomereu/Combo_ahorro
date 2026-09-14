# Combo Ahorro

Reduce cuánto gastan en tokens Claude Code y Codex, sin instalar nada complicado. Pensado para alguien que no programa pero usa estos agentes a diario sobre proyectos reales (Lovable + Supabase + GitHub).

## Instalación (un solo comando)

Descarga o clona este repositorio y, desde una terminal PowerShell en la carpeta del repo, ejecuta:

```powershell
.\scripts\install.ps1
```

Esto instala el **nivel base**: funciona en todos tus proyectos, no toca tu código, no sube nada a ningún sitio.

Para desinstalarlo:

```powershell
.\scripts\uninstall.ps1
```

Ninguno de los dos scripts borra instrucciones tuyas que ya tuvieras en `CLAUDE.md` o `AGENTS.md`: solo añaden o quitan un bloque marcado, propio de Combo Ahorro.

## Qué instala el nivel base

| Componente | Qué hace | Coste / riesgo |
|---|---|---|
| Skill `ahorro` | Coordina todo lo demás, activable con `/ahorro` o `$ahorro`. | Ninguno |
| Skill `caveman` (solo la parte MIT) | Respuestas más breves sin perder código, errores ni avisos de seguridad. Del proyecto [caveman](https://github.com/JuliusBrussee/caveman) — aquí solo se usa el archivo de la skill, no su proxy con licencia BSL-1.1. | Ninguno |
| ccusage | Mide cuántos tokens gastas. No reduce nada por sí solo. | Ninguno, opcional |

## Nivel código (aparte, proyecto por proyecto)

Solo tiene sentido en proyectos donde un agente lee o escribe código de verdad. **Nunca actives esto en carpetas con datos de pacientes o información sensible.**

- **Serena** — en vez de leer archivos enteros, el agente pide directamente "la función que hace X". Instálalo desde [oraios/serena](https://github.com/oraios/serena) y luego, dentro de la carpeta de tu proyecto, ejecuta:

  ```powershell
  .\scripts\install.ps1 -CodeProject "C:\ruta\a\tu\proyecto"
  ```

  Esto registra Serena solo en ese proyecto, no en todos.

- **Graphify** — mapa consultable de cómo se relaciona tu código, útil si trabajas el mismo repo con más de un agente (por ejemplo Codex y Claude Code). Herramienta en Python, se instala con `uv tool install` desde [rhanka/graphify](https://github.com/rhanka/graphify). Su análisis de código no usa IA, pero el análisis de documentos y PDFs sí: apúntalo solo a repos de código, nunca a carpetas de documentación clínica.

## Lo que ahorra más y no hay que instalar

1. **Una sesión por tarea.** Una sesión larga arrastra todo su historial en cada mensaje nuevo.
2. **Elegir el modelo según la tarea.** El modelo y el esfuerzo más altos no hacen falta para cambios rutinarios.
3. **Mantener `AGENTS.md` al día en cada proyecto.** Evita que el agente se relea el repositorio entero al empezar.

## Lo que deliberadamente no incluye

- **RTK** — comprime la salida de la terminal antes de que el agente la vea. El riesgo es que si comprime mal un error, el agente (y tú) os enteráis tarde. No compensa si no trabajas mucho por terminal.
- **Context Mode** — pensado para volúmenes de datos grandes que estos proyectos no tienen; es la pieza más compleja de configurar y la que más puede romperse.
- **El proxy de Caveman** (la parte con licencia BSL-1.1, no libre del todo) — solo se usa su skill.

Si algún día los necesitas, siguen disponibles en sus repositorios oficiales; simplemente no forman parte de este combo.

## Licencias y privacidad

Combo Ahorro enlaza proyectos de terceros y no redistribuye sus binarios ni su código con licencia restrictiva. La única excepción es el archivo de la skill de Caveman (`skills/caveman/SKILL.md`), que es texto plano bajo licencia MIT del propio proyecto. Revisa la licencia de cada herramienta antes de usarla. Este repositorio no contiene credenciales, rutas personales, historiales ni datos privados.
