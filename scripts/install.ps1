<#
.SYNOPSIS
  Instala el nivel base de Combo Ahorro (skills ahorro + caveman, sección en CLAUDE.md/AGENTS.md).
  El nivel código (Serena, Graphify) se instala aparte, proyecto por proyecto, con -CodeProject.

.EXAMPLE
  .\scripts\install.ps1
  Instala el nivel base para Claude Code (y Codex si detecta ~/.codex).

.EXAMPLE
  .\scripts\install.ps1 -CodeProject "C:\ruta\a\mi-proyecto"
  Además del nivel base, registra Serena como servidor MCP en ese proyecto.
#>

param(
    [string]$CodeProject
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot

function Write-Status($label, $ok, $detail = "") {
    $mark = if ($ok) { "OK" } else { "--" }
    Write-Host ("  [{0}] {1} {2}" -f $mark, $label, $detail)
}

Write-Host "=== Combo Ahorro: instalando nivel base ===" -ForegroundColor Cyan

# 1. Skills -> ~/.claude/skills
$claudeSkills = Join-Path $env:USERPROFILE ".claude\skills"
New-Item -ItemType Directory -Force -Path $claudeSkills | Out-Null

foreach ($skill in @("ahorro", "caveman")) {
    $src = Join-Path $repoRoot "skills\$skill"
    $dst = Join-Path $claudeSkills $skill
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    Copy-Item -Path "$src\*" -Destination $dst -Recurse -Force
    Write-Status "skill '$skill' copiada a $dst" $true
}

# 2. Fusionar seccion en ~/.claude/CLAUDE.md (sin borrar nada existente)
function Merge-Section($targetFile, $templateFile) {
    $template = Get-Content $templateFile -Raw
    $startMarker = "<!-- combo-ahorro:start -->"
    $endMarker = "<!-- combo-ahorro:end -->"

    if (-not (Test-Path $targetFile)) {
        New-Item -ItemType File -Force -Path $targetFile | Out-Null
    }
    $current = Get-Content $targetFile -Raw
    if ($null -eq $current) { $current = "" }

    if ($current -match [regex]::Escape($startMarker)) {
        # Ya existe una seccion de combo-ahorro: reemplazarla por la version nueva
        $pattern = "(?s)$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))"
        $updated = [regex]::Replace($current, $pattern, $template.Trim())
        Set-Content -Path $targetFile -Value $updated -NoNewline
        return "actualizada"
    } else {
        $separator = if ($current.TrimEnd().Length -gt 0) { "`r`n`r`n" } else { "" }
        Add-Content -Path $targetFile -Value ($separator + $template)
        return "anadida"
    }
}

$claudeMd = Join-Path $env:USERPROFILE ".claude\CLAUDE.md"
$templateClaude = Join-Path $repoRoot "templates\CLAUDE-ahorro.md"
$resultClaude = Merge-Section $claudeMd $templateClaude
Write-Status "seccion en $claudeMd" $true "($resultClaude)"

if (Test-Path (Join-Path $env:USERPROFILE ".codex")) {
    $agentsMd = Join-Path $env:USERPROFILE ".codex\AGENTS.md"
    $templateAgents = Join-Path $repoRoot "templates\AGENTS-ahorro.md"
    $resultAgents = Merge-Section $agentsMd $templateAgents
    Write-Status "seccion en $agentsMd" $true "($resultAgents)"
} else {
    Write-Status "Codex no detectado (~/.codex no existe), se omite AGENTS.md" $false
}

# 3. Comprobar componentes reales, sin instalar nada mas por defecto
Write-Host ""
Write-Host "=== Estado de componentes ===" -ForegroundColor Cyan
$ccusage = Get-Command ccusage -ErrorAction SilentlyContinue
Write-Status "ccusage" ([bool]$ccusage) $(if ($ccusage) { $ccusage.Source } else { "no instalado (opcional, para medir)" })

$serena = Get-Command serena -ErrorAction SilentlyContinue
Write-Status "serena (nivel codigo)" ([bool]$serena) $(if ($serena) { $serena.Source } else { "no instalado" })

$uvx = Get-Command uvx -ErrorAction SilentlyContinue
Write-Status "uvx (necesario para Graphify)" ([bool]$uvx) $(if ($uvx) { $uvx.Source } else { "no instalado" })

# 4. Nivel codigo, opcional, solo si se pide un proyecto
if ($CodeProject) {
    Write-Host ""
    Write-Host "=== Nivel codigo para: $CodeProject ===" -ForegroundColor Cyan
    if (-not (Test-Path $CodeProject)) {
        Write-Host "  Ruta no encontrada: $CodeProject" -ForegroundColor Yellow
    } elseif (-not $serena) {
        Write-Host "  Serena no esta instalado. Instalalo primero: https://github.com/oraios/serena" -ForegroundColor Yellow
    } else {
        Write-Host "  Registrando Serena para Claude Code..."
        Push-Location $CodeProject
        try {
            serena setup claude-code
            Write-Status "Serena registrado en $CodeProject" $true
        } catch {
            Write-Host "  No se pudo registrar Serena automaticamente: $($_.Exception.Message)" -ForegroundColor Yellow
        } finally {
            Pop-Location
        }
    }
    Write-Host ""
    Write-Host "  Graphify no se instala aqui. Es una herramienta Python (uv tool install)." -ForegroundColor Yellow
    Write-Host "  Instalalo a mano solo si vas a usarlo, y nunca sobre carpetas con datos de pacientes." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Resumen ===" -ForegroundColor Cyan
$extra = if (Test-Path (Join-Path $env:USERPROFILE ".codex")) { " y AGENTS.md" } else { "" }
Write-Host "  Instalado:  skills ahorro + caveman, seccion en CLAUDE.md$extra"
Write-Host "  Operativo:  se activa con /ahorro en la proxima sesion de Claude Code"
Write-Host "  Pendiente:  Serena y Graphify (nivel codigo) se activan por proyecto, no por defecto"
Write-Host ""
Write-Host "Abre una sesion nueva de Claude Code para que el cambio en CLAUDE.md tenga efecto." -ForegroundColor Green
