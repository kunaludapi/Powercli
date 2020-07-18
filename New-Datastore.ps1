#Login to vCenter Server
$vCenterServer = 'marvel.vcloud-lab.com'
Remove-Module -Name Hyper-V
Import-Module -Name VMware.PowerCLI
Connect-VIServer -Server $vCenterServer -User administrator@vsphere.local -Password P@ssw0rd

#Define your environment
$esxiServer = 'ironman.vcloud-lab.com'
$hbaModel =  'PVSCSI SCSI Controller' 

#Esxi server information
$esxi = Get-VMhost $esxiServer
$esxi

#Get HBA storage adapter information
$hostHBA =  $esxi | Get-VMHostHba | Where-Object {$_.Model -eq $hbaModel}
$hostHBA

#Get the list of Datastore
$datastore = Get-Datastore
$datastore

#Get available LUN storage devices list
$lunList = $hostHBA | Get-ScsiLun
$lunlist | Format-Table -AutoSize

#Get the list of LUN on datastores are created
foreach ($lun in $lunList)
{
    $lun | Select-Object CanonicalName, RuntimeName, CapacityGB, @{Label='DatastoreName'; Expression={$datastore | Where-Object {$_.Extensiondata.Info.Vmfs.Extent.DiskName.Contains($lun.CanonicalName)} | Select-Object -ExpandProperty Name}}
}

#Rescan/Refresh Esxi Storage 
$esxi | Get-VMHostStorage -Refresh -RescanAllHba

#Get get the newly discovered LUN information
$lunList = $hostHBA | Get-ScsiLun
$lunlist | Format-Table -AutoSize

foreach ($lun in $lunList)
{
    $lun | Select-Object CanonicalName, RuntimeName, CapacityGB, @{Label='DatastoreName'; Expression={$datastore | Where-Object {$_.Extensiondata.Info.Vmfs.Extent.DiskName.Contains($lun.CanonicalName)} | Select-Object -ExpandProperty Name}}
}

#Get the RuntimeName of Lun (Local as well as Remote shared storage)
$addedNewLun = $lunlist | Where-Object {$_.CanonicalName -eq 'mpx.vmhba0:C0:T2:L0'}
$addedNewLun | Format-Table -AutoSize

#Add new Datastore using RuntimeName of newly Added Lun
$datastoreName = '5gb_local_datastore'
New-Datastore -VMHost $esxi.Name -Name '5gb_local_datastore' -Path $addedNewLun.CanonicalName -Vmfs -FileSystemVersion 6

#Recheck Datastore list
$datastore = Get-Datastore
$datastore

#Recheck LUN and Datastore mapping
$lunList = $hostHBA | Get-ScsiLun
foreach ($lun in $lunList)
{
    $lun | Select-Object CanonicalName, RuntimeName, CapacityGB, @{Label='DatastoreName'; Expression={$datastore | Where-Object {$_.Extensiondata.Info.Vmfs.Extent.DiskName.Contains($lun.CanonicalName)} | Select-Object -ExpandProperty Name}}
}


