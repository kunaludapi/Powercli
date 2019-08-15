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