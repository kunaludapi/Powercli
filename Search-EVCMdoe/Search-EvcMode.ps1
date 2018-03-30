<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
#requires -version 4
<#
.SYNOPSIS
    This GUI script shows detects EVC mode of cluster.
.DESCRIPTION
    The Search-EVCMode cmdlet detects and shows what EVC (Enhanced vMotion comapatibility) mode need to set on VMware Vsphere cluster.
.INPUTS
    None
.OUTPUTS
    [VMware]
.NOTES
    Script Version:        1.0
    Author:                Kunal Udapi
    Creation Date:         20 March 2018
    Purpose/Change:        Get windows office and OS licensing information.
    Useful URLs:           http://kunaludapi.blogspot.in/
                           http://vcloud-lab.com/
    OS Version:            Windows 10
    Powershell Version:    Powershell V5.1 
    PowerCLI Version:      6.5
    VMware Vsphere:        6.5
.EXAMPLE
    PS C:\>.\Search-EVCMode.ps1

    This connects to vCenter, list clusters and and shows what EVC mode should be for selected vmware cluster, You can also disconnect cluster.
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$PSScriptRoot = Split-Path $MyInvocation.MyCommand.Definition -Parent
$CPUJpg = Get-Item "$PSScriptRoot\images\CPU.jpg"
$CPU = [System.Drawing.Image]::Fromfile($CPUJpg)
$IntelJpg = Get-Item "$PSScriptRoot\images\Intel.jpg"
$Intel = [System.Drawing.Image]::Fromfile($IntelJpg)
$AMDJpg = Get-Item "$PSScriptRoot\images\AMD.jpg"
$AMD = [System.Drawing.Image]::Fromfile($AMDJpg)

#region begin Functions{
    function Show-MessageBox { 
        param (  
            [string]$Message = "Show user friendly Text Message", 
            [string]$Title = 'Title here', 
            [ValidateRange(0,5)]  
            [Int]$Button = 0, 
            [ValidateSet('None','Hand','Error','Stop','Question','Exclamation','Warning','Asterisk','Information')] 
            [string]$Icon = 'Error' 
        ) 
        #Note: $Button is equl to [System.Enum]::GetNames([System.Windows.Forms.MessageBoxButtons]) 
        #Note: $Icon is equl to [System.Enum]::GetNames([System.Windows.Forms.MessageBoxIcon]) 
        $MessageIcon  = [System.Windows.Forms.MessageBoxIcon]::$Icon 
        [System.Windows.Forms.MessageBox]::Show($Message,$Title,$Button,$MessageIcon) 
    } 

Function Confirm-Powercli {
    $AllModules = Get-Module -ListAvailable VMware.VimAutomation.Core
    if (!$AllModules) {
        Show-MessageBox -Message "Install VMware Powercli 6.0 or Latest. `n`nUse either 'Install-Module VMware.VimAutomation.Core' `nor download Powercli from 'http://my.vmware.com'" -Title 'VMware Powercli Missing error' | Out-Null
    }
    else {
        Import-Module VMware.VimAutomation.Core
        $PowercliVer = Get-Module VMware.VimAutomation.Core
        $ReqVersion = New-Object System.Version('6.0.0.0')
        if ($PowercliVer.Version -gt $ReqVersion) {
            'Ok'
        }
        else {
            Show-MessageBox -Message "Install VMware Powercli 6.0 or Latest. `n`nUse either 'Install-Module VMware.VimAutomation.Core' `nor download Powercli from 'http://my.vmware.com'" -Title 'Lower version Powercli' | Out-Null
        }
    }
}

Function Connect-vCenter {
    param (
        [string]$vCenterServer = $vCenterTextBox.Text
    )
    Confirm-Powercli
    Disconnect-vCenter
    if (($vCenterTextBox.Text -eq $vCenterTextBoxWaterMark) -or ($vCenterTextBox.Text -eq '')) { 
        #[System.Windows.Forms.MessageBox]::Show("Please type valid Domain\Account", "Textbox empty")
        Show-MessageBox -Message "Please type valid vCenter server name" -Title 'vCenter Server Name' | Out-Null
    } 
    else { 
        try {
            Connect-VIServer $vCenterServer -Credential (Get-Credential) -ErrorAction Stop | Out-Null
            $VCConnected.text= "Connected to $($Global:DefaultVIServer.Name), Below EVC modes are supported"
            Get-EvcInfo
            $ClusterListComboBox.text = Get-ClusterNames
        }
        catch {
            Show-FormOnTop
            Show-MessageBox -Message $error[0].Exception.Message -Title 'Error Connecting vCenter' | Out-Null
        }
    }
    Show-FormOnTop 
}

