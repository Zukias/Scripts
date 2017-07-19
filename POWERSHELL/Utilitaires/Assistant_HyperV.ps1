# AIM : Assistant de création de machine virtuelle sur SRV-REP & SRV-HPV
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

function Create-VM-Windows () {
    # Variables
    $VM = Read-Host	"Nom de la VM : "
    [int64]$SRAM = 2GB
    $VMLOC = "D:\"
    $NetworkSwitch1 = "vSwitch"

    # Create VM Folder and Network Switch
    MD $VMLOC -ErrorAction SilentlyContinue
    $TestSwitch = Get-VMSwitch -Name $NetworkSwitch1 -ErrorAction SilentlyContinue; if ($TestSwitch.Count -EQ 0){New-VMSwitch -Name $NetworkSwitch1 -SwitchType External}

    # Copy Model VHD Disks
    MD "$VMLOC\$VM\Virtual Disks"
    MD "$VMLOC\$VM\Virtual Machines"
    Write-Host "Veuillez patientez, copie du disque dur en cours...."
    Copy-Item "\\SRV-REP\Templates\Win2012_R2_Up2Date\Win2012_R2_Up2Date.vhdx" "D:\$VM\Virtual Disks\C_$VM.vhdx"

    # Create Virtual Machines
    New-VM -Name $VM -Path $VMLOC -MemoryStartupBytes $SRAM -VHDPath "$VMLOC\$VM\Virtual Disks\C_$VM.vhdx" -SwitchName $NetworkSwitch1

    # Configure Virtual Machines
    Start-VM $VM
    Write-Host "Entrer pour fermer cette fenêtre"
}

function Create-VM-Ubuntu () {
    # Variables
    $VM = Read-Host	"Nom de la VM : "
    [int64]$SRAM = 512MB
    $VMLOC = "D:\"
    $NetworkSwitch1 = "vSwitch"

    # Create VM Folder and Network Switch
    MD $VMLOC -ErrorAction SilentlyContinue
    $TestSwitch = Get-VMSwitch -Name $NetworkSwitch1 -ErrorAction SilentlyContinue; if ($TestSwitch.Count -EQ 0){New-VMSwitch -Name $NetworkSwitch1 -SwitchType External}

    # Copy Model VHD Disks
    MD "$VMLOC\$VM\Virtual Disks"
    MD "$VMLOC\$VM\Virtual Machines"
    Write-Host "Veuillez patientez, copie du disque dur en cours...."
    Copy-Item "\\SRV-REP\Templates\Ubuntu 16.04\Template_Ubuntu-16.04.vhdx" "D:\$VM\Virtual Disks\SDA_$VM.vhdx"

    # Create Virtual Machines
    New-VM -Name $VM -Path $VMLOC -MemoryStartupBytes $SRAM -VHDPath "$VMLOC\$VM\Virtual Disks\C_$VM.vhdx" -SwitchName $NetworkSwitch1

    # Configure Virtual Machines
    Start-VM $VM
    Write-Host "Entrer pour fermer cette fenêtre"
}

function Delete-VM () {
    Write-Host "VM Disponible"
    Write-Host "-------------"
    Get-VM  | select name
    Write-Host `n
    $VM = Read-Host "Nom de la VM : "

    # Delete VM & Folders
    Write-Host "Arrêt de la VM"
    Stop-VM -name $VM -Force
    Write-Host "Suppression de la VM $VM ..."
    Remove-VM -name $VM -Force
    Remove-VM -name $VM -Force
    Write-Host "Supression des dossiers..."
    Remove-Item "D:\$VM" -Recurse
}

function Show-Menu {
    param (
    [String]$Title = 'Assistant de création/supression de VM'
    )
    cls
    Write-Host "=================== $Title ================="

    Write-Host "1: Créer une VM Windows Server 2012 R2"
    Write-Host "2: Créer une VM Ubuntu 16.04"
    Write-Host "3: Supprimer une VM"
    Write-Host "q : Quitter"
}

do
{
     Show-Menu
     $input = Read-Host "Que souhaitez vous faire ?"
     switch ($input)
     {
           '1' {
                cls
                Create-VM-Windows
           } '2' {
                cls
                Create-VM-Ubuntu
           }
            '3' {
                cls
                Delete-VM
           } 'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')
