#Rest API Guide
#External
#"https://$logInsightServer/rest-api#Getting-started-with-the-Log-Insight-REST-API"
#Internal
#"https://$logInsightServer/internal/rest-api"
#Online
#https://vmw-loginsight.github.io/#Getting-started-with-the-Log-Insight-REST-API

function Approve-SelfSignedCertificate
{
#if you are using SelfSigned certificate use this function to allow.
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

function Login-LogInsightAPI
{
    #requires -version 4
    <#
    .SYNOPSIS
        Log In to Log Insight Server Rest API
    .DESCRIPTION
        The Login-LogInsightAPI function login into vRealize Log insight and provide session details bearer token)for authorization. You need to run login script once, and keep using the existing session in another function cmdlet.
    .PARAMETER Server
        FQDN or IP of vRealize Log Insight server.
    .PARAMETER Username
        Username to login vRealize Log Insight server FQDN or IP.
    .PARAMETER Password
        Password to login vRealize Log Insight server FQDN or IP.
    .PARAMETER RestAPI
        This is Rest API string for vRealize Log Insight, The string after https://loginsightserver:9543/api/v1. Check more information on #"https://$logInsightServer/rest-api#Getting-started-with-the-Log-Insight-REST-API"
    .INPUTS
        string
    .OUTPUTS
        Microsoft.PowerShell.Commands.HtmlWebResponseObject
    .NOTES
    Version:        1.0
    Author:         Kunal Udapi
    Creation Date:  19 July 2020
    Purpose/Change: Login to vRealize Log Insight Rest API using PowerShell
    Useful URLs: http://vcloud-lab.com
    Tested on below versions:
        VMware vRealize Log Insight: 8.0
        Microsoft PowerShell: 5.1
        Operating System: Microsoft Windows 10
    .EXAMPLE
        Login-LogInsight -Server loginsightserver -Username admin -Password P@ssw0rd -RestAPI sessions

        StatusCode        : 200
        StatusDescription : OK
        Content           : {"userId":"ff0205c6-3875-4710-80cc-15100272a8db","sessionId":"EL2TC24NWRgibmzCwI4I1+MYEsP4YwiTlQ0OsDbbdBO/fT/gHMWD5q4Lm7M1BVpWEEZjVLLmI6YLbDyQZg4mWBkm+JPjZASo1y4FB1aotbpnN7bhfmIan8uVEyDBLqOPQOwUxRN0tV...
        RawContent        : HTTP/1.1 200 OK
                            ACCESS-CONTROL-EXPOSE-HEADERS: X-LI-Build
                            X-LI-Build: 16281169
                            Content-Length: 355
                            Content-Type: application/json; charset=utf-8
                            Date: Sun, 19 Jul 2020 05:31:45 GMT

                            {"userId":"...
        Forms             : {}
        Headers           : {[ACCESS-CONTROL-EXPOSE-HEADERS, X-LI-Build], [X-LI-Build, 16281169], [Content-Length, 355], [Content-Type, application/json; charset=utf-8]...}
        Images            : {}
        InputFields       : {}
        Links             : {}
        ParsedHtml        : mshtml.HTMLDocumentClass
        RawContentLength  : 355

        This script shows information as above information.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'Type LogInsight FQDN/IP')]
        [string]$Server = 'LogInsight.vcloud-lab.com',
        [Parameter(Mandatory = $true, HelpMessage = 'Type UserName')]
        [string]$Username = 'admin',
        [Parameter(Mandatory = $true, HelpMessage = 'Type Password')]
        [string]$Password = 'P@ssw0rd',
        [Parameter(Mandatory = $true, HelpMessage = 'Type Rest API node')]
        [string]$RestAPI = 'sessions' #Type string after the /api/v1/
    )
    begin
    {
        Approve-SelfSignedCertificate
    }
    process 
    {
        #login Example using cURL
        #curl -k -X POST https://192.168.34.15:9543/api/v1/sessions -d '{"username":"admin","password":"p@ssw0rd","provider":"Local"}' --noproxy '*'
        $uri = "https://$($Server):9543/api/v1/$RestAPI" #$RestAPI is string after /api/v1/
        $body = @{"username"=$Username;"password"=$Password;"provider"="Local"}
        try 
        {
            $session = Invoke-WebRequest -Uri $uri -Method POST -Body $($body | ConvertTo-Json) -ContentType 'application/json' -ErrorAction Stop
            $session
            Write-Host 'Login into Rest API successful' -BackgroundColor DarkGreen
        }
        catch 
        {
            Write-Host $error[0].Exception.Message -BackgroundColor DarkRed
        }
    }
    end {}
}

