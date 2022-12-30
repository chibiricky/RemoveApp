Param(
	[string] $App,
	[string] $PC,
	[string] $File
)

""

$PCs = @()

if ($File -ne "") {
	$Lines = Get-Content $File
	foreach ($Line in $Lines) {
		if ($Line -ne "") {
			$PCs += $Line
		}
	}
} else {
	if ($PC -ne "") {
		$PCs += $PC
	} else {
		Write-Host "Please specify either PC or File in the parameters" -ForegroundColor Red
		exit
	}
}

foreach ($CurPC in $PCs) {

	if (Test-Connection $CurPC -Quiet -Count 2) {
		Write-Host "$CurPC is online. Querying applications...`r`n"
	} else {
		Write-Host "$CurPC is offline" -ForegroundColor Red
		continue
	}

	$Products = Get-WmiObject -Class Win32_Product -ComputerName $CurPC | Where-Object name -like $App

	Write-Host "$(@($Products).Count) applications found:"
	Write-Host "$(@($Products.name) -join "`r`n")"
	""

	foreach ($Product in $Products) {
		if((Read-Host "Remove $($Product.name) from $CurPC`? (y/N)") -eq 'y') {
			$Result = $Product.uninstall().ReturnValue
			if($Result -eq 0) {
				Write-Host "$($Product.Name) has been uninstalled from $CurPC successfully" -ForegroundColor Green
			} else {
				Write-Host "$($Product.Name) could not be uninstalled from $CurPC" -ForegroundColor Red
			}
		}

	}
	if(@($Products).Count -eq 0) {
		"No applications that match the search string $App on $CurPC"
	}

}

""
