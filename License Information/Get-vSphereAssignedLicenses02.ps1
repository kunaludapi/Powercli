$LicenseManager= Get-view LicenseManager
$LicenseAssignmentManager= Get-View $LicenseManager.LicenseAssignmentManager 
$param = @($null)
$LicenseAssignmentManager.GetType().GetMethod("QueryAssignedLicenses").Invoke($LicenseAssignmentManager,$param)
