cls
Import-Module ActiveDirectory
$Group1 = Read-Host "Enter the source Security Group: "

           Write-Host "Getting Group Members.  Please wait..." -ForegroundColor Yellow
$Group2 = Read-Host "Enter the target Security Group: "

           Write-Host "Getting Group Members.  Please wait..." -ForegroundColor Yellow
           
Get-ADGroupMember "$Group1" | ForEach-Object {

 Add-ADGroupMember -Identity "$Group2" -Members $_

#  Remove-ADGroupMember -Identity "$Group1" -Members $_

}
