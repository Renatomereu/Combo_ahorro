[CmdletBinding()]
param(
    [Parameter(ValueFromPipeline = $true)]
    [string]$InputObject
)

$ErrorActionPreference = 'Stop'
$rawInput = if (-not [string]::IsNullOrWhiteSpace($InputObject)) { $InputObject } else { [Console]::In.ReadToEnd() }
if ([string]::IsNullOrWhiteSpace($rawInput)) { exit 0 }

$contextMode = Get-Command context-mode.cmd -ErrorAction SilentlyContinue
if ($null -eq $contextMode) { $contextMode = Get-Command context-mode -ErrorAction SilentlyContinue }
if ($null -eq $contextMode) { exit 0 }

$psi = [System.Diagnostics.ProcessStartInfo]::new()
$psi.FileName = $contextMode.Source
$psi.Arguments = 'hook codex sessionstart'
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$process = [System.Diagnostics.Process]::new()
$process.StartInfo = $psi
[void]$process.Start()
$process.StandardInput.Write($rawInput)
$process.StandardInput.Close()
$rawOutput = $process.StandardOutput.ReadToEnd()
$process.WaitForExit()
if ([string]::IsNullOrWhiteSpace($rawOutput)) { exit 0 }

try {
    $input = $rawInput | ConvertFrom-Json
    if ([string]$input.source -eq 'startup') {
        $response = $rawOutput | ConvertFrom-Json
        $response.hookSpecificOutput.additionalContext = 'Context Mode activo. Usa ctx_* para procesar datos grandes y conservar contexto.'
        $response | ConvertTo-Json -Depth 20 -Compress
        exit 0
    }
}
catch {
    # Fallback: preserve original response if parsing fails.
}

$rawOutput.Trim()
