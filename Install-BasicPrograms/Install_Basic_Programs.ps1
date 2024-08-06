function Install-WindowsUpdates {
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    $updates = $updateSearcher.Search("IsInstalled=0")

    Write-Host "(!) Checking and installing Windows updates..."

    if ($updates.Updates.Count -eq 0) {
        Write-Host "`n[!] No updates available."
    } else {
        Write-Host "`n-> Installing $($updates.Updates.Count) Windows updates..."
        $updateDownloader = $updateSession.CreateUpdateDownloader()
        $updateDownloader.Updates = $updates.Updates
        $updateDownloader.Download()

        $updateInstaller = New-Object -ComObject Microsoft.Update.Installer
        $updateInstaller.Updates = $updates.Updates
        $installationResult = $updateInstaller.Install()

        if ($installationResult.ResultCode -eq 2) {
            Write-Host "[!] Updates require a reboot. Restarting the system..."
            Restart-Computer -Force
        } elseif ($installationResult.ResultCode -eq 3) {
            Write-Host "Updates Installed!"
        } else {
            Write-Host "Failed to install updates. Error code: $($installationResult.ResultCode)"
        }
    }
}

function Download {
    Install-WindowsUpdates

    $anyDeskUrl = "https://download.anydesk.com/AnyDesk.exe"
    $javaUrl = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=249535_4d245f941845490c91360409ecffb3b4"
    $chromeUrl = "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi"
    $office365Url = "https://officecdn.microsoft.com/pr/wsus/setup.exe"
    $winrarUrl = "https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-701.exe"
    $ConfigFile = "https://raw.githubusercontent.com/JMoreira2Dev/WindowsManagers/main/Install-BasicPrograms/Configurations.xml"

    $downloadPath = "$env:USERPROFILE\Downloads"

    Write-Host "`n[+] Starting AnyDesk Installation..." 
    Invoke-WebRequest -Uri $anyDeskUrl -OutFile "$downloadPath\AnyDesk.exe" -UseBasicParsing
    Start-Process -FilePath "$downloadPath\AnyDesk.exe" -Wait

    Write-Host "`n[+] Starting Java Installation..."
    Invoke-WebRequest -Uri $javaUrl -OutFile "$downloadPath\java.exe" -UseBasicParsing
    Start-Process -FilePath "$downloadPath\java.exe" -ArgumentList "/s" -Wait

    Write-Host "`n[+] Starting Chrome Browser Installation..."
    Invoke-WebRequest -Uri $chromeUrl -OutFile "$downloadPath\chrome.msi" -UseBasicParsing
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", "$downloadPath\chrome.msi", "/qn", "/L*V", "$downloadPath\chrome_install.log" -Wait

    Write-Host "`n[-] Downloading OFFICE Configuration File..."
    Invoke-WebRequest -Uri $ConfigFile -OutFile "$downloadPath\Configurations.xml" -UseBasicParsing

    Write-Host "`n[+] Starting Office 365 Installation..."
    Invoke-WebRequest -Uri $office365Url -OutFile "$downloadPath\setup.exe" -UseBasicParsing
    Start-Process -FilePath "$downloadPath\setup.exe" -ArgumentList "/Configure $downloadPath\Configurations.xml" -Wait

    Write-Host "`n[+] Finishing with the WinRAR Installation..."
    Invoke-WebRequest -Uri $winrarUrl -OutFile "$downloadPath\winrar-x64-701.exe" -UseBasicParsing
    Start-Process -FilePath "$downloadPath\winrar-x64-701.exe" -Wait

    Write-Host "(!) Cleaning up..."
    Remove-Item "$downloadPath\AnyDesk.exe", "$downloadPath\java.exe", "$downloadPath\chrome.msi", "$downloadPath\chrome_install.log", "$downloadPath\Configurations.xml", "$downloadPath\setup.exe", "$downloadPath\winrar-x64-701.exe" -Force

}

Write-Host "(!) Launching Windows Update..."
Download
