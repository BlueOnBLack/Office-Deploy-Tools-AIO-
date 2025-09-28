# powershell catch exception codes for wmi query
# https://stackoverflow.com/questions/29923588/powershell-catch-exception-codes-for-wmi-query

# gwim ... gcim ... maybe i change it later ...
# gwmi is much better, GetPropertyValue, method invoke .. etc

if ($Args[0] -eq '/QUERY_BASIC') {
 $class = $Args[2];
 $value = @($Args[1]).Replace(' ','')
 $wmi_Object = gwmi -Query "select $($value) from $($class)" -ErrorAction SilentlyContinue
 if (-not $wmi_Object) { 
   return "Error:WMI_SEARCH_FAILURE" 
 }
 foreach ($item in $wmi_Object) {
  $line = '';
  $value.Split(",")|%{$line += ",$($item.GetPropertyValue("$_"))"}
  Write-Host $line
 }
 return
}

if ($Args[0] -eq '/QUERY_ADVENCED') {
 $class  = $Args[2];
 $filter = $Args[3];
 $value  = @($Args[1]).Replace(' ','')
 $wmi_Object = gwmi -Query "select $($value) from $($class) where ($($filter))" -ErrorAction SilentlyContinue
 if (-not $wmi_Object) { 
   return "Error:WMI_SEARCH_FAILURE" 
 }
 foreach ($item in $wmi_Object) {
  $line = '';
  $value.Split(",")|%{$line += ",$($item.GetPropertyValue("$_"))"}
  Write-Host $line
 }
 return
}

if ($Args[0] -eq '/ACTIVATE') {
 $CLASS = $Args[1]
 $ID    = $Args[2]
 $ErrorActionPreference = "Stop"
  try {
   Invoke-CimMethod -MethodName Activate -Query "select * from $($CLASS) where ID='$($ID)'"
   return "Error:0"
 }
 catch {
  # return wmi last error, in hex format
  $HResult = ‘{0:x}’ -f  @($_.Exception.InnerException).HResult
  return "Error:$($HResult)"
 }
}

if ($Args[0] -eq '/UninstallProductKey') {
 $CLASS  = $Args[1]
 $FILTER = $Args[2]

 try {
   Invoke-CimMethod -MethodName UninstallProductKey -Query "select * from $($CLASS) where ($($FILTER))"
   return "Error:0"
  }
 catch {
   # return wmi last error, in hex format
   $HResult = ‘{0:x}’ -f  @($_.Exception.InnerException).HResult
   return "Error:$($HResult)"
 }
}

if ($Args[0] -eq '/InstallProductKey') {
 $KEY  = $Args[1]
 $ErrorActionPreference = "Stop"

 try {
  Invoke-CimMethod -MethodName InstallProductKey -Query "select * from SoftwareLicensingService" -Arguments @{ProductKey=$KEY}
  return "Error:0"
 }
 catch {
  # return wmi last error, in hex format
  $HResult = ‘{0:x}’ -f  @($_.Exception.InnerException).HResult
  return "Error:$($HResult)"
 }
}

if ($Args[0] -eq '/InstallLicense') {
 $LicenseFile      = $Args[1]
 $ErrorActionPreference = "Stop"
 
 if([System.IO.File]::Exists($LicenseFile)-ne $true) {
	return "Error:FILE_NOT_FOUND"
 }

 try {
  Invoke-CimMethod -MethodName InstallLicense -Query "select * from SoftwareLicensingService" -Arguments @{License="$([System.IO.File]::ReadAllText($LicenseFile))"}
  return "Error:0"
 }
 catch {
  # return wmi last error, in hex format
  $HResult = ‘{0:x}’ -f  @($_.Exception.InnerException).HResult
  return "Error:$($HResult)"
 }
}

return $null



