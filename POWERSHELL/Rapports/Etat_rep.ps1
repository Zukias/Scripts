# AIM : Envoi un rapport sur l'état de serveur répliqué "Normal ou critique"
# L'adresse email d'envoi doit être précisé dans le script
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

function EmailNotification()
{
 #Sender email
 $Sender = "srvhpv@free.fr"

 #Receipt email
 $Receipt = "XXXX@acsas.fr"

 #SMTP Server
 $Server = "smtp.free.fr"

#Mail subject
 $Object = $env:computername+": Réplication Hyper-V du "+(Get-Date)

#Mail content
 #$Content = get-vm | where {$_.replicationstate -notmatch "Disabled"} | get-VMreplication | select replicationhealth |out-string
 $Content = Get-VMReplication  | select VMName,ReplicationHealth | Format-List | Out-String

 $SMTPclient = new-object System.Net.Mail.SmtpClient $Server

 #Specify SMTP port if needed
 #$SMTPClient.port = 587

 #Activate SSL if needed
 #$SMTPclient.EnableSsl = $true

 #Specify email account credentials if needed
 #$SMTPAuthUsername = "login"
 #$SMTPAuthPassword = "password"
 #$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($SMTPAuthUsername, $SMTPAuthPassword)

 $Message = new-object System.Net.Mail.MailMessage $Sender, $Receipt, $Object, $Content
 $Message.IsBodyHtml = $true;
 $SMTPclient.Send($Message)
}
EmailNotification
