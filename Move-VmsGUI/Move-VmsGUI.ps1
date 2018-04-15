#Designed and created by Kunal: http://vcloud-lab.com 
#Tools used
    #Windows 10
    #Powercli 6.5
    #PrimalForms Community Edition

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#endregion

#region Generated Form Objects
$vCenterForm = New-Object System.Windows.Forms.Form
$vcloudurl = New-Object System.Windows.Forms.LinkLabel
$LastVM = New-Object System.Windows.Forms.Label
$listlabel = New-Object System.Windows.Forms.Label
$CurrentVM = New-Object System.Windows.Forms.Label
$RemCount = New-Object System.Windows.Forms.Label
$RemainingCount = New-Object System.Windows.Forms.Label
$dataGrid1 = New-Object System.Windows.Forms.DataGrid
$DestEsxiLabel = New-Object System.Windows.Forms.Label
$ESXiInfo = New-Object System.Windows.Forms.Button
$MigrateVM = New-Object System.Windows.Forms.Button
$logoffvcenter = New-Object System.Windows.Forms.Button
$SourceEsxiLabel = New-Object System.Windows.Forms.Label
$DestinationEsxi = New-Object System.Windows.Forms.ComboBox
$SourceEsxi = New-Object System.Windows.Forms.ComboBox
$ClusterList01 = New-Object System.Windows.Forms.CheckedListBox
$vCenterServer = New-Object System.Windows.Forms.TextBox
$statusBar1 = New-Object System.Windows.Forms.StatusBar
$LoginvCenter = New-Object System.Windows.Forms.Button
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
$Info = New-Object System.Windows.Forms.Label

#----------------------------------------------
#region Generated Form Code
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 540
$System_Drawing_Size.Width = 659
$vCenterForm.ClientSize = $System_Drawing_Size
$vCenterForm.DataBindings.DefaultDataSourceUpdateMode = 0
$vCenterForm.Name = "vCenterForm"
$vCenterForm.Text = "Migrate VMs from one ESXi to another"

$Info.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 517
$System_Drawing_Point.Y = 88
$Info.Location = $System_Drawing_Point
$Info.Name = "Info"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 33
$System_Drawing_Size.Width = 75
$Info.Size = $System_Drawing_Size
$Info.TabIndex = 17
$Info.Text = "Windows 10    Powercli 6.5"
$Info.add_Click($handler_label1_Click)

$vCenterForm.Controls.Add($Info)

$vcloudurl.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 478
$System_Drawing_Point.Y = 486
$vcloudurl.Location = $System_Drawing_Point
$vcloudurl.Name = "vcloudurl"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 114
$vcloudurl.Size = $System_Drawing_Size
$vcloudurl.TabIndex = 15
$vcloudurl.TabStop = $True
$vcloudurl.Text = "http://vcloud-lab.com"
$vcloudurl.add_Click({[system.Diagnostics.Process]::start('http://vcloud-lab.com')}) 
$vCenterForm.Controls.Add($vcloudurl)

$logoffvcenter.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 485
$logoffvcenter.Location = $System_Drawing_Point
$logoffvcenter.Name = "logoffvcenter"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 127
$logoffvcenter.Size = $System_Drawing_Size
$logoffvcenter.TabIndex = 16
$logoffvcenter.Text = "LogOff-vCenter"
$logoffvcenter.UseVisualStyleBackColor = $True
$logoffvcenter.add_Click($logoffvcenter_OnClick)

$vCenterForm.Controls.Add($logoffvcenter)

$LastVM.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 147
$System_Drawing_Point.Y = 406
$LastVM.Location = $System_Drawing_Point
$LastVM.Name = "LastVM"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 29
$System_Drawing_Size.Width = 446
$LastVM.Size = $System_Drawing_Size
$LastVM.TabIndex = 13
$LastVM.Text = "Last VM Migrated"
$LastVM.Font = 'Microsoft Sans Serif,14'

$vCenterForm.Controls.Add($LastVM)

$CurrentVM.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 146
$System_Drawing_Point.Y = 339
$CurrentVM.Location = $System_Drawing_Point
$CurrentVM.Name = "CurrentVM"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 54
$System_Drawing_Size.Width = 446
$CurrentVM.Size = $System_Drawing_Size
$CurrentVM.TabIndex = 12
$CurrentVM.Text = "Current VM"
$CurrentVM.Font = 'Microsoft Sans Serif,16'

$vCenterForm.Controls.Add($CurrentVM)

