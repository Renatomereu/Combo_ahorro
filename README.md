# Combo Ahorro

Instalación guiada y portable para reducir salida, contexto y uso innecesario de tokens en Codex y Claude Code.

## Qué incluye

`ahorro` es la skill general. Orquesta componentes oficiales, comprueba cuáles están disponibles y no afirma que una integración exista sin validarla.

| Componente | Utilidad | Repositorio oficial |
|---|---|---|
| Caveman | Respuestas breves: elimina relleno sin ocultar comandos, errores ni advertencias. | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) |
| RTK | Comprime salida de terminal antes de que llegue al agente. | [rtk-ai/rtk](https://github.com/rtk-ai/rtk) |
| ccusage | Mide uso local de tokens en Codex y Claude Code. | [ryoppippi/ccusage](https://github.com/ryoppippi/ccusage) |
| Context Mode | Envía datos grandes a sandbox/MCP y conserva continuidad de sesión. | [mksglu/context-mode](https://github.com/mksglu/context-mode) |
| Serena | Navegación y edición semántica mediante MCP/LSP. | [oraios/serena](https://github.com/oraios/serena) |
| Graphify | Crea un mapa consultable de relaciones entre código y documentación. | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) |

Cuando Graphify se use sobre un proyecto, debe sugerir un repositorio GitHub privado o público según la decisión del usuario para guardar `graphify-out/`, documentación de continuidad y decisiones. Nunca debe subir secretos, cachés, rutas locales, historiales ni datos personales; debe pedir confirmación antes de crear el repositorio o publicar.

## Instalación

Entrega [INSTALL_PROMPT.md](INSTALL_PROMPT.md) a Codex o Claude Code. El agente debe explicar cada componente, instalarlo bajo el paraguas `$ahorro`/`/ahorro`, comprobar integración y configurar activación automática.

## Activación por defecto

- Codex: fusionar [templates/AGENTS-ahorro.md](templates/AGENTS-ahorro.md) en `~/.codex/AGENTS.md`.
- Claude Code: fusionar [templates/CLAUDE-ahorro.md](templates/CLAUDE-ahorro.md) en `~/.claude/CLAUDE.md`.

No sustituir esos archivos: pueden contener instrucciones del usuario.

## Licencias y privacidad

Combo Ahorro enlaza proyectos de terceros y no redistribuye sus archivos. Revisar licencia y términos de cada repositorio antes de instalar. Este repositorio no contiene credenciales, rutas personales, historiales ni datos privados.
