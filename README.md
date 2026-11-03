# Combo Ahorro

Ayuda a reducir el uso innecesario de tokens en Claude Code y Codex, con una instalación sencilla. Puede utilizarse en proyectos de distintos sectores; cada usuario debe adaptar las herramientas y los permisos a sus datos y a su forma de trabajar.

## Instalación (un solo comando)

Descarga este repositorio (botón verde "Code" → "Download ZIP" en GitHub, o `git clone`) y descomprímelo. Muchas instalaciones de Windows bloquean por defecto los scripts `.ps1` bajados de internet ("no se puede cargar porque la ejecución de scripts está deshabilitada"); para evitarlo, desde una terminal PowerShell, dentro de la carpeta del repo, ejecuta:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

Ese `-ExecutionPolicy Bypass` solo aplica a este comando, no cambia nada permanente en tu PC. Esto instala el **nivel base**: funciona en todos tus proyectos, no toca tu código, no sube nada a ningún sitio.

Para desinstalarlo:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\uninstall.ps1
```

Ninguno de los dos scripts borra instrucciones tuyas que ya tuvieras en `CLAUDE.md` o `AGENTS.md`: solo añaden o quitan un bloque marcado, propio de Combo Ahorro.

## Actualizar una instalación anterior

Vuelve a descargar el repositorio (o `git pull` si lo clonaste) y ejecuta otra vez el mismo comando de instalación de arriba. Es seguro repetirlo cuantas veces quieras: sustituye la sección vieja por la nueva sin duplicarla, y si alguien instaló una versión muy antigua (la del prompt de texto, sin script) el instalador también la detecta y la reemplaza.

## Qué instala el nivel base

| Componente | Qué hace | Coste / riesgo |
|---|---|---|
| Skill `ahorro` | Coordina todo lo demás, activable con `/ahorro` o `$ahorro`. | Ninguno |
| Skill `caveman` (solo la parte MIT) | Respuestas más breves sin perder código, errores ni avisos de seguridad. Del proyecto [caveman](https://github.com/JuliusBrussee/caveman) — aquí solo se usa el archivo de la skill, no su proxy con licencia BSL-1.1. | Ninguno |
| ccusage | Mide cuántos tokens gastas. No reduce nada por sí solo. | Ninguno, opcional |

## Nivel código (aparte, proyecto por proyecto)

Solo tiene sentido en proyectos donde un agente lee o escribe código. Antes de activarlo, revisa qué archivos podrá leer, qué datos guardará localmente y si alguna operación enviará contenido a un proveedor externo. Si el proyecto contiene información confidencial o datos personales, aplica las reglas de tu organización y limita el acceso a lo necesario.

- **Serena** — en vez de leer archivos enteros, el agente pide directamente "la función que hace X". Instálalo desde [oraios/serena](https://github.com/oraios/serena) y luego, dentro de la carpeta de tu proyecto, ejecuta:

  ```powershell
  .\scripts\install.ps1 -CodeProject "C:\ruta\a\tu\proyecto"
  ```

  Esto registra Serena solo en ese proyecto, no en todos.

- **Graphify** — mapa consultable de cómo se relaciona tu código, útil si trabajas el mismo repo con más de un agente (por ejemplo Codex y Claude Code). Herramienta en Python, se instala con `uv tool install` desde [rhanka/graphify](https://github.com/rhanka/graphify). Su análisis de código no usa IA. Antes de incluir documentos o PDFs, comprueba si el análisis semántico enviará contenido a un modelo externo y usa solo un proveedor aprobado para esos datos.

## Modo privacidad (si trabajas con datos personales de terceros)

Si en tus proyectos hay datos personales de clientes, usuarios o empleados, instala con:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -DatosPersonales
```

Añade una segunda sección marcada a `CLAUDE.md` (y a `AGENTS.md` de Codex) con reglas que tienen prioridad sobre las de ahorro:

- Recordar que todo lo que se abre o pega en la sesión llega al proveedor del modelo, y proponer anonimizar.
- Leer solo los archivos necesarios; no abrir carpetas de datos de terceros sin necesidad.
- No acortar con Caveman textos dirigidos a terceros (mensajes, informes, consentimientos, textos legales).
- No escribir datos personales en `AGENTS.md`, `CLAUDE.md`, memorias, commits ni archivos de repositorio.
- Graphify solo sobre código y sin publicar `graphify-out/`; Serena solo en carpetas de código.

Si lo combinas con `-CodeProject`, también añade `.serena/` y `graphify-out/` al `.gitignore` de ese proyecto.

Lo que el script **no puede hacer por ti** y debes revisar:

1. **Plan y contrato del proveedor de IA.** Comprueba que tu plan incluye un contrato de tratamiento de datos que cubra este uso, según la normativa que te aplique (por ejemplo, el RGPD en la UE). Los planes personales no siempre lo incluyen.
2. **Entrenamiento.** Revisa en la configuración de privacidad de tu cuenta si tus conversaciones se usan para mejorar los modelos.
3. **Historial local.** Claude Code guarda las conversaciones en `~/.claude/projects`. Reduce cuánto tiempo se guardan con `cleanupPeriodDays` en `~/.claude/settings.json`, y protege ese equipo como protegerías los datos originales.
4. **ccusage** lee ese historial en local. Si lo usas, instala una versión concreta en vez de ejecutar siempre la última con `npx`.
5. **Categorías especiales** (salud, datos de menores, etc.): aplica las reglas de tu organización y, ante la duda, anonimiza antes de usar IA.

Esta guía no es asesoramiento legal.

## Lo que ahorra más y no hay que instalar

1. **Una sesión por tarea.** Una sesión larga arrastra todo su historial en cada mensaje nuevo.
2. **Elegir el modelo según la tarea.** El modelo y el esfuerzo más altos no hacen falta para cambios rutinarios.
3. **Mantener `AGENTS.md` al día en cada proyecto.** Evita que el agente se relea el repositorio entero al empezar.

## Lo que deliberadamente no incluye

- **RTK** — comprime la salida de la terminal antes de que el agente la vea. El riesgo es que si comprime mal un error, el agente (y tú) os enteráis tarde. No compensa si no trabajas mucho por terminal.
- **Context Mode** — pensado para volúmenes de datos grandes; requiere una configuración adicional que no compensa en todos los proyectos.
- **El proxy de Caveman** (la parte con licencia BSL-1.1, no libre del todo) — solo se usa su skill.

Si algún día los necesitas, siguen disponibles en sus repositorios oficiales; simplemente no forman parte de este combo.

## Licencias y privacidad

Combo Ahorro enlaza proyectos de terceros y no redistribuye sus binarios ni su código con licencia restrictiva. La única excepción es el archivo de la skill de Caveman (`skills/caveman/SKILL.md`), que es texto plano bajo licencia MIT del propio proyecto. Revisa la licencia de cada herramienta antes de usarla. Este repositorio no contiene credenciales, rutas personales, historiales ni datos privados.
