#https://vdc-repo.vmware.com/vmwb-repository/dcr-public/1cd28284-3b72-4885-9e31-d1c6d9e26686/71ef7304-a6c9-43b3-a3cd-868b2c236c81/doc/operations/com/vmware/cis/tagging/tag.list_used_tags-operation.html

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
$credential = Get-Credential -Message 'Type vCenter Password' -UserName 'administrator@vsphere.local' 
$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($credential.UserName+':'+$credential.GetNetworkCredential().Password))
$head = @{
    Authorization = "Basic $auth"
}

$vCenter = 'marvel.vcloud-lab.com'
#Authenticate against vCenter
$a = Invoke-WebRequest -Uri "https://$vCenter/rest/com/vmware/cis/session" -Method Post -Headers $head
$token = ConvertFrom-Json $a.Content | Select-Object -ExpandProperty Value
$session = @{'vmware-api-session-id' = $token}

#Get vm list from vcenter
$a01 = Invoke-WebRequest -Uri "https://$vCenter/rest/vcenter/vm" -Method Get -Headers $session
$vms = ConvertFrom-Json $a01.Content | Select-Object -ExpandProperty Value
$vms

#Get Single VM
$a11 = Invoke-WebRequest -Uri "https://$vCenter/rest/vcenter/vm/$($vms.vm)" -Method Get -Headers $session
$vms = ConvertFrom-Json $a11.Content | Select-Object -ExpandProperty Value
$vms


#Get list of tags
$b1 = Invoke-WebRequest -Uri "https://$vCenter/rest/com/vmware/cis/tagging/tag" -Method get -Headers $session
$passTag = ConvertFrom-Json $b1.Content | Select-Object -ExpandProperty Value
$passTag

#getting list of asigned objects to tag
$url = "https://$vCenter/rest/com/vmware/cis/tagging/tag-association?~action=list-attached-objects-on-tags"
$tagID = $passTag #-replace ':', '%3A'
    
$bodyTagJSON = "{
    ""tag_ids"": [
    ""$tagID""
    ]
}"


$url = "https://$vCenter/rest/com/vmware/cis/tagging/tag-association?~action=list-attached-objects-on-tags"
$c1 = Invoke-WebRequest -Uri $url -Method POST -Headers $session -Body $bodyTagJSON -ContentType "application/json" #-SkipCertificateCheck
$esxiTags = ConvertFrom-Json $c1.Content | Select-Object -ExpandProperty Value
$esxiTags
$esxiTags.object_ids.id

#Get ESXi host list from vcenter
$d1 = Invoke-WebRequest -Uri "https://$vCenter/rest/vcenter/host" -Method Get -Headers $session
$esxiList = ConvertFrom-Json $d1.Content | Select-Object -ExpandProperty Value
$esxiList

<#
#Get single ESXi host from vcenter
$e1 = Invoke-WebRequest -Uri "https://$vCenter/rest/vcenter/host/$($test.object_ids.id)" -Method Get -Headers $session
$esxi = ConvertFrom-Json $e1.Content | Select-Object -ExpandProperty Value
$esxi
#>
