# Certificate Stores
# certmgr.msc => Personal => Certificates ...

# How do I create a self-signed certificate for code signing on Windows?
# https://stackoverflow.com/questions/84847/how-do-i-create-a-self-signed-certificate-for-code-signing-on-windows/51443366#51443366

cls
Write-Host

if (-not (
  [Security.Principal.WindowsIdentity]::GetCurrent().Groups | ? Value -match "S-1-5-32-544")) {
  write-host
  "Make sure to run this script as Administrator"
  write-host
  pause
  [Environment]::Exit(1)
}

$files       = Get-ChildItem -Recurse
$Pattern     = "^(.)(ps1|vbs|exe|dll)$"
$case        = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
$certificate = "C:\windows\code_signing.crt"
$Thumbprint  = (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert)

if (-not $Thumbprint) {
  New-SelfSignedCertificate -DnsName admin@officertool.org -Type CodeSigning -CertStoreLocation cert:\CurrentUser\My -NotAfter (Get-Date).AddYears(6)
  Export-Certificate -Cert (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert)[0] -FilePath $certificate
  certutil -addstore -f "root" $certificate
  certutil -addstore -f "TrustedPublisher" $certificate

  # send ... annoying pop-up ... LOL
  #Import-Certificate -FilePath C:\windows\code_signing.crt -Cert Cert:\CurrentUser\TrustedPublisher -ErrorAction Stop
  #Import-Certificate -FilePath C:\windows\code_signing.crt -Cert Cert:\CurrentUser\Root -ErrorAction Stop

  $Thumbprint = (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert)
  if (-not $Thumbprint) {
	  throw "ERROR :: Failed to create Fake Certificate"
	  return
  }
}

$files|?{[REGEX]::IsMatch($_.Extension,$Pattern,$case)}|%{Set-AuthenticodeSignature $_.FullName -Certificate $Thumbprint[0] -Force -ErrorAction SilentlyContinue -Verbose }
Write-Host
Pause
return

# SIG # Begin signature block
# MIIFoQYJKoZIhvcNAQcCoIIFkjCCBY4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUiAensuatfxSUeC8gVy3/ZUTf
# ZXegggM2MIIDMjCCAhqgAwIBAgIQSe49BypwLKhOHkzMeRKLBzANBgkqhkiG9w0B
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
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFHit
# vL3+Tn9lsdqVVbNAv2EJiGxiMA0GCSqGSIb3DQEBAQUABIIBAMfSJlhlT6vKX9YY
# neAehH2xPawQFXKrFI69fg3pLXR4KrZjnq13Oeahhx+yflumdJ4UIe4E1ELZkRN2
# 7eUvq2OPOQl6qMnoLCbYcz+gYLF+dzx8heBjuam/W6loTzJSwLE6x23bp5N/cKBY
# M1DCG9S51TjGAeaPgC3Mn7cS94MRAPjSfHKu/DEa86r7hV4NAgaDrClAS5oevm6/
# qMFBdKu2HNoODg/CYoBAYfj5WApLdC4l7WH6n40Ve5R2FgFEvF+H4jQVnt1vqhEu
# L7vX53smX64kBF1ic5D15pmWAEUD7kIQ2npLXAlOfpq1vbVt/DEU9X6XIh/wOlgf
# NV7Cy00=
# SIG # End signature block
