#! /bin/sh

# This Script is for Full Mac Deployment for ThatCompany
# September 11, 2018

# Variables

    # General Paths
    LibPref=/Library/Preferences
    BasePath=/Library/ThatCompany
    InstallerPath=/Library/ThatCompany/Software

    #Basic configurations
    Proxy="proxyconfig.sh"
    HomePage="http://thatcompany.com"
    ADUser="deploystudioadmin"
    ADPass="Password"

    #Location of the Directory to copy
    CopyDir=/Volumes/Deployment

    #Software Installation Paths
    OfficeInstall=$InstallerPath/Installer
    Skype=$InstallerPath/Installer
    OfficeUpdate=$InstallerPath/Installer
    McAfeeInstall=$InstallerPath/Installer
    CheckPointInstall=$InstallerPath/Installer
    Vault=$InstallerPath/Installer
    Reader=$InstallerPath/Installer
    Tanium=$InstallerPath/Installer
    InfoSec=$InstallerPath/Installer
    Citrix=$InstallerPath/Installer
    ChromeInstall=$InstallerPath/Installer

# Configure Login Screen

    # Enables fast scripting for login
    defaults write $LibPref/.GlobalPreferences MultipleSessionEnabled -bool Yes 

    # Enables username/passwords on login screen
    defaults write $LibPref/com.apple.loginwindow SHOWFULLNAME -bool Yes
    sleep 2

    # Title info for login screen
    defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Property of ThatCompany - For AUTHORIZED USERS ONLY!"

# Configure Browser Settings

    # Browser Settings
    defaults write $LibPref/com.apple.Safari HomePage $HomePage
    defaults write $LibPref/com.apple.Safari NewWindowBehavior -int 0
    defaults write $LibPref/com.apple.Safari AlwaysRestoreSessionAtLaunch -bool false
    sleep 2

    # Configure Proxy
    # networksetup -setproxyautodiscovery ethernet on
    # networksetup -setautoproxyurl ethernet http://proxy.com
    source $Proxy



# Configure Time/Date

    # Configuring TimeZone
    systemsetup -settimezone "America/Chicago"

    # Configure NTP Server
    systemsetup -setusingnetworktime on -setnetworktimeserver <ntp server>
    sleep 3

# Copy directory to local system

    mkdir /Library/ThatCompany
    cp -rf $CopyDir /Library/ThatCompany

# Configure Desktop
    
    # Desktop Background
    cp -f $BasePath/Pictures /Library/Desktop\ Pictures
    cp -f $BasePath/Pictures/DefaultDesktop.jpg /System/Library/CoreServices
    
    # User Picture
    cp -f $BasePath/Profile/user.png /Library/User\ Pictures/
    dscl . -change /Users/Administrator Picture '/Library/User Pictures/Fun/Gingerbread Man.tif' '/Library/User Pictures/user.png'

# Install Office Packages

    installer -pkg $OfficeInstall -target /
    installer -pkg $Skype -target /
    installer -pkg $OfficeUpdate -target /

# Install Vault

    installer -pkg $Vault -target /

# Install CheckPoint

    installer -pkg $CheckPointInstall -target /

# Install McAfee

    installer -pkg $McAfeee -target /

# Install Adobe Reader

    installer -pkg $Reader -target /

# Install Tanium

    installer -pkg $Tanium -target /
    cp -rf $Tanium /Library/Tanium/TaniumClient

# Install InfoSec Package

    installer -pkg $InfoSec -target /

# Install Citrix Package

    installer -pkg $Citrix -target /

# Install Google Chrome

    cp $ChromeInstall /Applications

# Join to Domain

    dsconfigad -a $HOSTNAME -u $ADUser -p $ADPass -ou "OU=apple,dc=corp,dc=domain,dc=com" -domain <Domain address> -mobile enable -mobileconfirm enable -localhome enable -useuncpath enable -groups "Domain Admins" -alldomains enable 
    dsconfigad -protocol smb
    dsconfigad -packetsign allow
    dsconfigad -packetencrypt ssl

# TODO: Configure Admin Users
