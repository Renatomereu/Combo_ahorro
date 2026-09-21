---
name: ahorro
description: Coordina componentes instalados para reducir salida, contexto y tokens en Codex y Claude Code. Usar con `$ahorro`, `/ahorro`, o cuando el usuario pida ahorrar tokens.
---

# Ahorro

Combo Ahorro tiene dos niveles. El nivel base se activa siempre. El nivel código solo aplica en proyectos donde el agente lee o escribe código. Antes de activarlo, comprobar los permisos, el contenido accesible, los datos guardados localmente y cualquier envío a proveedores externos; adaptar su uso a las reglas del proyecto y de la organización.

## Nivel base (todo proyecto)

- Caveman `full`: respuestas breves, sin relleno, sin recortar código, comandos, errores ni advertencias de seguridad.
- ccusage: medir uso de tokens, no reducirlo. Ejecutar solo al activar `/ahorro`, cuando el usuario pida medición, o al terminar una tarea larga.

## Nivel código (solo proyectos de código, activado por proyecto)

- Serena: navegación y edición por símbolos en vez de leer archivos completos. Requiere `serena setup claude-code` ejecutado una vez en ese proyecto.
- Graphify: mapa consultable de las relaciones del código, actualizado solo con hooks de git. Antes de incluir documentos, PDFs u otros archivos no destinados al análisis de código, comprobar si el paso semántico los enviará a un modelo externo y usar únicamente proveedores aprobados para esos datos.

Antes de dar por activo cualquier componente del nivel código, comprobar que está realmente registrado en ese proyecto (no basta con que el binario exista en el sistema).

## Reglas de trabajo (no requieren instalar nada, ahorran más que las herramientas)

1. Una sesión por tarea. No arrastrar una sesión larga a varias tareas distintas: cada mensaje nuevo carga todo el historial anterior.
2. Elegir el modelo y el esfuerzo según la tarea. Tareas rutinarias (ajustes de texto, campos, estilos) no necesitan el modelo ni el esfuerzo más altos.
3. Mantener `AGENTS.md` de cada proyecto al día. Leerlo antes de explorar el código a mano evita releer el repositorio entero al empezar.

## Al activarse (`/ahorro`, `$ahorro`)

1. Explicar en una línea qué hace cada componente presente.
2. Comprobar versiones y disponibilidad real, no solo si el ejecutable existe.
3. No afirmar integración por tener solo un ejecutable instalado.
4. Ejecutar ccusage una vez al activar o cuando el usuario pida medición.
5. Mantener respuestas breves hasta `modo normal`; no comprimir advertencias de seguridad, acciones irreversibles ni pasos cuyo orden importe.
6. Si Graphify se usa en un proyecto, sugerir repositorio GitHub para `graphify-out/` y documentación de continuidad. Pedir confirmación antes de crear o publicar; excluir secretos, cachés, rutas locales, historiales y datos personales. Repo privado por defecto si el proyecto no es público.

Para desactivar: `modo normal` (detiene las preferencias solo en la sesión actual) o `/caveman off` (detiene Caveman).
