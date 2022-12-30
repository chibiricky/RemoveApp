Param(
	[string] $App,
	[string] $PC
)

""

if (Test-Connection $PC -Quiet -Count 2) {
	Write-Host "$PC is online. Querying applications...`r`n"
} else {
	Write-Host "$PC is offline" -ForegroundColor Red
	exit
}

$Products = Get-WmiObject -Class Win32_Product -ComputerName $PC | Where-Object name -like $App

	Write-Host "$(@($Products).Count) applications found:"
	Write-Host "$(@($Products.name) -join "`r`n")"
	""

	foreach ($Product in $Products) {
		if((Read-Host "Remove $($Product.name) from $PC`? (y/N)") -eq 'y') {
			$Result = $Product.uninstall().ReturnValue
			if($Result -eq 0) {
				Write-Host "$($Product.Name) has been uninstalled successfully" -ForegroundColor Green
			} else {
				Write-Host "$($Product.Name) could not be uninstalled from $PC" -ForegroundColor Red
			}
		}

	}
	if(@($Products).Count -eq 0) {
		"No applications that match the search string $App on $PC"
	}

	""