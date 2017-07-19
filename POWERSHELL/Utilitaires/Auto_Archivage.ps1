# AIM : Archivage autatique
# Trie les fichiers présents dans un dossier par année et les ranges dans des dossiers par année
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

# Test if there is a target directory
$folder=read-host "Dossier à archiver ? (chemin absolue) : "
while (!$folder)
{
    Write-Host "Préciser un dossier"
    $folder=read-host "Dossier à archiver ? (chemin absolue) : "
}

$folderContent=Get-ChildItem -File $folder
$currentYear=(get-date).Year
$date=(get-date)

# Create folder and move file
foreach ($f in $folderContent)
{
    $year=$f.LastWriteTime.Year

    $yearFolder="$folder\$year"

    New-Item -ErrorAction Ignore -ItemType directory -Path $yearFolder
    Move-Item -path $folder\$f -Destination $yearFolder
}

New-Item -ErrorAction Ignore -ItemType directory -Path "$folder\Archivage"

# Create .zip of old folder
$folderList=Get-ChildItem -Directory $folder
$archiveFolder="$folder\Archivage"
foreach ($fo in $folderList)
{
    $fullName=$fo.FullName
    if ($fo.Name -lt $currentYear)
    {
      $now=Get-Date -UFormat %d-%m-%y
      Add-Type -assembly "system.io.compression.filesystem"
      $destination = Join-path -path $archiveFolder -ChildPath "$($fo.name).zip"
      If(Test-path $destination) {$destination = Join-path -path $archiveFolder -ChildPath "$($fo.name)($now).zip"}
      $destination
      [io.compression.zipfile]::CreateFromDirectory($fo.FullName, $destination)
      Remove-Item $fo.FullName -Recurse
    }
}