$RemCount.BackColor = [System.Drawing.Color]::FromArgb(255,0,192,192)
$RemCount.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 380
$RemCount.Location = $System_Drawing_Point
$RemCount.Name = "RemCount"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 103
$System_Drawing_Size.Width = 127
$RemCount.Size = $System_Drawing_Size
$RemCount.TabIndex = 11
$RemCount.Text = 0
$RemCount.TextAlign = 32
$RemCount.Font = 'Microsoft Sans Serif,40'

$vCenterForm.Controls.Add($RemCount)

$RemainingCount.BackColor = [System.Drawing.Color]::FromArgb(255,0,128,128)
$RemainingCount.DataBindings.DefaultDataSourceUpdateMode = 0
$RemainingCount.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 339
$RemainingCount.Location = $System_Drawing_Point
$RemainingCount.Name = "RemainingCount"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 41
$System_Drawing_Size.Width = 127
$RemainingCount.Size = $System_Drawing_Size
$RemainingCount.TabIndex = 10
$RemainingCount.Text = "Remaing VMs count to migrate"
$RemainingCount.TextAlign = 32

$vCenterForm.Controls.Add($RemainingCount)

$dataGrid1.DataBindings.DefaultDataSourceUpdateMode = 0
$dataGrid1.DataMember = ""
$dataGrid1.HeaderForeColor = [System.Drawing.Color]::FromArgb(255,0,0,0)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 213
$dataGrid1.Location = $System_Drawing_Point
$dataGrid1.Name = "dataGrid1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 119
$System_Drawing_Size.Width = 581
$dataGrid1.Size = $System_Drawing_Size
$dataGrid1.TabIndex = 9

$vCenterForm.Controls.Add($dataGrid1)

$DestEsxiLabel.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 90
$System_Drawing_Point.Y = 186
$DestEsxiLabel.Location = $System_Drawing_Point
$DestEsxiLabel.Name = "DestEsxiLabel"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 139
$DestEsxiLabel.Size = $System_Drawing_Size
$DestEsxiLabel.TabIndex = 8
$DestEsxiLabel.Text = "Destination ESXi server"

$vCenterForm.Controls.Add($DestEsxiLabel)

$SourceEsxiLabel.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 90
$System_Drawing_Point.Y = 158
$SourceEsxiLabel.Location = $System_Drawing_Point
$SourceEsxiLabel.Name = "SourceEsxiLabel"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 139
$SourceEsxiLabel.Size = $System_Drawing_Size
$SourceEsxiLabel.TabIndex = 7
$SourceEsxiLabel.Text = "Source ESXi server"

$vCenterForm.Controls.Add($SourceEsxiLabel)

$DestinationEsxi.DataBindings.DefaultDataSourceUpdateMode = 0
$DestinationEsxi.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 235
$System_Drawing_Point.Y = 186
$DestinationEsxi.Location = $System_Drawing_Point
$DestinationEsxi.Name = "DestinationEsxi"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 358
$DestinationEsxi.Size = $System_Drawing_Size
$DestinationEsxi.TabIndex = 6

$vCenterForm.Controls.Add($DestinationEsxi)

$SourceEsxi.DataBindings.DefaultDataSourceUpdateMode = 0
$SourceEsxi.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 235
$System_Drawing_Point.Y = 158
$SourceEsxi.Location = $System_Drawing_Point
$SourceEsxi.Name = "SourceEsxi"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 358
$SourceEsxi.Size = $System_Drawing_Size
$SourceEsxi.TabIndex = 5

$vCenterForm.Controls.Add($SourceEsxi)

$MigrateVM.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 452
$System_Drawing_Point.Y = 126
$MigrateVM.Location = $System_Drawing_Point
$MigrateVM.Name = "MigrateVM"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 140
$MigrateVM.Size = $System_Drawing_Size
$MigrateVM.TabIndex = 18
$MigrateVM.Text = "Migrate-VMs"
$MigrateVM.UseVisualStyleBackColor = $True
$MigrateVM.add_Click($MigrateVM_OnClick)
$MigrateVM.Enabled = $false

$vCenterForm.Controls.Add($MigrateVM)

$ClusterList01.DataBindings.DefaultDataSourceUpdateMode = 0
$ClusterList01.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 42
$ClusterList01.Location = $System_Drawing_Point
$ClusterList01.Name = "ClusterList01"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 79
$System_Drawing_Size.Width = 423
$ClusterList01.Size = $System_Drawing_Size
$ClusterList01.TabIndex = 3
$ClusterList01.CheckOnClick = $True

$vCenterForm.Controls.Add($ClusterList01)