function Get-LogInsightAPI
{
    #requires -version 4
    <#
    .SYNOPSIS
        Get information from Log Insight Server Rest API using verb Get.
    .DESCRIPTION
        The Get-LogInsightAPI function login into vRealize Log insight and gets the information requested.
    .PARAMETER Server
        FQDN or IP of vRealize Log Insight server.
    .PARAMETER Session
        To get this information you will need to run Login-LogInsightAPI. You feed Microsoft.PowerShell.Commands.HtmlWebResponseObject information here.
    .PARAMETER RestAPI
        This is Rest API string for vRealize Log Insight, The string after https://loginsightserver:9543/api/v1. Check more information on #"https://$logInsightServer/rest-api#Getting-started-with-the-Log-Insight-REST-API"
    .INPUTS
        string
        Microsoft.PowerShell.Commands.HtmlWebResponseObject
    .OUTPUTS
        Microsoft.PowerShell.Commands.HtmlWebResponseObject
    .NOTES
    Version:        1.0
    Author:         Kunal Udapi
    Creation Date:  19 July 2020
    Purpose/Change: Get the configuration/Information from vRealize Log Insight Rest API using PowerShell
    Useful URLs: http://vcloud-lab.com
    Tested on below versions:
        VMware vRealize Log Insight: 8.0
        Microsoft PowerShell: 5.1
        Operating System: Microsoft Windows 10
    .EXAMPLE
        $session = Login-LogInsight -Server loginsightserver -Username admin -Password P@ssw0rd -RestAPI sessions
        Get-LogInsightAPI -Server loginsightserver -Session $session -RestAPI 'time/config'

        Content           : {}
        StatusCode        : 200
        StatusDescription : OK
        RawContentStream  : Microsoft.PowerShell.Commands.WebResponseContentMemoryStream
        RawContentLength  : 0
        RawContent        : HTTP/1.1 200 OK
                            X-LI-Build: 16281169
                            ACCESS-CONTROL-EXPOSE-HEADERS: X-LI-Build
                            Content-Length: 0
                            Date: Sun, 19 Jul 2020 05:44:37 GMT


        BaseResponse      : System.Net.HttpWebResponse
        Headers           : {[X-LI-Build, 16281169], [ACCESS-CONTROL-EXPOSE-HEADERS, X-LI-Build], [Content-Length, 0], [Date, Sun, 19 Jul 2020 05:44:37 GMT]}

        Run the Login-LogInsight script and use the information as Session parameter, This function script shows information for NTP Server configuration.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'Type LogInsight FQDN/IP')]
        [string]$Server = 'LogInsight.vcloud-lab.com',        
        [Parameter(Mandatory = $true, HelpMessage = 'Type LogInsight FQDN/IP')]
        [Microsoft.PowerShell.Commands.HtmlWebResponseObject]$Session,
        [Parameter(Mandatory = $true, HelpMessage = 'Type Rest API node')]
        [string]$RestAPI = 'licenses' #Type string after the /api/v1/
    )
    begin
    {
        Approve-SelfSignedCertificate
    }
    process 
    {
        try 
        {
            $sessionID = $Session.Content | ConvertFrom-Json | Select-Object -ExpandProperty sessionId
            $headers = @{'Authorization' = "Bearer $sessionID"}
            $getInfo = Invoke-WebRequest -Uri "https://$($server):9543/api/v1/$RestAPI" -Method Get -Headers $headers -ContentType 'application/json' -ErrorAction Stop
            $getInfo
            Write-Host "Getting $RestAPI Information" -BackgroundColor DarkGreen
        }
        catch 
        {
            Write-Host $error[0].Exception.Message -BackgroundColor DarkRed
        }

    }
    end {}
}

