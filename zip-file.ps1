$directoryPath = "E:\valheimmodspack\valheimmods"
$fileName = "oc_valheim_mods_"

# Get all .zip files that match the pattern
$files = Get-ChildItem -Path $directoryPath -Filter "$fileName*.zip"

# Extract numbers and find the max
$maxNumber = $files |
    ForEach-Object {
        if ($_.BaseName -match "${fileName}(\d+)") { [int]$matches[1] }
    } |
    Sort-Object -Descending |
    Select-Object -First 1

# If no files were found, start at 1
if ($null -eq $maxNumber) { $maxNumber = 0 }

# Calculate next number
$nextNumber = $maxNumber + 1

# Generate new zip filename
$newZipfileName = "$fileName$nextNumber.zip"
$zipFilePath = "$directoryPath\$newZipfileName"

# Define specific files to add
$filesToInclude = @(
    "CHANGELOG.md",
    "icon.png",
    "manifest.json",
    "README.md"
)

# Build full file paths
$filesFullPath = $filesToInclude | ForEach-Object { Join-Path -Path $directoryPath -ChildPath $_ }

# Create the zip file
Compress-Archive -Path $filesFullPath -DestinationPath $zipFilePath -Force

Write-Output "Created zip file: $zipFilePath with selected files"
