#Connect ESXi Server
$vmHost = Get-VMHost -Name ironman.vcloud-lab.com

#Assign Evaluation license to ESXi server
Set-VMHost -VMHost $vmHost -LicenseKey 00000-00000-00000-00000-00000

#Assign 25 digit separated by - into five batches to ESXi server
Set-VMHost -VMHost $vmHost -LicenseKey ABC12-ABC12-ABC12-ABC12-ABC12

#Get ESXi assigned license information
Get-VMHost -Name ironman.vcloud-lab.com | Select-Object Name, LicenseKey