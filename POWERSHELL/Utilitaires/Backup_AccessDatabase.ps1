# AIM : Sauvegarde des bases Access
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : 22/03/2017

# --------------------------------------------
#AIM : Fonction supprime les anciens dossiers de backup
#PARAMS : 
#  - $delay = Supprime tous les dossiers plus vieux de $delay jours
#  - $backupFolder = Chemin du dossier de backup
#RETURN : None

function DeleteOldBackup 
{
    param ([int] $delay, [string] $backupFolder)

$3Day=(get-date).AddDays($delay).Day
$foldersList=Get-ChildItem $backupFolder

foreach ($f in $foldersList)
{
    $fileDay=$f.CreationTime.Day

    if ($fileDay -lt $3Day)
    {
        Remove-Item -Recurse $f.FullName
    }
}
}

# --------------------------------------------
#AIM : Fonction backup les dossiers
#PARAMS : 
#  - $sourceFolder = Chemin du dossier source des bases à sauvegarder
#  - $destFolder = Chemin du dossier de backup
#RETURN : None
function BackupDatabases
{
    param( [string] $sourceFolder, [string] $destFolder)
    
    $date=get-date -UFormat %d-%m-%y
    $backupFolder="$destFolder\$date"
    $DBlist=Get-ChildItem $sourceFolder *.mdb

    if (Test-Path $destFolder)
    {
        foreach ($db in $DBlist)
        {
            mkdir -ErrorAction SilentlyContinue "$destFolder\$date"
            $backupBaseName="$backupFolder\$($db.baseName)-$date.mdb"
            Copy-Item -Path $db.FullName -Destination $backupBaseName
        }
    }
    else 
    {
        mkdir $destFolder
        mkdir -ErrorAction SilentlyContinue "$destFolder\$date"
        foreach ($db in $DBlist)
        {
            $backupBaseName="$backupFolder\$($db.baseName)-$date.mdb"
            Copy-Item -Path $db.FullName -Destination $backupBaseName
        }
    }

}

# --------------------------------------------
# Corps

# Si nous sommes Lundi on supprime tous les dossiers plus vieux de 3 jours (càd LUNDI, MARDI, MERCREDI, JEUDI)
if ((Get-Date).DayOfWeek -eq "Monday")
{
    DeleteOldBackup 4 "J:\ac\BackupAccess"
}

BackupDatabases "J:\ac\" "J:\ac\BackupAccess"