# SIG # Begin signature block
# MIIFoQYJKoZIhvcNAQcCoIIFkjCCBY4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUuB7YA5XLtUoS+R1/Y8ul2u2C
# kRagggM2MIIDMjCCAhqgAwIBAgIQSe49BypwLKhOHkzMeRKLBzANBgkqhkiG9w0B
# AQsFADAgMR4wHAYDVQQDDBVhZG1pbkBvZmZpY2VydG9vbC5vcmcwHhcNMjQwMTA2
# MTYxMjI3WhcNMzAwMTA2MTYyMjI3WjAgMR4wHAYDVQQDDBVhZG1pbkBvZmZpY2Vy
# dG9vbC5vcmcwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDLZq+Rmrz4
# wwNvgAZVzvbOmj1RlUll7htG/vIJurDabWNvIbYBxycLrzEAJKeuuO8TTtodlhCF
# kvCtzO2gU47wKwqoIK9p5orB9f0xasuxtu7EeIRvXZLpBjKQ20Fnzed6peoPupEb
# 5+2FIjAbM3ErtSbmC7XDhSLhAheV8+Urio/vv7zhiI0JYsfKtcZnbFBG8h5WOoYS
# k7vEF6nW4OleuM6oGuprq7OWDYGLa9sarX8mjNu0CPDgvxoE6vAiOY6lXgT9GoSn
# EOgpn8OOhpBp9ERPzP6Qq6qetl/+wYGkYbQGz7v6fPDQ4ATnGFIfc9G+qICE8iZs
# TV+bgDYjyMUJAgMBAAGjaDBmMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggr
# BgEFBQcDAzAgBgNVHREEGTAXghVhZG1pbkBvZmZpY2VydG9vbC5vcmcwHQYDVR0O
# BBYEFDIRoZpOPb0eh3mSqlUpHSSgioiqMA0GCSqGSIb3DQEBCwUAA4IBAQCe7S09
# 5VqCa9rw0s6FdNqvHOftRgRf1or04i7ZuV3jffN/rValXj8O7GtTRQ9ZFhGInjZ/
# 5UVyLPnhVqVwWzNpqFgTL5/Y0joFQ99GQfv1f5UUt6U4jNjjSTZNdVa3C9iwV4IQ
# jaRhGEQqsvqsOadezbX9jlIpXBKxmua70/cUj8Ub0UBT+jrt3ztqsX/Ei/wrorbh
# 8qS1rgYmi493hgQgKxSG/7tZ5PvbljEO5KPEMagKF6u4XX1B7Mz0DQAJcFUnTsNy
# D/Tj8nc03aYnF8NRkUyRYPhbIgpiY9e7/ivBY+4gF20ONc1Cy8+zqgSn17mF1QTD
# TOzL7jtV+7ROPKxOMYIB1TCCAdECAQEwNDAgMR4wHAYDVQQDDBVhZG1pbkBvZmZp
# Y2VydG9vbC5vcmcCEEnuPQcqcCyoTh5MzHkSiwcwCQYFKw4DAhoFAKB4MBgGCisG
# AQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFKiH
# ITlFiIeOQZzi8A5hAyoKk/S5MA0GCSqGSIb3DQEBAQUABIIBAMYXZZcU8JqbX89s
# uuAG125SHscfGZ3iBBBgE3WCJgy6ZBAXnVeOMXlafLmPk1LwXKBYMY9Ozu4XTolP
# A1Txak9K7nnr/sX8hwu9ek1h8cRbttGuDxqHC2FpQGIfa6XlWeANvx5X2bSgwvdq
# mvAuZzWySwipsyh0PyOslvFW4onJtkZUFIzesMbb7N3hb9I5FdFHGmX36Y3eTpl4
# qsTl/aS6+MBFQwxnZbuvyeaNWUGwQ+HsLvl22ZSWMWyrgCf/mXGQQthFkbygzccj
# I8EQC3lzdLDsbOLvWYH6vaNoD+4jAqIhXtW19l9sQcAhbZUt9e30cgukCG2cIdpC
# 8L3gG+8=
# SIG # End signature block
