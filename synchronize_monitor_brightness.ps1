
# Brightness corrections to get the alike luminance of laptop and external monitor
$brightnessCorrectionInternalToExternalMaps = @{
		10 = 35;
		20 = 45;
		30 = 53;
		40 = 55;
		50 = 60;
    60 = 65;
}

# Variable to detect brightness changes
$laptopMonitorLastBrightness = 0


while ($true) {
	
	# Access Internal monitor data
	$internalMonitorData = Get-Ciminstance -Namespace root/WMI -ClassName WmiMonitorBrightness
	$laptopMonitorCurrentBrightness = $internalMonitorData.CurrentBrightness

	if ($laptopMonitorLastBrightness -ne $laptopMonitorCurrentBrightness) {

		# Reset brightness change
		$laptopMonitorLastBrightness = $laptopMonitorCurrentBrightness
		
		# Set brightness level to physical changes of luminance
		$externalDellMonitorBrightness = [math]::Round([math]::Sqrt($laptopMonitorCurrentBrightness * 100 ))


		# Apply brightness corrections to get the same luminance of laptop and external monitor
		if ($brightnessCorrectionInternalToExternalMaps.ContainsKey([int]$laptopMonitorCurrentBrightness)) {
			$externalDellMonitorContrast = $brightnessCorrectionInternalToExternalMaps[[int]$laptopMonitorCurrentBrightness]
		}
		else {
			$externalDellMonitorContrast = $laptopMonitorCurrentBrightness
		}


		# Verbose output for user
		Write-Host "Internal screen Brightness $($laptopMonitorCurrentBrightness), External screen Brightness: $($externalDellMonitorBrightness), Contrast: $($externalDellMonitorContrast)"
    & "C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe" /SetBrightnessLevel $externalDellMonitorBrightness /SetContrastLevel $externalDellMonitorContrast
	}
	else {
		Start-Sleep -Seconds 1
	}
}

# Set internal display brigthess manually
# if ($args.count -eq 1) {
# 	$brightness = $args[0]
# 	$delay = 5
# 
# 	$myMonitorWrite = Get-WmiObject -Namespace root\wmi -Class WmiMonitorBrightnessMethods
#	$myMonitorWrite.wmisetbrightness($delay, $brightness)
# }

# Set Dell Monitor Preset by DDM
# & "C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe" /SetNamedPreset Standard /SetBrightnessLevel $externalDellMonitorBrightness /SetContrastLevel $externalDellMonitorContrast

# Run powershell from shortcut
# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -File "C:\Users\<username>\Scripts\synchronize_monitor_brightness.ps1"
# C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "C:\Users\<username>\Scripts\synchronize_monitor_brightness.ps1"

# Shortcut can be copied to autorun folder: Ctrl+R > shell:startup > Run 
