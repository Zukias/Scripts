$Scope="OU=Chevigny Saint Sauveur,OU=Aeraulique Construction,DC=Aerauliq,DC=dom"
$Users=Get-ADUser -SearchBase $Scope -Filter *

foreach ($u in $Users)
{
    Get-ADUser $u.SamAccountName | Set-ADUser -Clear scriptPath
}