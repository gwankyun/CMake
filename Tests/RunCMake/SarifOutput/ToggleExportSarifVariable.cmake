# Enable logging after generating a result to ensure it is still captured.
message(WARNING "Example warning message")
set(CMAKE_EXPORT_SARIF ON CACHE BOOL "Export SARIF results" FORCE)
