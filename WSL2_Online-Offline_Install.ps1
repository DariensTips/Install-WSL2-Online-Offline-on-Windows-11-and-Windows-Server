$transFolderLoc="c:\temp\offlinetransfers"
New-Item -ItemType Directory -Path $transFolderLoc 
Robocopy.exe d:\ $transFolderLoc /R:1 /W:1 * /NODCOPY
Rename-Item $transFolderLoc\Ubuntu_1804.2019.522.0_x64.appx $transFolderLoc\Ubuntu_1804.2019.522.0_x64.appx.zip
Start-Process -FilePath $transFolderLoc\wsl.2.6.1.0.x64.msi
# Windows 10/11
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all
# Windows Server 2022/2025 (including Server Core)
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

## Restart computer ##

$transFolderLoc="c:\temp\offlinetransfers"
$wslDestDistroPath = "$env:userprofile\wsl2distributions"
Expand-Archive -Path $transFolderLoc\Ubuntu_1804.2019.522.0_x64.appx.zip -DestinationPath $wslDestDistroPath\ubuntu1804
Get-ChildItem $wslDestDistroPath\ubuntu1804
Start-Process -FilePath $wslDestDistroPath\ubuntu1804\ubuntu1804.exe


# Tar Install

$transFolderLoc="c:\temp\offlinetransfers"
$wslDestDistroPath = "$env:userprofile\wsl2distributions"
Rename-Item $transFolderLoc\rhel-10.0-x86_64-wsl2.tar.gz $transFolderLoc\rhel-10.0-x86_64-wsl2.tar.gz.wsl
wsl --install --name rhel10 --from-file $transFolderLoc\rhel-10.0-x86_64-wsl2.tar.gz.wsl --location $wslDestDistroPath\rhel10


# Tar Import
$transFolderLoc="c:\temp\offlinetransfers"
$wslDestDistroPath = "$env:userprofile\wsl2distributions"
wsl --import rhel10 $wslDestDistroPath\rhel10 $transFolderLoc\rhel-10.0-x86_64-wsl2.tar.gz --version 2


Get-ComputerInfo WindowsProductName,OSDisplayVersion,WindowsInstallationType,CsName,OsVersion | fl


# create user (this happens inside the WSL distro using bash)
#### THIS IS BASH ####
    myWSLUsername=subscribe
    adduser -G wheel $myWSLUsername
    echo -e "\n[user]\ndefault=$myWSLUsername" >> /etc/wsl.conf
    passwd $myWSLUsername

    sudo apt update && sudo apt upgrade
    sudo apt install openscad
    openscad
######################
