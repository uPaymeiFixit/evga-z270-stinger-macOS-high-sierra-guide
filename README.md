![img_20170917_020151](https://user-images.githubusercontent.com/1683528/30621820-3f35d7b6-9d62-11e7-9b85-1957c73bbfdb.png)

# High Sierra Hackintosh Guide for EVGA Z270 Stinger (200 series)
A guide for installing macOS High Sierra on an EVGA Z270 Stinger motherboard and i7-7700k with OpenCore

This guide will show you how to install **macOS High Sierra 10.13.6** on a desktop running an EVGA Z270 Stinger motherboard. There are no changes made to the operating system partition, resulting in a very *vanilla* and therefore upgradable experience. This guide uses the OpenCore bootloader instead of Clover. This is important to know when diagnosing problems. For best results, use the hardware listed below.

## Hardware
- [EVGA Z270 Stinger (111-KS-E272-KR)](https://www.evga.com/products/product.aspx?pn=111-KS-E272-KR)
- [i7-7700k](https://ark.intel.com/products/97129/Intel-Core-i7-7700K-Processor-8M-Cache-up-to-4_50-GHz)
- [EVGA GTX 1080 Ti SC2](https://www.evga.com/products/product.aspx?pn=11G-P4-6593-RX)
- [Samsung 960 EVO NVMe M.2 500GB](http://www.samsung.com/us/computing/memory-storage/solid-state-drives/ssd-960-evo-m-2-500gb-mz-v6e500bw/)

[View on PC Part Picker](https://pcpartpicker.com/b/ycMZxr)

**Note:** This guide may need to be tweaked for similar hardware, such as any other 200 series motherboard. Any (or no) NVMe drive, any Kaby Lake CPU, and any GPU will likely work as is. I won't go into too much detail on this guide as there will be more relevant and up-to-date information for your specific machine. The [OpenCore vanilla guide](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/) is a great resource, albeit rather long. Your main takeaway from this should be that the focus is 100% on the bootloader / EFI folder. No monifications need be made to macOS other than installing the Nvidia Web Drivers. 

## What works
- [x] GPU hardware acceleration
- [x] — Metal Support
- [x] NVMe
- [x] — TRIM Support
- [x] Hardware sensors
- [x] Audio
- [x] — All 5 analog in/out ports
- [x] Ethernet
- [x] Sleep
- [x] — Enters low power mode
- [x] — Audio wakes up
- [x] — Ethernet wakes up
- [x] — Video wakes up
- [x] Shutdown
- [x] — Stays shut down
- [x] — CMOS does not reset
- [x] USB
- [x] — USB 3.0
- [x] — USB 3.1
- [x] — USB-C
- [x] Bluetooth
- [x] Accurate External / Internal drive icons
- [x] HDCP
- [x] NVRAM
- [x] - Bootcamp (Startup disk selection)
- [x] - iMessage / Facetime

## What doesn't work
- [x] Audio
- [x] — HDMI Audio (only one port works)
- [ ] Power button
- [ ] Wi-Fi (AW-CB210NF-P)

# Instructions
## Step 1: Create Installer
Insert a flash drive and rename it `DELETE`. (**IMPORTANT**: The drive and everything on it will be erased.)
Then open a terminal (*/Applications/Utilites/Terminal.app*) and copy and paste the following:  

```
bash <(curl -s https://raw.githubusercontent.com/uPaymeiFixit/evga-z270-stinger-macOS-high-sierra-guide/master/high-sierra-media-creation-tool.command)
```

![rename](https://user-images.githubusercontent.com/1683528/77610004-bfed0c80-6ede-11ea-95cf-2f2efbc7b0cb.gif)

### How does it work? (you don't have to read this)
If you're reading this, that's good. You probably understand that running a script blindly (and with root permissions) can be extremely dangerous. Only run these types of scripts if you trust the author. I'll explain how it works so you can better dig through yourself. 

This step is usually broken up into downloading macOS, preparing the install media, and installing the bootloader. I wrote a quick script to do all of this in one step.

The first thing this script does is partition the disk who has a volume named `DELETE`

```
diskutil partitionDisk /dev/`diskutil info "DELETE" | grep "Part of Whole:" | tail -c 6` GPT JHFS+ "DELETE" 100%
```

After we've formatted the drive the script downloads macOS High Sierra straight from Apple's CDN. The os is broken up into many different files, so we have to download them all.

```
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/BaseSystem.chunklist
...
wget http://swcdn.apple.com/content/downloads/06/50/041-91758-A_M8T44LH2AW/b5r4og05fhbgatve4agwy4kgkzv07mdid9/InstallInfo.plist
```

Next we download CorpNewt's [gibMacOS](https://github.com/corpnewt/gibMacOS) utility and use it to compile the files we just downloaded into *Install macOS High Sierra.app*. This is not my script, and I don't know how it works, but I'm glad it exists and I trust it because it doesn't ask for any elevated permissions and we're only downloading an archived version, so nothing new and malicious can be added. 

```
wget https://github.com/corpnewt/gibMacOS/archive/c2e45ce568069d0dce027ec84d9c1ed8bbad2e21.zip
...
echo "high-sierra-files" | ./gibMacOS-c2e45ce568069d0dce027ec84d9c1ed8bbad2e21/BuildmacOSInstallApp.command
```

Now we download my repository containing my EFI folder.

```
wget https://github.com/uPaymeiFixit/evga-z270-stinger-hackintosh-guide/archive/master.zip
```

Next we find the volume named `Install macOS High Sierra` and mount the EFI partition, then copy my EFI folder to it.

```
diskutil mount "`diskutil info "Install macOS High Sierra" | grep "Part of Whole:" | tail -c 6`s1"
...
cp -a evga-z270-stinger-hackintosh-guide-master/EFI /Volumes/EFI/
```

That's it! You should now have a flash drive that can boot a macOS installer. For the most part that creates your entire hackintosh, and if you're using all of the hardware I'm using you shouldn't run into any problems. If you do run into problems, most can be solved by tweaking the config.plist in the EFI partition. I would recommend you take a look at the [Kaby Lake OpenCore configuration](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/intel-config.plist/kaby-lake) to start.


## Step 2: Conigure BIOS
During boot, press `F2` or `DEL` to enter BIOS.

The most important thing is that you disable CSM. Navigate to the *BOOT* tab and then into *CSM Configuration*. Set *CSM Support* to *Disabled*

![csm_support](https://user-images.githubusercontent.com/1683528/77609620-aeefcb80-6edd-11ea-9fcb-e07862d2a243.jpg)

If you run into problems, disable VT-d. While it's commonly recommended you disable this, it actually seemed to break sleep on my machine so I have it enabled. You can find this setting in the *ADVANCED* tab and then click on *CPU Configuration*. Set *Intel(R) Virtualization Technology For Directed I/O* to *Disabled*.

![advanced](https://user-images.githubusercontent.com/1683528/77609748-1574e980-6ede-11ea-81dd-bc830d7542e1.jpg)
![virtualization](https://user-images.githubusercontent.com/1683528/77609757-186fda00-6ede-11ea-9b3e-c147b602d7ce.jpg)

Also make sure at least one of your Boot Options is set to USB Key or USB Hard Disk so you can boot from your flash drive.
![boot](https://user-images.githubusercontent.com/1683528/77609758-19087080-6ede-11ea-85de-1ddc20b0c5a7.jpg)

Now press F10 to save and exit setup, then boot from the flash drive. (You may have to manually select this boot device from the BIOS if it doesn't boot from it automatically.

## Step 3: Install macOS
Boot the computer with the flash drive plugged in, and if all goes well after a while you should be greeted with the macOS installer screen. Go through the installation normally. When the two part installer finishes boot the computer one more time with the flash drive still plugged in. 

Note: You may need to hold down option / alt while booting to pick your new macOS installation if it keeps booting to the installer.

![installer](https://user-images.githubusercontent.com/1683528/77609869-62f15680-6ede-11ea-890a-79ca832e5f42.png)

## Step 4: Post Install
### OpenCore Bootloader
Now we can boot from the flash drive, but if we want to remove the flash drive we'll need to copy the bootloader from it to our local disk. If all went well you should be able to just copy the EFI folder from your install media to your macOS drive. Could I have made a script for this? Yes, but it's difficult to get the booted drive identifier and I'm pretty sure I'm the only person who is ever going to read this. But let me know if I'm wrong and this helped you.

The first thing we need to do is identify our EFI partitions. Open a terminal again and type `diskutil list`. This should give you an output similar (but probably not identicle) to my screenshot below. 

![diskutil_list](https://user-images.githubusercontent.com/1683528/77609922-8a482380-6ede-11ea-92ee-bb8f412f7cc1.png)

The first drive we want to identify and mount is the flash drive you used to install with. It should be named `Install macOS High Sierra`. In my case that's `disk4`, and the EFI partition on that disk is `1`. Type the following command being very careful to replace the 4 and 1 with your corrosponding disk and partition identifiers. 

```
sudo diskutil mount disk4s1
```

Now we want to do the same for the EFI partiton on our local disk. This one can be tricky because APFS does this weird thing where it creates another synthesized disk which is where your OS lives, but not the EFI folder we want to mount. That's the case with mine. As you can see my `macOS` partition is disk1s1 but the corrosponding EFI partition is actually on disk0s1. We will mount it the same way.

```
sudo diskutil mount disk0s1
```

![diskutil_mount](https://user-images.githubusercontent.com/1683528/77609926-8b795080-6ede-11ea-9288-15a9e5d8d11a.png)

Now we'll copy the EFI folder from the flash drive's EFI partiton to our local disk's EFI partition. You can do this manually or paste the following in the terminal.

```
sudo cp -a /Volumes/EFI/EFI /Volumes/EFI\ 1/
```

Done! You should be able to boot without the flash drive now.

### Nvidia Web Drivers
If you have an Nvidia card you may need to install the Nvidia Web Drivers to get accelerated graphics. You'll know if your graphics aren't accelerated. Annimations will be very weird and the dock won't be transparent. My favorite way to do this is to use Benjamin Dobell's [nvidia-update](https://github.com/Benjamin-Dobell/nvidia-update) script by copying and pasting the script below into a terminal:

```
bash <(curl -s https://raw.githubusercontent.com/Benjamin-Dobell/nvidia-update/master/nvidia-update.sh)
```


# Kexts / Patches / Sources / Credits
- [OpenCore](https://github.com/acidanthera/OpenCorePkg) from Acidanthera and others
- [gibMacOS](https://github.com/corpnewt/gibMacOS) from CorpNewt
- [nvidia-update](https://github.com/Benjamin-Dobell/nvidia-update) from Benjamin Dobell
- [HDMIAudio.kext](https://github.com/toleda/audio_CloverHDMI) from Toleda
- [IntelMausiEthernet.kext](https://github.com/Mieze/IntelMausiEthernet) from Mieze
- [Lilu.kext](https://github.com/vit9696/Lilu) from vit9696
- [AppleALC.kext](https://github.com/vit9696/AppleALC/releases) from vit9696
