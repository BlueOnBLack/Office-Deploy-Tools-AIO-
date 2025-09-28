try {
  Set-Location "$env:ProgramFiles\Microsoft Office\root\Licenses16" }
catch {
  return }

$LicensingService = gwmi SoftwareLicensingService -ea 1
if (-not $LicensingService) {
  return }

$loc = (Get-Location).Path
dir * -Name | ogv -Title "License installer - Helper" -OutputMode Multiple | % {
  $LicenseFile = Join-Path $loc $_
  Write-Host
  "Install License: $($LicenseFile)"
  Write-Host
  $LicensingService.InstallLicense(
    [IO.FILE]::ReadAllText($LicenseFile))
}

pause
exit