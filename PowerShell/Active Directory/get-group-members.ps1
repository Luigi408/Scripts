cls

Import-Module ActiveDirectory

#change the path where you want to save your csv file. Don't forget the .csv at the end of the path.

$Path = '\ad.cuda-inc.com\dfs\IT\Windows System Admin\Powershell\Audit\Output\GetGroupMembers-EnabledorDisabled.csv'


#Script

$gc = "ad.cuda-inc.com:3268"

$domains = (Get-ADForest).Domains

           Write-Host "Type the group name to check (" -ForegroundColor Yellow -NoNewline

           Write-Host "Tip: to search ALL users enter " -ForegroundColor Gray -NoNewline

           Write-Host "Domain Users" -ForegroundColor Red -NoNewline

           Write-Host ")" -ForegroundColor Yellow -NoNewline

           Write-Host ": " -ForegroundColor Yellow -NoNewline

$GroupName = Read-Host

           Write-Host "Users enabled? Enter " -ForegroundColor Yellow -NoNewline

           Write-Host "true " -ForegroundColor Red -NoNewline

           Write-Host "or " -ForegroundColor Yellow -NoNewline

           Write-Host "false" -ForegroundColor Red -NoNewline

           Write-Host ": " -ForegroundColor Yellow -NoNewline

$Status = Read-Host

           Write-Host "Getting Group Members. Please wait..." -ForegroundColor Green

$results =  try {

           foreach ($domain in $domains){

           get-adgroupmember -server $domain $GroupName -recursive |

           Where-Object { $_.objectClass -eq 'user' } |

           Get-ADUser -Server $gc -Properties * |

           Select name,samaccountname,department,title,mail,@{name="manager";e={get-aduser $_.manager | select -ExpandProperty name}},@{Name="office";Expression={$_.physicalDeliveryOfficeName}},Enabled,lastLogonDate | sort name |

           Where-Object {$_.Enabled -match $Status}

           }

           }

           catch {

             

           }

           

           $Results

           $Results = $Results | Select-Object -Property Name, samaccountname, department, title, mail, manager, office, Enabled, lastLogonDate | Export-Csv -path $Path -NoTypeInformation -NoClobber
