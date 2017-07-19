# AIM : Envoi le rapport le plus récent généré avec Gen_HyperV_Report.ps1
# L'adresse email d'envoi est à préciser dans le script
# AUTHORS : AMADIEU Romain
# PARAMS : None
# MODIF : None

C:\scripts\Gen_HyperV_Report.ps1 -VMHost "SRV-REP" -ReportFilePath "C:\REPORTS\HYPERV\" -SendMail $true -SMTPServer "smtp.free.fr" -MailTo "romain.amadieu@acsas.fr" -MailFrom "SRV-REP@acsas.fr"