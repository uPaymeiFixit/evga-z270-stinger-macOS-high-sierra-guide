#!/bin/bash
echo "Searching for drive named \"DELETE\" and formatting it"
sudo diskutil partitionDisk /dev/`diskutil info "DELETE" | grep "Part of Whole:" | tail -c 6` GPT JHFS+ "DELETE" 100%

mkdir upaymeifixit-high-sierra-media-creation-tool
cd upaymeifixit-high-sierra-media-creation-tool
mkdir high-sierra-files
cd high-sierra-files

echo "Downloading macOS High Sierra files from Apple's CDN"
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/BaseSystem.chunklist
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/AppleDiagnostics.dmg
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/RecoveryHDMetaDmg.pkg
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/MajorOSInfo.pkg
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/OSInstall.mpkg
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/AppleDiagnostics.chunklist
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/InstallESDDmg.chunklist
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/BaseSystem.dmg
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/InstallAssistantAuto.pkg
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/InstallESDDmg.pkg
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/InstallInfo.plist

cd ..

echo "Downloading  gibMacOS repo"
wget https://github.com/corpnewt/gibMacOS/archive/c2e45ce568069d0dce027ec84d9c1ed8bbad2e21.zip
unzip c2e45ce568069d0dce027ec84d9c1ed8bbad2e21.zip

echo "Compiling macOS High Sierra files into \"Install macOS High Sierra.app\""
echo "high-sierra-files" | ./gibMacOS-c2e45ce568069d0dce027ec84d9c1ed8bbad2e21/BuildmacOSInstallApp.command

echo "Creating install media on volume named \"DELETE\". Volume will now be named \"Install macOS High Sierra\""
sudo ./high-sierra-files/Install\ macOS\ High\ Sierra.app/Contents/Resources/createinstallmedia --nointeraction --volume /Volumes/DELETE

echo "Downloading my repo with EFI folder"
wget https://github.com/uPaymeiFixit/evga-z270-stinger-macOS-high-sierra-guide/archive/master.zip
unzip master.zip

echo "Mounting EFI folder of volume named \"Install macOS High Sierra\""
sudo diskutil mount "`diskutil info "Install macOS High Sierra" | grep "Part of Whole:" | tail -c 6`s1"

echo "Copying my EFI folder to install drive"
sudo cp -a evga-z270-stinger-hackintosh-guide-master/EFI /Volumes/EFI/

echo "Done! Would you like me to delete the installer files we used? (y/n)"
tput bel
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  cd ..
  rm -r upaymeifixit-high-sierra-media-creation-tool
fi
exit