function Put-LogInsightAPI
{
    #requires -version 4
    <#
    .SYNOPSIS
        Modify information on the Log Insight Server Rest API using verb Put.
    .DESCRIPTION
        The Put-LogInsightAPI function login into vRealize Log insight and gets the information requested.
    .PARAMETER Server
        FQDN or IP of vRealize Log Insight server.
    .PARAMETER Session
        To get this information you will need to run Login-LogInsightAPI. It requires Microsoft.PowerShell.Commands.HtmlWebResponseObject .net object information.
    .PARAMETER Body
        In this parameter you need to provide information in Hashtable form, this information you can get from https://vmw-loginsight.github.io/#Getting-started-with-the-Log-Insight-REST-API.
    .PARAMETER RestAPI
        This is Rest API string for vRealize Log Insight, The string after https://loginsightserver:9543/api/v1. Check more information on #"https://$logInsightServer/rest-api#Getting-started-with-the-Log-Insight-REST-API"
    .INPUTS
        string
        System.Collections.Hashtable
        Microsoft.PowerShell.Commands.HtmlWebResponseObject
    .OUTPUTS
        Microsoft.PowerShell.Commands.HtmlWebResponseObject
    .NOTES
    Version:        1.0
    Author:         Kunal Udapi
    Creation Date:  19 July 2020
    Purpose/Change: Change (put) the configuration/Information on vRealize Log Insight Rest API using PowerShell
    Useful URLs: http://vcloud-lab.com
    Tested on below versions:
        VMware vRealize Log Insight: 8.0
        Microsoft PowerShell: 5.1
        Operating System: Microsoft Windows 10
    .EXAMPLE
        $session = Login-LogInsight -Server loginsightserver -Username admin -Password P@ssw0rd -RestAPI sessions
        $body = @{timeReference="NTP_SERVER"; ntpServers=@('172.30.10.5', '172.30.10.6')}
        Put-LogInsightAPI -Server loginsightserver -Session $session -RestAPI 'time/config' -Body $body

        Name                           Value
        ----                           -----
        ntpServers                     {172.30.10.5, 172.30.10.6}
        timeReference                  NTP_SERVER

        Content           : {}
        StatusCode        : 200
        StatusDescription : OK
        RawContentStream  : Microsoft.PowerShell.Commands.WebResponseContentMemoryStream
        RawContentLength  : 0
        RawContent        : HTTP/1.1 200 OK
                            X-LI-Build: 16281169
                            ACCESS-CONTROL-EXPOSE-HEADERS: X-LI-Build
                            Content-Length: 0
                            Date: Sun, 19 Jul 2020 07:57:10 GMT


        BaseResponse      : System.Net.HttpWebResponse
        Headers           : {[X-LI-Build, 16281169], [ACCESS-CONTROL-EXPOSE-HEADERS, X-LI-Build], [Content-Length, 0], [Date, Sun, 19 Jul 2020 07:57:10 GMT]}

        Use Login-LogInsight script and use the information as Session parameter, This function script use PUT verb to configure NTP Servers on vRLI.
    #>    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'Type LogInsight FQDN/IP')]
        [string]$Server = 'LogInsight.vcloud-lab.com',
        [Parameter(Mandatory = $true, HelpMessage = 'Type LogInsight FQDN/IP')]
        [Microsoft.PowerShell.Commands.HtmlWebResponseObject]$Session,
        [Parameter(Mandatory = $true, HelpMessage = 'Type LogInsight FQDN/IP')]
        [System.Collections.Hashtable]$Body = @{timeReference="NTP_SERVER"; ntpServers=@('172.30.10.1', '172.30.10.2')},
        [Parameter(Mandatory = $true, HelpMessage = 'Type Rest API node')]
        [string]$RestAPI = 'licenses' #Type string after the /api/v1/
    )
    begin
    {
        Approve-SelfSignedCertificate
    }
    process 
    {
        try 
        {
            $Body
            $sessionID = $Session.Content | ConvertFrom-Json | Select-Object -ExpandProperty sessionId
            $headers = @{'Authorization' = "Bearer $sessionID"}
            $putInfo = Invoke-WebRequest -Uri "https://$($server):9543/api/v1/$RestAPI" -Method Put -Headers $headers -ContentType 'application/json' -Body $($Body | ConvertTo-Json) -ErrorAction Stop
            $putInfo
            Write-Host "Configured $RestAPI" -BackgroundColor DarkGreen
        }
        catch 
        {
            Write-Host $error[0].Exception.Message -BackgroundColor DarkRed
        }

    }
    end {}
}

<#
##Examples##
#Details about vRealize Log Insight Server
$server = '192.168.34.15'

#Login into vRealize Log Insight Server using Rest API
$session = Login-LogInsightAPI -Server $server -Username admin -Password Computer@1 -RestAPI sessions

#Use Get verb to get NTP Server settings from vRealize Log Insight Server Configuration
$logInsightNtpServer = Get-LogInsightAPI -Server $server -Session $session -RestAPI 'time/config'
$logInsightNtpServer.Content | ConvertFrom-Json | Select-Object -ExpandProperty ntpConfig

#Use Post verb to change settings on vRealize Log Insight Server using Rest API
$body = @{timeReference="NTP_SERVER"; ntpServers=@('172.30.0.1', '172.30.0.1')}
$logInsightNtpServer = Put-LogInsightAPI -Server $server -Session $session -RestAPI 'time/config' -Body $body
$logInsightNtpServer[0]  

#Rerun/Verify Get verb to get NTP Server settings from vRealize Log Insight Server Configuration
$logInsightNtpServer = Get-LogInsightAPI -Server $server -Session $session -RestAPI 'time/config'
$logInsightNtpServer.Content | ConvertFrom-Json | Select-Object -ExpandProperty ntpConfig
#>

Export-ModuleMember -Function *