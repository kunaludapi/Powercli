# C# code class type for ignore self signed certificate
if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type) 
{
    $certCallback = @'
        using System;
        using System.Net;
        using System.Net.Security;
        using System.Security.Cryptography.X509Certificates;
        public class ServerCertificateValidationCallback
        {
            public static void Ignore()
            {
                if (ServicePointManager.ServerCertificateValidationCallback == null)
                {
                    ServicePointManager.ServerCertificateValidationCallback +=
                    delegate 
                    (
                        Object Obj,
                        X509Certificate certificate,
                        X509Chain chain,
                        SslPolicyErrors errors
                    )
                    {
                        return true;
                    };
                }
            }
        }
'@
    Add-Type $certCallback
}

#execute c# code and ignore invalid certificate error
[ServerCertificateValidationCallback]::Ignore();

#Type credential and process to base 64
$credential = Get-Credential
$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($credential.UserName+':'+$credential.GetNetworkCredential().Password))
$head = @{
    Authorization = "Basic $auth"
}

$vCenter = 'vcsa.vcloud-lab.com'
#Authenticate against vCenter
$a = Invoke-WebRequest -Uri "https://$vCenter/rest/com/vmware/cis/session" -Method Post -Headers $head
$token = ConvertFrom-Json $a.Content | Select-Object -ExpandProperty Value
$session = @{'vmware-api-session-id' = $token}

#Get vm list from vcenter
$a1 = Invoke-WebRequest -Uri "https://$vCenter/rest/vcenter/vm" -Method Get -Headers $session
$vms = ConvertFrom-Json $a1.Content | Select-Object -ExpandProperty Value
$vms

#Get single VM list
    $vmMof = 'vm-900'
    $b1 = Invoke-WebRequest -Uri "https://$vCenter/rest/vcenter/vm/$vmMof" -Method Get -Headers $session
    $test = ConvertFrom-Json $b1.Content | Select-Object -ExpandProperty Value
    $test