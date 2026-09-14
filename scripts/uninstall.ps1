<#
.SYNOPSIS
  Quita el nivel base de Combo Ahorro: borra las skills ahorro/caveman y retira
  la seccion marcada de CLAUDE.md y AGENTS.md. No toca el resto de esos archivos.
  No desinstala Serena, Graphify, ccusage ni ningun binario: esos se gestionan aparte.
#>

$ErrorActionPreference = "Stop"

# Ver nota en install.ps1: forzamos UTF-8 explicito para no corromper acentos.
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

Write-Host "=== Combo Ahorro: desinstalando nivel base ===" -ForegroundColor Cyan

foreach ($skill in @("ahorro", "caveman")) {
    $dst = Join-Path $env:USERPROFILE ".claude\skills\$skill"
    if (Test-Path $dst) {
        Remove-Item -Recurse -Force $dst
        Write-Status "skill '$skill' eliminada" $true
    } else {
        Write-Status "skill '$skill' no estaba instalada" $true
    }
}

function Remove-Section($targetFile) {
    if (-not (Test-Path $targetFile)) { return "no existia" }
    $startMarker = "<!-- combo-ahorro:start -->"
    $endMarker = "<!-- combo-ahorro:end -->"
    $current = Get-TextUtf8 $targetFile
    if ($current -notmatch [regex]::Escape($startMarker)) { return "sin seccion combo-ahorro" }

    $pattern = "(?s)\r?\n?\r?\n?$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))\r?\n?"
    $updated = [regex]::Replace($current, $pattern, "")
    Set-TextUtf8 $targetFile $updated
    return "seccion retirada"
}

$claudeMd = Join-Path $env:USERPROFILE ".claude\CLAUDE.md"
Write-Status "CLAUDE.md" $true "($(Remove-Section $claudeMd))"

$agentsMd = Join-Path $env:USERPROFILE ".codex\AGENTS.md"
Write-Status "AGENTS.md" $true "($(Remove-Section $agentsMd))"

Write-Host ""
Write-Host "Nivel base desinstalado. Serena, Graphify, ccusage, rtk no se han tocado." -ForegroundColor Green
Write-Host "Si registraste Serena en algun proyecto, revisa el .mcp.json o la config MCP de ese proyecto a mano." -ForegroundColor Yellow
