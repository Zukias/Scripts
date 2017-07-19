# AIM : Envoi une alerte à chaque fois qu'un utilisé est crée
# Le script doit être lié à l'évenement n° 4720 dans l'observateur d'évenement
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

 $event = get-eventlog -LogName Security -InstanceId 4720 -newest 1
#get-help get-eventlog will show there are a handful of other options available for selecting the log entry you want.
if ($event.EntryType -eq "SuccessAudit")
{
    $PCName = $env:COMPUTERNAME
    $EmailBody = $event.Message
    $EmailFrom = "Your Return Email Address <$PCName@acsas.fr>"
    $EmailTo = "romain.amadieu@acsas.fr" 
    $EmailSubject = "User was created!"
    $SMTPServer = "smtp.free.fr"
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -body $EmailBody -SmtpServer $SMTPServer -Encoding  UTF8
}