# Prompt instalador de Combo Ahorro

Pega este prompt en Codex o Claude Code desde una sesión de confianza.

```text
Quiero instalar Combo Ahorro para reducir salida innecesaria, contexto y tokens. Actúa como instalador cuidadoso.

Componentes oficiales, una línea de utilidad cada uno:
- Caveman — reduce relleno y narración; conserva código, comandos, errores y advertencias.
- RTK — comprime salida de terminal antes de entrar en el contexto.
- ccusage — mide uso local de tokens en Codex y Claude Code.
- Context Mode — procesa datos grandes mediante sandbox/MCP y conserva continuidad.
- Serena — navega y edita código por símbolos mediante MCP/LSP.
- Graphify — crea un mapa consultable de relaciones entre código y documentación.

Repositorios oficiales:
- https://github.com/JuliusBrussee/caveman
- https://github.com/rtk-ai/rtk
- https://github.com/ryoppippi/ccusage
- https://github.com/mksglu/context-mode
- https://github.com/oraios/serena
- https://github.com/Graphify-Labs/graphify

Objetivo: instalar y usar todo bajo una skill general llamada `ahorro` (en Claude Code, `/ahorro`; en Codex, `$ahorro`). No sustituyas repositorios oficiales.

Reglas:
1. Antes de instalar, explica cada componente en una línea y diferencia ahorro de salida, ahorro de contexto, medición, navegación semántica y grafo.
2. Inspecciona sistema operativo, agente, PATH, versiones y configuración existente. No muestres secretos.
3. Instala solo componentes ausentes o incompletos. No hagas downgrade automático.
4. Sigue las instrucciones actuales de cada repositorio oficial. Si una instalación requiere permisos, red, login o cambio global, explícalo y pide autorización.
5. Crea o instala la skill orquestadora `ahorro`. Debe aplicar Caveman full por defecto, usar RTK para salidas grandes, ccusage solo al activar/medir, Context Mode para datos grandes, Serena si está integrada y Graphify para preguntas de arquitectura o relaciones cuando exista grafo.
6. No prometas porcentajes de ahorro. Comprueba comportamiento real y separa instalado, operativo e integrado.
7. Codex:
   - Instala skills en `$CODEX_HOME/skills/` o `~/.codex/skills/`.
   - Fusiona `templates/AGENTS-ahorro.md` en `~/.codex/AGENTS.md`; no borres instrucciones existentes.
   - Context Mode: activa MCP y hooks oficiales. Si el bloque SessionStart es demasiado largo, conserva captura y compaction y usa el wrapper mínimo de Combo Ahorro para acortar solo startup; conserva resume/compact completo.
   - Graphify: instala `graphifyy` y registra la skill oficial para Codex; verifica `graphify --version`.
8. Claude Code:
   - Instala skills en `~/.claude/skills/`.
   - Fusiona `templates/CLAUDE-ahorro.md` en `~/.claude/CLAUDE.md`; no borres instrucciones existentes.
   - Context Mode: preferir plugin oficial (`/plugin marketplace add mksglu/context-mode` y `/plugin install context-mode@context-mode`); alternativa MCP-only no activa routing automático.
   - Graphify: instala `graphifyy` y ejecuta `graphify install` para registrar la skill oficial.
9. Cuando Graphify se use sobre un proyecto, sugiere al usuario crear un repositorio GitHub para guardar `graphify-out/`, documentación de continuidad y decisiones. Pregunta antes de crearlo o publicar; ofrece privado como opción predeterminada si el proyecto contiene código no público. Excluye secretos, `.env`, claves, cachés, rutas locales, historiales y datos personales.
10. Entrega instrucciones para activar (`$ahorro` o `/ahorro`), desactivar (`modo normal` o `/caveman off`), medir (`ccusage`, `ctx stats`) y consultar grafos (`/graphify query`).
11. Al final informa brevemente: instalado, operativo, integrado, cambios de configuración, copias de seguridad y pendientes. No publiques ni subas datos del usuario sin confirmación.
```

El prompt debe abrir una sesión nueva tras cambiar instrucciones globales y comprobar activación automática en esa sesión.
