#################################################################

##Written by Kevin Roberts @ Sealing Technologies

## Updated by Kevin Weller @ Martin and Associates
## Updated to user MS Graph and Oauth 2.0

##Sends Email Updates to Administrators when an account locks
##Source Below: 
## https://www.sealingtech.com/2017/05/22/sending-automatic-email-notifications-when-an-active-directory-account-locks/

##Uses MS Graph Email Template From official MS documentation
##Source Below:
## https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.users.actions/send-mgusermail?view=graph-powershell-1.0

#################################################################

<#
DEPRECATED CODE

Declare variables to be used for the Email
$MailSubject= “Notice: User Account locked out”
$MailFrom=”DoNotReply@yourcompany.com”
$MailTo=”AdminsDL@yourcompany.com”

#Creates an SMTP Object and assigns an SMTP Address
$SmtpClient = New-Object system.net.mail.smtpClient
$SmtpClient.host = “yourSMTPRelay.yourcompany.com”

#Creates a new Mail Message Object. This is the object needed for the addressing email, subject, body, etc
$MailMessage = New-Object system.net.mail.mailmessage
$MailMessage.from = $MailFrom
$MailMessage.To.add($MailTo)
$MailMessage.IsBodyHtml = 0
$MailMessage.Subject = $MailSubject
$MailMessage.Body = $MailBody

#Actually Sends the Message
$SmtpClient.Send($MailMessage)

#>

#Modules
Import-Module Microsoft.Graph.Users.Actions
#Email Variables
$Subject = "Notice: User Account locked out"
$Body = "This is the Body"
$To = "email@email.com"
$CC = "email@email.com"
$SaveToSentItems = "True"
$UserId = "email@email.com"
#Gets the Event Log that contains the most recent lockout event
$Event = Get-EventLog -LogName Security -InstanceId 4740 -Newest 1
#Creates a variable which contains the contents of the lockout event log. This is used for the actual message in the email
$MailBody = $Event.Message + “`r`n`t” + $Event.TimeGenerated

Connect-MgGraph -Scopes "mail.send"
$params = @{
	message = @{
		subject = $Subject
		body = @{
			contentType = "Text"
			content = $MailBody
		}
		toRecipients = @(
			@{
				emailAddress = @{
					address = $To
				}
			}
		)
		ccRecipients = @(
			@{
				emailAddress = @{
					address = $CC
				}
			}
		)
	}
	saveToSentItems = $SaveToSentItems
}

# A UPN can also be used as -UserId.
Send-MgUserMail -UserId $UserId -BodyParameter $params


