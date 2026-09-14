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

# Windows PowerShell 5.1 no siempre lee/escribe UTF-8 por defecto (segun el
# codepage del sistema), lo que puede corromper acentos y eñes al fusionar
# texto. Forzamos UTF-8 explicito en cada lectura y escritura de este script.
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
function Get-TextUtf8($path) {
    if (-not (Test-Path $path)) { return "" }
    return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
}
function Set-TextUtf8($path, $text) {
    [System.IO.File]::WriteAllText($path, $text, $Utf8NoBom)
}

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

# 2. Fusionar seccion en ~/.claude/CLAUDE.md (sin borrar nada mas del archivo)
#
# Detecta tambien instalaciones viejas hechas a mano con el INSTALL_PROMPT.md
# anterior: esas dejaron un encabezado "## Ahorro por defecto" SIN el marcador
# HTML y sin "(Combo Ahorro)" en el titulo. Si aparece, se sustituye igual que
# la version marcada, para que no queden las dos secciones duplicadas.
function Remove-LegacySection([string]$text) {
    # Encabezado exacto de la version vieja, hasta el siguiente "## " o fin de archivo.
    $legacyPattern = "(?ms)^##\s*Ahorro por defecto\s*$.*?(?=^##\s|\z)"
    if ($text -match $legacyPattern) {
        return @{ Text = [regex]::Replace($text, $legacyPattern, ""); Found = $true }
    }
    return @{ Text = $text; Found = $false }
}

function Merge-Section($targetFile, $templateFile) {
    $template = Get-TextUtf8 $templateFile
    $startMarker = "<!-- combo-ahorro:start -->"
    $endMarker = "<!-- combo-ahorro:end -->"

    $current = Get-TextUtf8 $targetFile

    $legacyResult = Remove-LegacySection $current
    $current = $legacyResult.Text
    $legacyNote = if ($legacyResult.Found) { ", version vieja sin marcar sustituida" } else { "" }

    if ($current -match [regex]::Escape($startMarker)) {
        # Ya existe una seccion de combo-ahorro: reemplazarla por la version nueva
        $pattern = "(?s)$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))"
        $updated = [regex]::Replace($current, $pattern, $template.Trim())
        Set-TextUtf8 $targetFile $updated
        return "actualizada$legacyNote"
    } else {
        $separator = if ($current.TrimEnd().Length -gt 0) { "`r`n`r`n" } else { "" }
        $updated = $current.TrimEnd() + $separator + $template
        Set-TextUtf8 $targetFile $updated
        return "anadida$legacyNote"
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
