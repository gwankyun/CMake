# [string]$path = ".\build"
# if ($args.Length -gt 1)
# {
#     $path = $args[1]
# }
# cmake --build $path --target documentation --config Debug

cmake --build --preset msvc
