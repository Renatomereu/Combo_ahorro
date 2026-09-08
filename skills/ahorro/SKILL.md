---
name: ahorro
description: Coordina componentes instalados para reducir salida, contexto y tokens en Codex y Claude Code. Usar con `$ahorro`, `/ahorro`, o cuando el usuario pida ahorrar tokens.
---

# Ahorro

Activa respuestas breves mediante Caveman `full` y usa componentes solo cuando estén instalados e integrados:

- RTK para comprimir salida de terminal.
- ccusage para medir, no para reducir.
- Context Mode para datos grandes, sandbox, MCP y continuidad.
- Serena para navegación y edición semántica.
- Graphify para mapas persistentes de relaciones y consultas de arquitectura.

Al activarse:

1. Explicar cada componente en una línea.
2. Comprobar versiones y disponibilidad real.
3. No afirmar integración por tener solo un ejecutable instalado.
4. Ejecutar ccusage una vez al activar o cuando el usuario pida medición.
5. Mantener respuestas breves hasta `modo normal`; no comprimir advertencias de seguridad, acciones irreversibles ni pasos cuyo orden importe.
6. Si Graphify se usa en un proyecto, sugerir repositorio GitHub para `graphify-out/` y documentación de continuidad. Pedir confirmación antes de crear o publicar; excluir secretos, cachés, rutas locales, historiales y datos personales.

Para Context Mode en Codex, usar el wrapper `codex/context-mode-sessionstart-minimal.ps1` solo con autorización: acorta `startup` y conserva `resume/compact`.
