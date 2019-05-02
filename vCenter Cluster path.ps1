Import-Module vmware.vimautomation.core

#Connect-VIServer vCenter

$folderPaths = @{childFolderCount = 0}
$root = Get-Folder -NoRecursion
$clusters = Get-Cluster
$path = $null

foreach ($cluster in $clusters)
{
    $path = $null
    $path = "\{0}" -f $cluster.Name
    if (($cluster.ParentFolder.Name -eq 'host') -and ($cluster.ParentFolder.Type -eq 'HostAndCluster'))
    {
        $parentIsDc = $cluster.ParentFolder.Parent
        $path = "\{0}{1}" -f $parentIsDc.Name, $path

        $parentIsFolder = $parentIsDc.ParentFolder
        while ($parentIsFolder.Id -ne $root.Id)
        {
            $path = "\{0}{1}" -f $parentIsFolder.Name, $path
            $parentIsFolder = $parentIsFolder.Parent
            #$path = "\{0}{1}" -f $parentIsFolder.Name, $path
        }
    }
    elseif ($cluster.ParentFolder.ExtensionData.GetType().FullName -eq 'VMware.Vim.Folder')
    {
        #starts with HostAndCluster Folders (Folders between cluster and virtual datacenter)
        $parentIsFolder = $cluster.ParentFolder
        while ($parentIsFolder.Parent.ExtensionData.GetType().FullName -ne 'VMware.Vim.Datacenter')
        {
            $path = "\{0}{1}" -f $parentIsFolder.Name, $path
            $parentIsFolder = $parentIsFolder.Parent
            #$path = "\{0}{1}" -f $parentIsFolder.Name, $path
        }
        $parentIsDc = $parentIsFolder.Parent
        $path = "\{0}{1}" -f $parentIsDc.Name, $path

        #These are datacenter Folders (Folders between VDatacenter and vCenter Server)
        $parentIsFolder = $parentIsDc.ParentFolder
        $path = "\{0}{1}" -f $parentIsFolder.Name, $path

        while ($parentIsFolder.Parent.Id -ne $root.Id)
        {
            #$path = "\{0}{1}" -f $parentIsFolder.Name, $path
            $parentIsFolder = $parentIsFolder.Parent
            $path = "\{0}{1}" -f $parentIsFolder.Name, $path
        }
    }
    $path
}