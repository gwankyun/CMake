$erroractionpreference = "stop"

$version = "4.3.2"

if ("$env:PROCESSOR_ARCHITECTURE" -eq "AMD64") {
    $sha256sum = "83D20C23F5C5F64B3B328785E35B23C532E33057A97ED6294ACACA3781B78A01"
    $platform = "windows-x86_64"
} elseif ("$env:PROCESSOR_ARCHITECTURE" -eq "ARM64") {
    $sha256sum = "42A2A88FC57E70D04A92F6EAAAC2094241995F53584BC2AFDAE7E6EF982B3781"
    $platform = "windows-arm64"
} else {
    throw ('unknown PROCESSOR_ARCHITECTURE: ' + "$env:PROCESSOR_ARCHITECTURE")
}

$filename = "cmake-$version-$platform"
$tarball = "$filename.zip"

$outdir = $pwd.Path
$outdir = "$outdir\.gitlab"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "https://github.com/Kitware/CMake/releases/download/v$version/$tarball" -OutFile "$outdir\$tarball"
$hash = Get-FileHash "$outdir\$tarball" -Algorithm SHA256
if ($hash.Hash -ne $sha256sum) {
    exit 1
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("$outdir\$tarball", "$outdir")
Move-Item -Path "$outdir\$filename" -Destination "$outdir\cmake"
Remove-Item "$outdir\$tarball"
