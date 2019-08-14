{
    Import-Module VMware.VimAutomation.Core
    Connect-VIServer marvel.vcloud-lab.com
}

$dataCenterName = 'DatacenterName'
$clusterName = 'ClusterName'

######################################
Custom Attributes example
######################################
Get-Datacenter $dataCenterName | Get-Cluster | Select-Object Name, @{N='CMDBID'; E={($_.CustomFields | Where-Object {$_.Key -eq 'CMDBID'}).value}}
Get-Datacenter $dataCenterName | Get-Cluster $clusterName | Set-Annotation -CustomAttribute 'CMDBID' -Value 'CLU0000001111'

{
    $csv = Import-Csv CMDBData.csv

    foreach ($data in $csv) 
    {
        Get-Cluster $data.Cluster | Set-Annotation -CustomAttribute 'CMDBID' -Value $data.CMDBID
    }
}

##############################
#View current TagAssignment
Get-Datacenter $dataCenterName | Get-Cluster | Get-TagAssignment | Select-Object Entity, Tag
Get-TagAssignment -Entity (Get-Cluster $clusterName) | Select-Object Entity, Tag

#set an existing tag to a entity
New-TagAssignment -Entity (Get-Cluster $clusterName) -Tag 'CMDBID'

##############################
#Create a new Tag Category
New-TagCategory -Name CMDBID -Cardinality Single -EntityType Cluster

#Create a new tag with value and assigne to entity
$tag =  New-Tag -Name CLU0000002222 -Category CMDID -Description 'Test Comment'
Get-Cluster -Name $clusterName | New-TagAssignment -Tag $tag

##############################
#Assign Tags from CSV file - Incomplete

$allTags = Get-Tag
$csv = Import-Csv C:\temp\data.csv

foreach ($data in $csv) 
{
    $currentConf =  Get-TagAssignment -Entity (Get-CLuster $data.Cluster) #| Select-Object Entity, Tag
    foreach ($conf in $currentConf) 
    {
        if (($conf.Tag.Category.Name -eq 'CMDBID') -and ($conf.Tag.Name -eq $data.CMDBID))
        {
            'Test'
            break
        }
        #Add elseif - if $conf.tag.name not equals to $data.CMDBID, Remove or set-tag
        else 
        {
            $tag = New-Tag -Name $data.CMDBID -Category CMDBID
            Get-Cluster -Name $data.Cluster | New-TagAssignment -Tag $tag
        }
    }
}
