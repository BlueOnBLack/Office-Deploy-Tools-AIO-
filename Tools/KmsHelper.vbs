
if WScript.Arguments.Item(0)="/QUERY_BASIC" Then

	on error resume next
    strQuery = "Select " + WScript.Arguments(1) + " from " + WScript.Arguments(2)
	Set objArray= GetObject("winmgmts:\\.\root\CIMV2").ExecQuery(strQuery,,48)
    For each obj in objArray
		result = ","
		For each Prop in obj.Properties_
			result = result & Prop.Value & ","
        Next
		if NOT result = "," Then
			WScript.Echo result
		end if
    Next
	
ElseIf WScript.Arguments.Item(0)="/QUERY_ADVENCED" Then

	on error resume next
    strQuery = "Select " + WScript.Arguments(1) + " from " + WScript.Arguments(2) + " where " + WScript.Arguments(3)
	Set objArray= GetObject("winmgmts:\\.\root\CIMV2").ExecQuery(strQuery,,48)
    For each obj in objArray
		result = ","
		For each Prop in obj.Properties_
			result = result & Prop.Value & ","
        Next
		if NOT result = "," Then
			WScript.Echo result
		end if
    Next
	
ElseIf WScript.Arguments.Item(0)="/ACTIVATE" Then
	
	' New methood Provided by abbodi1406
	on error resume next
	INSTANCE_ID="winmgmts:\\.\root\CIMV2:" + WScript.Arguments.Item(1) + ".ID='" + WScript.Arguments(2) + "'"
	GetObject(INSTANCE_ID).Activate()
	
	' To Err Is VBScript – Part 1
	' https://docs.microsoft.com/en-us/previous-versions/tn-archive/ee692852(v=technet.10)?redirectedfrom=MSDN
	
	WScript.Echo "Error:" & Hex(Err.Number)
	Err.Clear

ElseIf WScript.Arguments.Item(0)="/UninstallProductKey" Then

	on error resume next
	strQuery = "Select * from " + WScript.Arguments(1) + " Where " + WScript.Arguments(2)
	Set objArray= GetObject("winmgmts:\\.\root\CIMV2").ExecQuery(strQuery,,48)
	For each obj in objArray
		WScript.Echo "Uninstall Product :: " + obj.Name
		obj.UninstallProductKey()
	Next
	
ElseIf WScript.Arguments.Item(0)="/QUERY_INVOKE" Then
	
	' this is test methood
	' need to check.
	' how it work
	
	on error resume next
	strQuery = "Select * from " + WScript.Arguments(1) + " Where " + WScript.Arguments(2)
	Set objArray= GetObject("winmgmts:\\.\root\CIMV2").ExecQuery(strQuery,,48)
	For each obj in objArray
		obj.ExecMethod(WScript.Arguments(3))
	Next
	
