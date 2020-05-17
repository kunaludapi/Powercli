#requires -version 4
<#
.SYNOPSIS
    Get complete license usage information from vCenter Server
.DESCRIPTION
    The Get-vSphereAssignedLicensesInfo.ps1 gets license usage information from vCenter Server. License information ie: vCenter, Esxi, vSAN etc. This information helps if any of there instance is not assigned with Evaluation license.
.PARAMETER File
    Use Export-Csv using pipeline to export data to csv file.
.INPUTS
    VMware.Vim.LicenseManager
    VMware.Vim.LicenseManagerLicenseInfo
.OUTPUTS
    VMware.Vim.LicenseManagerLicenseInfo
.NOTES
  Version:        1.0
  Author:         Kunal Udapi
  Creation Date:  16 May 2020
  Purpose/Change: Gather vCenter Esxi licenses usage information
  Useful URLs: http://vcloud-lab.com
  Tested on below versions:
    vCenter/Esxi: 7.0
    PowerCLI: 12.0
    PowerShell: 5.1
.EXAMPLE
    EntityDisplayName : Stark_Industries
    Name              : VMware vSAN Evaluation Mode
    LicenseKey        : 00000-00000-00000-00000-00000
    EditionKey        : vsan.eval
    ProductName       : VMware VSAN
    ProductVersion    : 7.0
    EntityId          : domain-c1006
    Scope             : db02fe7d-276e-4d4e-812d-a06c058a0a4c

    This script shows information as above information.
#>

<#
Remove-Module Hyper-V
Import-Module VMware.PowerCLI
Connect-VIserver -Server 192.168.34.20 -User administrator@vsphere.local -Password Computer@1
Connect-VIserver -Server marvel.vcloud-lab.com -User administrator@vsphere.local -Password Computer@1
#>

$licenseManager = Get-View $Global:DefaultVIServers.ExtensionData.content.LicenseManager
$licenseAssignmentManager = Get-View $LicenseManager.licenseAssignmentManager
$assignedLicenses = $licenseAssignmentManager.QueryAssignedLicenses($gloabl.defaultviservers.instanceuuid) | Group-Object -Property EntityId, EntityDisplayName, Scope
$licenseUsage = @()
foreach ($license in $assignedLicenses)
{
    $lic = $license.Group[0] #| select EntityDisplayName, EntityId, Scope
    #$assignedLicenses[0].Group[0].AssignedLicense
    $licenseObj = [PSCustomObject]@{
        EntityDisplayName = $lic.EntityDisplayName
        Name = $lic.AssignedLicense.Name
        LicenseKey = $lic.AssignedLicense.LicenseKey
        EditionKey = $lic.AssignedLicense.EditionKey
        ProductName = $lic.AssignedLicense.Properties | Where-Object {$_.Key -eq 'ProductName'} | Select-Object -ExpandProperty Value
        ProductVersion = $lic.AssignedLicense.Properties | Where-Object {$_.Key -eq 'ProductVersion'} | Select-Object -ExpandProperty Value
        EntityId = $lic.EntityId
        Scope = $lic.Scope
    }
    $licenseObj
    $licenseUsage += $licenseObj
}