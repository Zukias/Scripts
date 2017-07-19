# AIM : Ferme les fenêtres des programmes VB
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

$programms=@('prepa16','prepa2015smitka','dp','prepa2010c','acad','telport','plan','arc')
foreach ($proc in $programms)
{
    $id=(Get-Process $proc).CloseMainWindow()
    #Stop-Process $id
}