End If
'' SIG '' Begin signature block
'' SIG '' MIIFnwYJKoZIhvcNAQcCoIIFkDCCBYwCAQExCzAJBgUr
'' SIG '' DgMCGgUAMGcGCisGAQQBgjcCAQSgWTBXMDIGCisGAQQB
'' SIG '' gjcCAR4wJAIBAQQQTvApFpkntU2P5azhDxfrqwIBAAIB
'' SIG '' AAIBAAIBAAIBADAhMAkGBSsOAwIaBQAEFPzNzA8cHO23
'' SIG '' iMUy5DvQT+Prs/unoIIDNjCCAzIwggIaoAMCAQICEEnu
'' SIG '' PQcqcCyoTh5MzHkSiwcwDQYJKoZIhvcNAQELBQAwIDEe
'' SIG '' MBwGA1UEAwwVYWRtaW5Ab2ZmaWNlcnRvb2wub3JnMB4X
'' SIG '' DTI0MDEwNjE2MTIyN1oXDTMwMDEwNjE2MjIyN1owIDEe
'' SIG '' MBwGA1UEAwwVYWRtaW5Ab2ZmaWNlcnRvb2wub3JnMIIB
'' SIG '' IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy2av
'' SIG '' kZq8+MMDb4AGVc72zpo9UZVJZe4bRv7yCbqw2m1jbyG2
'' SIG '' AccnC68xACSnrrjvE07aHZYQhZLwrcztoFOO8CsKqCCv
'' SIG '' aeaKwfX9MWrLsbbuxHiEb12S6QYykNtBZ83neqXqD7qR
'' SIG '' G+fthSIwGzNxK7Um5gu1w4Ui4QIXlfPlK4qP77+84YiN
'' SIG '' CWLHyrXGZ2xQRvIeVjqGEpO7xBep1uDpXrjOqBrqa6uz
'' SIG '' lg2Bi2vbGq1/JozbtAjw4L8aBOrwIjmOpV4E/RqEpxDo
'' SIG '' KZ/DjoaQafRET8z+kKuqnrZf/sGBpGG0Bs+7+nzw0OAE
'' SIG '' 5xhSH3PRvqiAhPImbE1fm4A2I8jFCQIDAQABo2gwZjAO
'' SIG '' BgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUH
'' SIG '' AwMwIAYDVR0RBBkwF4IVYWRtaW5Ab2ZmaWNlcnRvb2wu
'' SIG '' b3JnMB0GA1UdDgQWBBQyEaGaTj29Hod5kqpVKR0koIqI
'' SIG '' qjANBgkqhkiG9w0BAQsFAAOCAQEAnu0tPeVagmva8NLO
'' SIG '' hXTarxzn7UYEX9aK9OIu2bld433zf61WpV4/DuxrU0UP
'' SIG '' WRYRiJ42f+VFciz54ValcFszaahYEy+f2NI6BUPfRkH7
'' SIG '' 9X+VFLelOIzY40k2TXVWtwvYsFeCEI2kYRhEKrL6rDmn
'' SIG '' Xs21/Y5SKVwSsZrmu9P3FI/FG9FAU/o67d87arF/xIv8
'' SIG '' K6K24fKkta4GJouPd4YEICsUhv+7WeT725YxDuSjxDGo
'' SIG '' CheruF19QezM9A0ACXBVJ07Dcg/04/J3NN2mJxfDUZFM
'' SIG '' kWD4WyIKYmPXu/4rwWPuIBdtDjXNQsvPs6oEp9e5hdUE
'' SIG '' w0zsy+47Vfu0TjysTjGCAdUwggHRAgEBMDQwIDEeMBwG
'' SIG '' A1UEAwwVYWRtaW5Ab2ZmaWNlcnRvb2wub3JnAhBJ7j0H
'' SIG '' KnAsqE4eTMx5EosHMAkGBSsOAwIaBQCgeDAYBgorBgEE
'' SIG '' AYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEM
'' SIG '' BgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgor
'' SIG '' BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRp4UYi9e02
'' SIG '' xdp45TuWQObHQIfg8DANBgkqhkiG9w0BAQEFAASCAQB7
'' SIG '' JhwcD4i9o8uHuEqdi8bB8rRdsKw67UjOqorSnFQQBGN+
'' SIG '' O/Nao4J0AMT2dc4cYvT8tC5XJWlEJMXHifsLRjuXs3Nq
'' SIG '' 0gRuKT/GFrwNOzo0YOiwGViEBbIX4aUARrWtZkHGmxd4
'' SIG '' m+j2GHT0CMkABEEFZv3Tc4quI1ZECSdWmVwqN4spFvDj
'' SIG '' 6PvLH4HmU9NrfbauEnZBnFbtrv1bDZlpyz/3uBg9Eq6H
'' SIG '' 5gkK4qtW56eyKTbYTFN/a5vKIl/Ved9RWiV80LdM7OiG
'' SIG '' 0FvmrO5y1DBINr7uWWJyLEQuC57PNG4bH3GiGRVh71ur
'' SIG '' mMX5FllprgxfMpc0N4qTEm5v8W3M9U0v
'' SIG '' End signature block
