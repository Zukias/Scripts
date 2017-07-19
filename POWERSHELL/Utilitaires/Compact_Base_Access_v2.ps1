# AIM : Compact les bases Access
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : 22/03/2017

param([switch] $backup)
 
if($backup)
{ 
    Write-Host "Sauvegarde des bases Access avant la compression...."
    & "\\CSS-DC1\sysvol\Aerauliq.dom\scripts\CSS\Backup_AccessDatabase.ps1"
}

# Backup databases before compactage
#& "\\CSS-DC1\sysvol\Aerauliq.dom\scripts\CSS\Backup_AccessDatabase.ps1"

$J="J:\ac"
#Copy Access to local
$baseReseau=@('arc.mdb','article.mdb','prepa.mdb','devis.mdb','client.mdb','plan.mdb','dp.mdb','clientaera.mdb','pr.mdb')

foreach ($b in $baseReseau)
{
    Copy-Item -Path "$J\$b" -Destination "C:\WorkingDir_Compactage\$b" -Force
}

# Compact base
$accessPath="C:\Program Files (x86)\Microsoft Office\Office10\MSACCESS.EXE"
$basePath="C:\WorkingDir_Compactage"
$basesDir=Get-ChildItem $basePath *.mdb

foreach ($base in $basesDir)
{
    $baseName=$base.name
    $fullPath="$basePath\$baseName"
    Start-Job -Name "Compact-$baseName" -ScriptBlock {& $args[1] $args[0] /compact} -ArgumentList $fullPath,$accessPath
    $Wait=Write-Host "Working.."
    Write-Host $Wait
    while ((Get-Job -Name "Compact-$baseName").State -eq "Running")
    {
        $Wait += "."
        Write-Host $Wait
        sleep 1
    }

    if ((Get-Job -Name "Compact-$baseName").State -eq "Completed")
    {
        Write-Host -ForegroundColor Green "Compact$baseName is completed"
        Remove-Job -Name "Compact$baseName" -ErrorAction Ignore
    }

}

#Copy Access to J:\ac
$compactedBase=@('arc.mdb','article.mdb','prepa.mdb','devis.mdb','client.mdb','plan.mdb','dp.mdb','clientaera.mdb','pr.mdb')

foreach ($b in $compactedBase)
{
    Copy-Item -Path "C:\WorkingDir_Compactage\$b" -Destination "$J\$b"
}

# Remove copied base in Working_Dir
Remove-Item -Path "C:\WorkingDir_Compactage\*"