$listlabel.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 452
$System_Drawing_Point.Y = 42
$listlabel.Location = $System_Drawing_Point
$listlabel.Name = "listlabel"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 41
$System_Drawing_Size.Width = 141
$listlabel.Size = $System_Drawing_Size
$listlabel.TabIndex = 17
$listlabel.Text = "Clusters List"
$listlabel.Font = 'Microsoft Sans Serif,14'

$vCenterForm.Controls.Add($listlabel)

$vCenterServer.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 165
$System_Drawing_Point.Y = 12
$vCenterServer.Location = $System_Drawing_Point
$vCenterServer.Name = "vCenterServer"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 428
$vCenterServer.Size = $System_Drawing_Size
$vCenterServer.TabIndex = 2

$vCenterForm.Controls.Add($vCenterServer)

$statusBar1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = 518
$statusBar1.Location = $System_Drawing_Point
$statusBar1.Name = "statusBar1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 22
$System_Drawing_Size.Width = 659
$statusBar1.Size = $System_Drawing_Size
$statusBar1.TabIndex = 1

$vCenterForm.Controls.Add($statusBar1)


$LoginvCenter.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 11
$LoginvCenter.Location = $System_Drawing_Point
$LoginvCenter.Name = "LoginvCenter"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 146
$LoginvCenter.Size = $System_Drawing_Size
$LoginvCenter.TabIndex = 0
$LoginvCenter.Text = "Login-vCenter"
$LoginvCenter.UseVisualStyleBackColor = $True
$LoginvCenter.add_Click($LoginvCenter_OnClick)

$vCenterForm.Controls.Add($LoginvCenter)


$ESXiInfo.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 13
$System_Drawing_Point.Y = 127
$ESXiInfo.Location = $System_Drawing_Point
$ESXiInfo.Name = "ESXiInfo"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 146
$ESXiInfo.Size = $System_Drawing_Size
$ESXiInfo.TabIndex = 16
$ESXiInfo.Text = "Get-EsxiInfo"
$ESXiInfo.UseVisualStyleBackColor = $True
$ESXiInfo.add_Click($ESXiInfo_OnClick)
$ESXiInfo.Enabled = $false

$vCenterForm.Controls.Add($ESXiInfo)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $vCenterForm.WindowState
#Init the OnLoad event to correct the initial state of the form
$vCenterForm.add_Load($OnLoadForm_StateCorrection)

#region code here
function Show-FormOnTop {
    $vCenterForm.TopMost = $true
    $vCenterForm.TopMost = $false
}
Show-FormOnTop

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

function Disconnect-vCenter {
    
    try {
        Disconnect-VIServer * -Confirm:$false -ErrorAction Stop
        $ClusterList01.Items.Clear()
    }
    catch {
        #Show-MessageBox -Message $error[0].Exception.Message -Title 'Error Connecting vCenter' | Out-Null
    }
}

Function Connect-vCenter {
    param (
        [parameter(Mandatory=$true)]
        [string]$vCenterName
    )
    Confirm-Powercli
    Show-FormOnTop
    if ($Global:DefaultVIServer -ne $null) {
        Disconnect-vCenter
    }
    if (($vCenterServer.Text -eq $vCenterNameWaterMark) -or ($vCenterServer.Text -eq '')) { 
        #[System.Windows.Forms.MessageBox]::Show("Please type valid Domain\Account", "Textbox empty")
        Show-MessageBox -Message "Please type valid vCenter server name" -Title 'vCenter Server Name' | Out-Null
    } 
    else { 
        try {
            $cred = Get-Credential
            Connect-VIServer $vCenterName -Credential $Cred -ErrorAction Stop #| Out-Null
            $Script:ClusterName = Get-Cluster
            if ($Script:ClusterName -ne $null) {
                $ClusterList01.Items.AddRange($Script:ClusterName.Name)
            }
            else {
                Show-MessageBox -Message 'No cluster found in current vCenter' -Title 'Error: No cluster to select' | Out-Null
            }
        }
        catch {
            Show-FormOnTop
            Show-MessageBox -Message $error[0].Exception.Message -Title 'Error Connecting vCenter' | Out-Null
        }
    }
    Show-FormOnTop
    $statusBar1.Text = 'Connected to vCenter successfully'
}

$vCenterNameWaterMark = 'Type vCenter server or IP'
$vCenterServer.Text = $vCenterNameWaterMark
$vCenterServer.ForeColor = 'DarkGray'
$vCenterServer.add_TextChanged({$vCenterServer.ForeColor = 'Black'})

$LoginvCenter.add_click({
    Connect-vCenter -vCenterName $vCenterServer.Text.Trim()
    Show-FormOnTop
})

