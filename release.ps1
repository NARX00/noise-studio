# release.ps1 — Windows version of the release script.
# Regenerates the SHA-256 checksum for index.html and syncs it into
# README.md and index.html.sha256. Run after ANY edit to index.html.
#
# Usage (in PowerShell, from the repo folder):
#   .\release.ps1
# If blocked by execution policy, run once:
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$ErrorActionPreference = "Stop"

$File    = "index.html"
$SumFile = "index.html.sha256"
$Readme  = "README.md"

if (-not (Test-Path $File)) {
    Write-Error "$File not found. Run this from the repository root."
    exit 1
}

# --- compute SHA-256 (lowercase to match sha256sum output) ---
$Hash = (Get-FileHash $File -Algorithm SHA256).Hash.ToLower()
Write-Host "SHA-256($File) = $Hash"

# --- write the checksum file in 'HASH  FILE' format (two spaces) ---
"$Hash  $File" | Out-File -FilePath $SumFile -Encoding ascii -NoNewline
Add-Content -Path $SumFile -Value "`n" -NoNewline
Write-Host "Wrote $SumFile"

# --- update the fingerprint inside README.md, if present ---
if (Test-Path $Readme) {
    $content = Get-Content $Readme -Raw
    $pattern = '[0-9a-f]{64}  index\.html'
    if ($content -match $pattern) {
        $content = [regex]::Replace($content, $pattern, "$Hash  index.html")
        # write back without a trailing BOM
        [System.IO.File]::WriteAllText((Resolve-Path $Readme), $content)
        Write-Host "Updated fingerprint in $Readme"
    } else {
        Write-Host "Note: no 'HASH  index.html' line found in $Readme to update."
    }
}

Write-Host "Done. Review changes, then: git add -A; git commit -m 'release: update build + checksum'"
