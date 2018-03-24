function Get-FreeEsxiLUNs {
    ##############################
    #.SYNOPSIS
    #Shows free or unassigned SCSI LUNs/Disks on Esxi
    #
    #.DESCRIPTION
    #The Get-FreeEsxiLUNs cmdlet finds free or unassigned SCSI LUNs/Disks on VMWare Esxi server. Free or unassigned disks are unformatted LUNs and need to format VMFS datastore or use as RDM (Raw Device Mapping)
    #
    #.PARAMETER Esxihost
    #This is VMware Esxi host name
    #
    #.EXAMPLE
    #Get-FreeEsxiLUNs -Esxihost Esxi001.vcloud-lab.com
    #
    #Shows free unassigned storage Luns disks on Esxi host name Esxi001.vcloud-lab.com
    #
    #.NOTES
    #http://vcloud-lab.com
    #Written using powershell version 5
    #Script code version 2.0
    ###############################

    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [System.String]$Esxihost
    )    
    Begin {
        if (-not(Get-Module vmware.vimautomation.core)) {
            Import-Module vmware.vimautomation.core
        }
        #Connect-VIServer | Out-Null
    }
    Process {
        $VMhost = Get-VMhost $EsxiHost
        $AllLUNs = $VMhost | Get-ScsiLun -LunType disk
        $Datastores = $VMhost | Get-Datastore
        foreach ($lun in $AllLUNs) {
            $Datastore = $Datastores | Where-Object {$_.extensiondata.info.vmfs.extent.Diskname -Match $lun.CanonicalName}
            if ($Datastore.Name -eq $null) {
                $lun | Select-Object VMHost, CanonicalName, CapacityGB, Vendor, Model, MultipathPolicy, ConsoleDeviceName, SerialNumber
            } 
        }
    }
    End {}
}

#Get-FreeEsxiLUNs -Esxihost <Esxi001.vcloud-lab.com>