$ClusterList01.add_ItemCheck({
    $ESXiInfo.Enabled = $True
})

function Add-ComboBoxItem {
    $Clusters = $script:ClusterName | Where-Object {$_.Name -in $ClusterList01.CheckedItems}
    $Script:EsxiHosts = $Clusters | Get-VMHost | Where-Object {$_.ConnectionState -eq 'Connected' -and $_.PowerState -eq 'PoweredOn'}
    if ($Script:EsxiHosts -eq $null) {
        Show-MessageBox -Message "No esxi host found in selected cluster" -Title 'Select Cluster'
        $MigrateVM.Enabled = $false
    }
    else {
        $SourceEsxi.Items.AddRange($EsxiHosts.Name)
        $SourceEsxi.Text = $SourceEsxi.Items[0]
        $DestinationEsxi.Items.AddRange($EsxiHosts.Name)
        $DestinationEsxi.Text = $SourceEsxi.Items[1]
        $MigrateVM.Enabled = $True
        Update-VMDataGrid
    }
}

function Update-VMDataGrid {
    $SourceEsxiInfo = $Script:EsxiHosts | Where-Object {$_.Name -eq $SourceEsxi.Text}
    $Script:VMlist = $SourceEsxiInfo | Get-VM
    if ($Script:VMlist -eq $null) {
        Show-MessageBox -Message "No VMs found in selected source esxi" -Title 'Select an'
    }
    else {
        $ArrayList = New-Object System.Collections.ArrayList
        $VMs = $Script:VMlist | Select-Object Name, NumCpu, MemoryGB, PowerState
        if ($VMs -ne $null) {
            $ArrayList.AddRange($VMs)
            $dataGrid1.DataSource = $ArrayList
            $dataGrid1.ReadOnly = $True
            $RemCount.text = $VMs.Count
        }
        else {
            $statusBar1.Text = "Selected source esxi host doesn't have any VMs"
        }
    }
}

$ESXiInfo.Add_click({
    $SourceEsxi.Items.Clear()
    $DestinationEsxi.Items.Clear()
    if ($ClusterList01.CheckedItems.Count -eq 0) {
        Show-MessageBox -Message 'Choose atleast one Cluster from list' -Title 'Select cluster' | Out-Null
    }
    Add-ComboBoxItem
})

function Change-DestCombobox {
    Show-MessageBox -Message 'Source and destination esxi servers are same' -Title 'Esxi name conflict' | Out-Null
    $dataGrid1.DataSource = $null
    $DestinationEsxi.Text = $SourceEsxi.Items[$SourceEsxi.SelectedIndex - 1]
    $statusBar1.Text = 'Source and destination Esxi should different'
}

$SourceEsxi.Add_TextChanged({
    if ($DestinationEsxi.Text -eq $SourceEsxi.Text) {
        Change-DestCombobox
    }
    Update-VMDataGrid
})

$DestinationEsxi.Add_TextChanged({
    if ($DestinationEsxi.Text -eq $SourceEsxi.Text) {
        Change-DestCombobox
    }
})

$MigrateVM.Add_Click({
    $ConfirmMigrate = Show-MessageBox -Message 'Do you want to start migrating VMs' -Title 'Start VM migration' -Button 4 -Icon Question
    $DestEsxi = Get-VMHost $DestinationEsxi.Text
    $VMCount = $Script:VMlist.Count
    if ($ConfirmMigrate -eq 'Yes') {
        foreach ($VM in $Script:VMlist)	{
            $CurrentVM.Text = "Currently migrating VM: $($VM.Name)"
            $vCenterForm.Refresh()
            try {
                $VM | Move-VM -Destination $DestEsxi -ErrorAction Stop
                $VMCount--
                $LastVM.Text = "Last VM migrated: $($VM.Name)"
            }
            catch {
                $statusBar1.Text = 'Few VMs cannot be migrated, check manually'
            }
            $RemCount.Text = $VMCount
            $vCenterForm.Refresh()
            Show-FormOnTop
        }	
        $CurrentVM.Text = 'All VMs Migrated'
    }
})

$logoffvcenter.Add_Click({
    Disconnect-vCenter
    $ESXiInfo.Enabled = $false
    $dataGrid1.DataSource.Clear()
    $MigrateVM.Enabled = $false
    $SourceEsxi.Items.Clear()
    $DestinationEsxi.Items.Clear()
    $statusBar1.Text = 'Disconnected vCenter successfully'
})

#endregion Code here
Show-FormOnTop
#Show the Form
$vCenterForm.ShowDialog()| Out-Null
