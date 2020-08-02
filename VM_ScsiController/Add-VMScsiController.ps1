#Remove-Module Hyper-V
#Import-Module VMware.PowerCLI
#Connect-VIServer -Server marvel.vcloud-lab.com -Username administrator@vsphere.local -Password Computer@1

function Add-VMScsiController
{
    [CmdletBinding()]
    param (
        [Parameter(
            Position=0,
            Mandatory=$true, #change here
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Enter one or more VM Id separated by commas.'
        )]
        [Alias('VmID')]
        [string[]]$VirtualMachineId, #change here
        
        [Parameter(
            Position=1,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Enter SCSI contoller type.'
        )]        
        [ValidateSet('ParaVirtualSCSIController','VirtualBusLogicController','VirtualLsiLogicController','VirtualLsiLogicSASController')]
        [string]$ControllerType = 'VirtualLsiLogicSASController',

        [Parameter(
            Position=2,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Enter SCSI shared bus.'
        )]        
        [ValidateSet('noSharing', 'physicalSharing', 'virtualSharing')]
        [string]$SharedBus = 'noSharing',
        
        [Parameter(
            Position=3,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage='Enter SCSI bus Number type.'
        )]        
        [ValidateRange(0,3)]
        [string]$BusNumber = 1
    )
    $virtualMachine = Get-VM -Id $VirtualMachineId 
    $scsiController = $virtualMachine | Get-ScsiController
    Write-Host -BackgroundColor DarkYellow "$([char]8734)" -NoNewline
    Write-Host  " '$($virtualMachine.Name)' - Configuring SCSI controller $BusNumber"
    if ($scsiController.ExtensionData.BusNumber -contains $BusNumber)
    {
        Write-Host -BackgroundColor DarkRed "`t$([char]215)" -NoNewline
        Write-Host " 'SCSI controller $BusNumber' already exist"
    } #1) if ($virtualMachine.ExtensionData.BusNumber -contains $BusNumber)
    else 
    {
        $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
        $spec.DeviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec[] (1)
        $spec.DeviceChange[0] = New-Object VMware.Vim.VirtualDeviceConfigSpec
        $spec.DeviceChange[0].Device = New-Object VMware.Vim.$ControllerType #ParaVirtualSCSIController, VirtualBusLogicController, VirtualLsiLogicController, VirtualLsiLogicSASController
        $spec.DeviceChange[0].Device.SharedBus = $SharedBus #noSharing, physicalSharing, virtualSharing
        #$spec.DeviceChange[0].Device.ScsiCtlrUnitNumber = 7 #The unit number of the SCSI controller. The SCSI controller sits on its own bus, so this field defines which slot the controller is using.
        $spec.DeviceChange[0].Device.DeviceInfo = New-Object VMware.Vim.Description
        $spec.DeviceChange[0].Device.DeviceInfo.Summary = 'New SCSI controller'
        $spec.DeviceChange[0].Device.DeviceInfo.Label = 'New SCSI controller'
        #$spec.DeviceChange[0].Device.Key = -107
        $spec.DeviceChange[0].Device.BusNumber = $BusNumber
        $spec.DeviceChange[0].Operation = 'add'
        $vm = Get-View -Id $VirtualMachineId
        [void]$vm.ReconfigVM_Task($spec)
        Start-Sleep -Seconds 3
        $scsiController = $virtualMachine | Get-ScsiController
        if ($scsiController.ExtensionData.BusNumber -contains $BusNumber)
        {
            Write-Host -BackgroundColor DarkGreen "`t$([char]8730)" -NoNewline
            Write-Host  " 'SCSI controller $BusNumber' created successfully"
        }
        else 
        {
            Write-Host -BackgroundColor DarkRed "`t$([char]215)" -NoNewline
            Write-Host  " 'SCSI controller $BusNumber' adding failed"
        }
    } #1) else if ($virtualMachine.ExtensionData.BusNumber -contains $BusNumber)
} #function Add-VMScsiController

#Get existing virtual SCSI controller information from VMs
$vms = Get-VM dev-01,dev-02,uat-01,uat-02
$vms | Get-ScsiController | Select Parent, Name, Type

#Add SCSI controller
$vms | Foreach-Object {Add-VMScsiController -VirtualMachineId $_.Id -ControllerType ParaVirtualSCSIController -BusNumber 1}

#Recheck virtual SCSI controller information again
$vms | Get-ScsiController | Select-Object Parent, Name, Type