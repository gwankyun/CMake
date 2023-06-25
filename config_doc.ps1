[string]$path = ".\build"
if ($args.Length -gt 1)
{
    $path = $args[1]
}
cmake -S . -B $path -D SPHINX_HTML=ON