function Disconnect-vCenter {
    try {
        Disconnect-VIServer * -Confirm:$false -ErrorAction Stop
        $VCConnected.text = 'Not connected to any vCenter Server'
        $EvcDataGridView.DataSource = $null
        $ClusterListComboBox.Items.Clear()
        $ClusterListComboBox.Text = "Select Cluster name from list"
        $EVCMode.text  = $null
        $ResultLabel.text = $null
        $PictureBox1.Image = $CPU
    }
    catch {
        #Show-MessageBox -Message $error[0].Exception.Message -Title 'Error Connecting vCenter' | Out-Null
    }
}

function Get-EvcInfo {
    $ArrayList = New-Object System.Collections.ArrayList
    $vCenterInfo  = $Global:DefaultVIServer.ExtensionData.Capability.SupportedEVCMode
    $EVCInfo = $vCenterInfo | Select-Object  Vendor, Label #Vendor, VendorTier, Key, Label, Summary
    $ArrayList.AddRange($EVCInfo)
    $EvcDataGridView.DataSource = $ArrayList
}

function Get-ClusterNames {
    $Cluster = Get-Cluster
    $ClusterListComboBox.Items.AddRange($Cluster.Name)
    $Cluster[0].Name
}

function Show-FormOnTop {
    $vCenterForm.TopMost = $true
    $vCenterForm.TopMost = $false
}

#endregion }

#region begin GUI{ 

$vCenterForm                                      = New-Object system.Windows.Forms.Form
$vCenterForm.ClientSize                           = '531,486'
$vCenterForm.text                                 = 'Detect EVC mode'
$vCenterForm.TopMost                              = $false
$vCenterForm.Top                                  = $true

$vCenterTextBox                                   = New-Object system.Windows.Forms.TextBox
$vCenterTextBox.Name                              = 'vCenterTextBox'
$vCenterTextBox.multiline                         = $false
$vCenterTextBox.width                             = 345
$vCenterTextBox.height                            = 20
$vCenterTextBox.location                          = New-Object System.Drawing.Point(16,11)
$vCenterTextBox.Font                              = 'Microsoft Sans Serif,10'
$vCenterTextBoxWaterMark                          = 'Type vCenter Server name to login' 
$vCenterTextBox.ForeColor                         = 'LightGray' 
$vCenterTextBox.Text                              = $vCenterTextBoxWaterMark 
$vCenterTextBox.add_TextChanged({$vCenterTextBox.ForeColor                  = 'Black'})

$ConnectvCenter                                   = New-Object system.Windows.Forms.Button
$ConnectvCenter.text                              = "Connect-vCenter"
$ConnectvCenter.width                             = 133
$ConnectvCenter.height                            = 30
$ConnectvCenter.location                          = New-Object System.Drawing.Point(375,5)
$ConnectvCenter.Font                              = 'Microsoft Sans Serif,10'
$ConnectvCenter.add_Click({Connect-vCenter})

$VCConnected                                      = New-Object system.Windows.Forms.Label
$VCConnected.Name                                 = 'VCConnected'
$VCConnected.text                                 = 'Not connected to any vCenter Server'
$VCConnected.AutoSize                             = $true
$VCConnected.width                                = 25
$VCConnected.height                               = 10
$VCConnected.location                             = New-Object System.Drawing.Point(20,40)
$VCConnected.Font                                 = 'Microsoft Sans Serif,10'

$EvcDataGridView                                  = New-Object system.Windows.Forms.DataGridView
$EvcDataGridView.width                            = 493
$EvcDataGridView.height                           = 229
$EvcDataGridView.location                         = New-Object System.Drawing.Point(14,64)
$EvcDataGridView.AutoSizeColumnsMode              = 'Fill'
#https://msdn.microsoft.com/en-us/library/system.windows.forms.datagridviewautosizecolumnsmode(v=vs.110).aspx

$ClusterListComboBox                              = New-Object system.Windows.Forms.ComboBox
$ClusterListComboBox.text                         = "Select Cluster name from list"
$ClusterListComboBox.width                        = 348
$ClusterListComboBox.height                       = 20
$ClusterListComboBox.location                     = New-Object System.Drawing.Point(14,309)
$ClusterListComboBox.Font                         = 'Microsoft Sans Serif,10'
$ClusterListComboBox.DropDownStyle                = [System.Windows.Forms.ComboBoxStyle]::DropDownList

$SearchEvcMode                                    = New-Object system.Windows.Forms.Button
$SearchEvcMode.text                               = "Search-EvcMode"
$SearchEvcMode.width                              = 133
$SearchEvcMode.height                             = 30
$SearchEvcMode.location                           = New-Object System.Drawing.Point(375,301)
$SearchEvcMode.Font                               = 'Microsoft Sans Serif,10'
$SearchEvcMode.add_Click({Search-EvcMode})

