# [string]$path = ".\build"
# if ($args.Length -gt 1)
# {
#     $path = $args[1]
# }
# cmake --build $path --target documentation --config Debug

$current = $PWD
$build = Join-Path $current "build"
$fileOld = Join-Path $build "schema.yaml"
$fileNew = Join-Path $current "Help/manual/presets/schema.yaml"

$genPresets = $false

if (-not (Test-Path $fileOld)) {
    Copy-Item -Path $fileNew -Destination $build
    $genPresets = $true
}

$itemOld = Get-Item $fileOld
$itemNew = Get-Item $fileNew

if ($itemNew.LastWriteTime -gt $itemOld.LastWriteTime) {
    $genPresets = $true
}

if ($genPresets) {
    Set-Location Utilities/Scripts
    py regenerate-presets.py
    Copy-Item -Path $fileNew -Destination $build
    Set-Location $current
}

cmake --build --preset msvc
