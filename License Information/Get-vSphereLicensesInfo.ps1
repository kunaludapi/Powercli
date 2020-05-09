#requires -version 4
<#
.SYNOPSIS
    Get complete license information from vCenter Server
.DESCRIPTION
    The Get-vSphereLicensesInfo.ps1 gets license information from vCenter Server. License information ie: vCenter, Esxi, vSAN etc.
.PARAMETER File
    Prompts you for csv file location.
    
.INPUTS
    VMware.Vim.LicenseManager
    VMware.Vim.LicenseManagerLicenseInfo
.OUTPUTS
    VMware.Vim.LicenseManagerLicenseInfo
.NOTES
  Version:        1.0
  Author:         Kunal Udapi
  Creation Date:  09 May 2020
  Purpose/Change: Gather vCenter Esxi licenses information
  Useful URLs: http://vcloud-lab.com
  Tested on below versions:
    vCenter/Esxi: 7.0
    PowerCLI: 12.0
    PowerShell: 5.1
.EXAMPLE
    Name           : Product Evaluation
    LicenseKey     : 00000-00000-00000-00000-00000
    ExpirationDate : Evaluation
    ProductName    : VMware vSphere 7 Enterprise Plus with Add-on for Kubernetes
    ProductVersion : Evaluation
    EditionKey     : eval
    Total          : Unlimited
    Used           : 2
    CostUnit       : esx.enterprisePlus.cpuPackage
    Labels         : 
    vCenter        : vcsa.vcloud-lab.com

    This script shows information as above information.
#>

<#
Remove-Module Hyper-V
Import-Module VMware.PowerCLI
Connect-VIserver -Server 192.168.34.20 -User administrator@vsphere.local -Password passward
Connect-VIserver -Server marvel.vcloud-lab.com -User administrator@vsphere.local -Password passward
#>

foreach ($licenseManager in (Get-View LicenseManager)) #-Server $vCenter.Name
{
    $vCenterName = ([System.uri]$licenseManager.Client.ServiceUrl).Host
    #($licenseManager.Client.ServiceUrl -split '/')[2]
    foreach ($license in $licenseManager.Licenses)
    {
        $licenseProp = $license.Properties
        $licenseExpiryInfo = $licenseProp | Where-Object {$_.Key -eq 'expirationDate'} | Select-Object -ExpandProperty Value
        if ($license.Name -eq 'Product Evaluation')
        {
            $expirationDate = 'Evaluation'
        } #if ($license.Name -eq 'Product Evaluation')
        elseif ($null -eq $licenseExpiryInfo)
        {
            $expirationDate = 'Never'
        } #elseif ($null -eq $licenseExpiryInfo)
        else
        {
            $expirationDate = $licenseExpiryInfo
        } #else #if ($license.Name -eq 'Product Evaluation')
    
        if ($license.Total -eq 0)
        {
            $totalLicenses = 'Unlimited'
        } #if ($license.Total -eq 0)
        else 
        {
            $totalLicenses = $license.Total
        } #else #if ($license.Total -eq 0)
    
        $licenseObj = New-Object psobject
        $licenseObj | Add-Member -Name Name -MemberType NoteProperty -Value $license.Name
        $licenseObj | Add-Member -Name LicenseKey -MemberType NoteProperty -Value $license.LicenseKey
        $licenseObj | Add-Member -Name ExpirationDate -MemberType NoteProperty -Value $expirationDate
        $licenseObj | Add-Member -Name ProductName -MemberType NoteProperty -Value ($licenseProp | Where-Object {$_.Key -eq 'ProductName'} | Select-Object -ExpandProperty Value)
        $licenseObj | Add-Member -Name ProductVersion -MemberType NoteProperty -Value ($licenseProp | Where-Object {$_.Key -eq 'ProductVersion'} | Select-Object -ExpandProperty Value)
        $licenseObj | Add-Member -Name EditionKey -MemberType NoteProperty -Value $license.EditionKey
        $licenseObj | Add-Member -Name Total -MemberType NoteProperty -Value $totalLicenses
        $licenseObj | Add-Member -Name Used -MemberType NoteProperty -Value $license.Used
        $licenseObj | Add-Member -Name CostUnit -MemberType NoteProperty -Value $license.CostUnit
        $licenseObj | Add-Member -Name Labels -MemberType NoteProperty -Value $license.Labels
        $licenseObj | Add-Member -Name vCenter -MemberType NoteProperty -Value $vCenterName
        $licenseObj
    } #foreach ($license in $licenseManager.Licenses)
} #foreach ($licenseManager in (Get-View LicenseManager)) #-Server $vCenter.Name
