if ($args.Count -lt 2) {
    Write-Host "Usage: script.ps1 <Path> <SearchPattern> [ShowLines: true|false]"
    exit 1
}

$Path = $args[0]
$Pattern = $args[1]
$ShowLines = $false

if ($args.Count -ge 3) {
    # Normalize value (accepts "true", "1", etc.)
    $ShowLines = ($args[2].ToString().ToLower() -in @("true", "1", "yes"))
}

Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern $Pattern -CaseSensitive:$false -ErrorAction SilentlyContinue
    if ($matches) {
        if ($ShowLines) {
            foreach ($match in $matches) {
                "File: $($match.Path) | Line $($match.LineNumber): $($match.Line.Trim())"
            }
        } else {
            $_.FullName
        }
    }
}
