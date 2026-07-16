# One-shot rebrand: antigravity-awesome-skills -> annias-awesome-skills
$ErrorActionPreference = 'Stop'
$Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
Set-Location $Root

function Rename-AntigravityPaths {
    $dirs = Get-ChildItem -Path $Root -Recurse -Directory -Force |
        Where-Object { $_.Name -match 'antigravity' } |
        Sort-Object { $_.FullName.Length } -Descending
    foreach ($d in $dirs) {
        $newName = $d.Name -replace 'antigravity-awesome-skills-claude', 'annias-awesome-skills-claude' `
            -replace 'antigravity-awesome-skills', 'annias-awesome-skills' `
            -replace 'antigravity-bundle', 'annias-bundle' `
            -replace 'antigravity-agent-manager', 'annias-agent-manager' `
            -replace 'antigravity-design-expert', 'annias-design-expert' `
            -replace 'antigravity-skill-orchestrator', 'annias-skill-orchestrator' `
            -replace 'antigravity-workflows', 'annias-workflows'
        if ($newName -ne $d.Name) {
            $dest = Join-Path $d.Parent.FullName $newName
            if (-not (Test-Path $dest)) {
                Rename-Item -LiteralPath $d.FullName -NewName $newName
            }
        }
    }

    $files = Get-ChildItem -Path $Root -Recurse -File -Force |
        Where-Object { $_.Name -match 'antigravity' }
    foreach ($f in $files) {
        $newName = $f.Name -replace 'antigravity-awesome-skills', 'annias-awesome-skills' `
            -replace 'installer_antigravity_guidance', 'installer_annias_guidance' `
            -replace 'antigravity', 'annias'
        if ($newName -ne $f.Name) {
            $dest = Join-Path $f.DirectoryName $newName
            if (-not (Test-Path $dest)) {
                Rename-Item -LiteralPath $f.FullName -NewName $newName
            }
        }
    }
}

$textExtensions = @(
    '.md', '.json', '.js', '.ts', '.tsx', '.py', '.html', '.svg', '.xml', '.txt',
    '.sh', '.bat', '.cjs', '.mjs', '.tmpl', '.yml', '.yaml', '.csv', '.css', '.scss'
)

$replacements = @(
    @('sickn33.github.io/antigravity-awesome-skills', 'annias.github.io/annias-awesome-skills'),
    @('sickn33/antigravity-awesome-skills', 'annias/annias-awesome-skills'),
    @('annias/antigravity-awesome-skills', 'annias/annias-awesome-skills'),
    @('antigravity-awesome-skills-claude', 'annias-awesome-skills-claude'),
    @('antigravity-awesome-skills', 'annias-awesome-skills'),
    @('Antigravity Awesome Skills', 'Annias Awesome Skills'),
    @('.antigravity-install-manifest.json', '.annias-install-manifest.json'),
    @('installer_antigravity_guidance', 'installer_annias_guidance'),
    @('antigravity-bundle', 'annias-bundle'),
    @('antigravity-agent-manager', 'annias-agent-manager'),
    @('antigravity-design-expert', 'annias-design-expert'),
    @('antigravity-skill-orchestrator', 'annias-skill-orchestrator'),
    @('antigravity-workflows', 'annias-workflows'),
    @('Antigravity CLI', 'Agent CLI'),
    @('Antigravity IDE', 'AI IDE'),
    @(', Antigravity,', ','),
    @('Antigravity,', ''),
    @(' Antigravity ', ' '),
    @('Antigravity', 'Annias'),
    @('--antigravity', '--agents'),
    @('"antigravity"', '"annias-awesome-skills"'),
    @("'antigravity'", "'annias-awesome-skills'"),
    @('antigravity-skills', 'annias-skills'),
    @('antigravity', 'annias')
)

function Update-TextFiles {
    $files = Get-ChildItem -Path $Root -Recurse -File -Force |
        Where-Object {
            $textExtensions -contains $_.Extension.ToLower() -and
            $_.FullName -notmatch '\\node_modules\\' -and
            $_.FullName -notmatch '\\\.git\\' -and
            $_.Name -ne 'rebrand-annias.ps1'
        }
    foreach ($file in $files) {
        try {
            $content = [System.IO.File]::ReadAllText($file.FullName)
            $original = $content
            foreach ($pair in $replacements) {
                $content = $content.Replace($pair[0], $pair[1])
            }
            if ($content -ne $original) {
                [System.IO.File]::WriteAllText($file.FullName, $content)
            }
        } catch {
            Write-Warning "Skip $($file.FullName): $_"
        }
    }
}

Write-Host "Renaming paths..."
Rename-AntigravityPaths
Write-Host "Updating text files..."
Update-TextFiles
Write-Host "Rebrand complete."