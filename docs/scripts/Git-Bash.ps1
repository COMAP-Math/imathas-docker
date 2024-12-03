# Define the paths to add
$gitBinPath = "C:\Program Files\Git\bin"
$gitCmdPath = "C:\Program Files\Git\cmd"

# Get the current PATH environment variable
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

# Remove the gitBinPath from anywhere in the current PATH
$currentPath = $currentPath -replace [regex]::Escape($gitBinPath), ""

# Prepend the gitBinPath to the beginning of the PATH
$currentPath = "$gitBinPath;$currentPath"

# Ensure the gitCmdPath is in the PATH, if it's not already
if ($currentPath -notlike "*$gitCmdPath*") {
    $currentPath += ";$gitCmdPath"
}

# Update the PATH environment variable
[System.Environment]::SetEnvironmentVariable("Path", $currentPath, [System.EnvironmentVariableTarget]::Machine)

Write-Host "Git paths added to PATH successfully. Restart your terminal for changes to take effect."
