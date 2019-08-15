{
    Import-Module VMware.VimAutomation.Core
    Connect-VIServer marvel.vcloud-lab.com -User administrator@vsphere.local -Password Computer@1
}

$dataCenterName = 'Dev_Datacenter01'
$clusterName = 'Dev-Cluster001'
$clusterName2 = 'Dev-Cluster002'

######################################
#Custom Attributes example
######################################
#Get Info
Get-Datacenter $dataCenterName | Get-Cluster | Select-Object Name, @{N='CMDBID'; E={($_.CustomFields | Where-Object {$_.Key -eq 'CMDBID'}).value}}

#Set Info
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
Get-Datacenter $dataCenterName | Get-Cluster | Get-TagAssignment | Select-Object Entity, @{N='CatagoryName'; E={$_.Tag.Category}},  @{N='TagName'; E={$_.Tag.Name}}
Get-TagAssignment -Entity (Get-Cluster $clusterName) | Select-Object Entity, Tag
Get-TagAssignment -Entity (Get-Cluster $clusterName) | Select-Object Entity, @{N='CatagoryName'; E={$_.Tag.Category}},  @{N='TagName'; E={$_.Tag.Name}}

#set an existing tag to a entity
#New-TagAssignment -Entity (Get-Cluster $clusterName) -Tag 'CMDBID'
New-TagAssignment -Entity (Get-Cluster $clusterName) -Tag 'CLU00000111'


##############################
#Create a new Tag Category
New-TagCategory -Name CMDBID -Cardinality Single -EntityType Cluster

#Create a new tag with value and assigne to entity
$tag = New-Tag -Name CLU00000222 -Category CMDBID -Description 'Test Comment'
Get-Cluster -Name $clusterName | New-TagAssignment -Tag $tag

##############################
#Assign Tags from CSV file - Incomplete
<# Data in the csv
Cluster,Tag,TagCategory,Cardinality,EntityType
Dev-Cluster001,CLU000111,CMDBID,Single,Cluster
Dev-Cluster002,CLU000222,CMDBID,Single,Cluster
#>

$csv = Import-Csv C:\temp\data.csv

$uniqueTagCategory = $csv | Sort-Object -Property @{Expression='TagCategory'; Descending=$true}, Cardinality, EntityType -Unique
foreach ($data in $uniqueTagCategory)
{
    try 
    {
        $newTagCategory = New-TagCategory -Name $data.TagCategory -Cardinality $data.Cardinality -EntityType $data.EntityType -ErrorAction Stop
        Write-Host "New TagCategory created - '$($newTagCategory.Name)'" -BackgroundColor DarkGreen
    }
    catch 
    {
        $tagCategory = Get-TagCategory -Name $data.TagCategory -ErrorAction Stop
        $entityType = $tagCategory.EntityType -join ','
        Write-Warning " Already exist - TagCategory '$($tagCategory.Name)' with Cardinality '$($tagCategory.Cardinality)' and Entitytype '$entityType'" 
    }
}

foreach ($data in $csv)
{

    $cluster = Get-Cluster $data.Cluster
    $currentConf = Get-TagAssignment -Entity $cluster | Where-Object {$_.Tag.Category.Name -eq $data.TagCategory}
    if ($currentConf.Tag.Name -eq $null)
    {
        $tag = New-Tag -Name $data.Tag -Category $data.TagCategory
        $tagAssignment = $cluster | New-TagAssignment -Tag $tag
        $message = "Cluster '{0}' assigned New tag '{1}' under TagCategory '{2}'" -f $tagAssignment.Entity.Name, $tagAssignment.Tag.Name, $tagAssignment.Tag.Category.Name
        Write-Host $message -ForegroundColor Yellow
    }
    elseif ($currentConf.Tag.Name -ne $data.Tag)
    {
        $replaceTag = $currentConf.Tag | Set-Tag -Name $data.Tag
        $message = "Cluster '{0}' current tag '{1}' replaced with '{2}' under TagCategory '{3}'" -f $replaceTag.Entity.Name, $currentConf.tag.Name, $replaceTag.Name, $replaceTag.Category.Name
        Write-Host $message -ForegroundColor Red
    }
    else
    {
        $message = "Cluster '{0}' is already configured with Tag '{1}' under TagCategory '{2}'" -f $currentConf.Entity.Name, $currentConf.tag.Name, $currentConf.tag.Category.Name
        Write-Host $message -ForegroundColor Green
    }
}

Get-Cluster $csv.Cluster | Get-TagAssignment | Select-Object Entity, Tag