$PictureBox1                                      = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width                                = 101
$PictureBox1.height                               = 92
$PictureBox1.location                             = New-Object System.Drawing.Point(15,341)
#$PictureBox1.imageLocation                       = "undefined"
$PictureBox1.SizeMode                             = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$PictureBox1.Image                                = $CPU

$EVCMode                                          = New-Object system.Windows.Forms.Label
$EVCMode.AutoSize                                 = $true
$EVCMode.width                                    = 25
$EVCMode.height                                   = 10
$EVCMode.location                                 = New-Object System.Drawing.Point(140,356)
$EVCMode.Font                                     = 'Microsoft Sans Serif,10'

$ResultLabel                                      = New-Object system.Windows.Forms.Label
$ResultLabel.AutoSize                             = $true
$ResultLabel.width                                = 25
$ResultLabel.height                               = 10
$ResultLabel.location                             = New-Object System.Drawing.Point(140,393)
$ResultLabel.Font                                 = 'Microsoft Sans Serif,15'

$Url                                              = New-Object System.Windows.Forms.LinkLabel
$Url.text                                         = 'http://vcloud-lab.com'
$Url.AutoSize                                     = $true
$Url.width                                        = 25
$Url.height                                       = 10
$Url.location                                     = New-Object System.Drawing.Point(17,458)
$Url.Font                                         = 'Microsoft Sans Serif,10'
$Url.add_Click({[system.Diagnostics.Process]::start('http://vcloud-lab.com')})

$LogoffvCenter                                    = New-Object system.Windows.Forms.Button
$LogoffvCenter.text                               = 'Logoff-vCenter'
$LogoffvCenter.width                              = 133
$LogoffvCenter.height                             = 30
$LogoffvCenter.location                           = New-Object System.Drawing.Point(370,447)
$LogoffvCenter.Font                               = 'Microsoft Sans Serif,10'
$LogoffvCenter.add_Click({Disconnect-vCenter})

$vCenterForm.controls.AddRange(@($vCenterTextBox,$ConnectvCenter,$EvcDataGridView,$ClusterListComboBox,$SearchEvcMode,$PictureBox1,$EVCMode,$ResultLabel,$VCConnected,$Url, $LogoffvCenter))

#region gui events {
#endregion events }

#endregion GUI }

#Write your logic code here
function Search-EvcMode {
    if ($ClusterListComboBox.SelectedItem -eq $null) {
        Show-MessageBox -Message 'Login to Esxi server first' -Title 'Select Cluster' | Out-Null
    }
    else {
        $EsxiServer = Get-Cluster $ClusterListComboBox.SelectedItem | Get-VMHost
        $EvcTable =  $Global:DefaultVIServer.ExtensionData.Capability.SupportedEVCMode | Select-Object Vendor, VendorTier, Key, Label, Summary
        $EsxiInfo = $EsxiServer | Select-Object MaxEVCMode 
        $EsxiEvcTable = @()
        foreach ($Esxi in $EsxiInfo) {
            $EsxiEvcTable += $EvcTable | Where-Object {$_.Key -contains $Esxi.MaxEVCMode}
        }
        $GroupedVendor = $EsxiEvcTable | Group-Object -Property Vendor
        $VendorCount = $GroupedVendor | Measure-Object
        if ($VendorCount.Count -eq 0) {
            $EVCMode.text = "No esxi host found in cluster, it is empty `n$($ClusterListComboBox.SelectedItem)"
            $PictureBox1.Image = $CPU
        }
        elseif ($VendorCount.Count -eq 1) {
            $GetEVCMode = $GroupedVendor.Group | Sort-Object -Property VendorTier -Unique | Select-Object -First 1
            $EVCMode.text  = "EVC Mode should be $($GetEVCMode.Vendor.toUpper())"
            $ResultLabel.text = $GetEVCMode.Label
            if ($GetEVCMode.Vendor -eq 'intel') {
                $PictureBox1.Image = $Intel
            }
            elseif ($GetEVCMode.Vendor -eq 'amd') {
                $PictureBox1.Image = $Amd
            }
            else {
                $PictureBox1.Image = $CPU
            }
        }
        else {
            $EVCMode.text = "Esxi server with mixed CPU vendors in cluster, `n$($ClusterListComboBox.SelectedItem) `nCannot detect EVC mode"
            $PictureBox1.Image = $CPU
        }
    }
}

$vCenterForm.ShowDialog() | Out-Null
