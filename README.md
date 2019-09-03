# Arch WSL

This is a fork of the reference WSL image builder, configured for my ideal archlinux setup - with WSL2 and [Genie](https://github.com/arkane-systems/genie)!

## Getting Started

1. Set up a signing certificate, easiest via the [`New-SelfSignedCertificate`](https://docs.microsoft.com/en-us/powershell/module/pkiclient/new-selfsignedcertificate?) command. For example:

   ``` powershell
   New-SelfSignedCertificate -Type Custom -Subject "CN=Common Name, O=Organisation, L=Somewhere, C=Country" -KeyUsage DigitalSignature -FriendlyName "Friendly Name" -CertStoreLocation "Cert:\CurrentUser\My" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")
   ```

2. Run `sudo get_rootfs.sh` on an Archlinux host to get `install.tar.gz`, this must be copied to `./x64/install.tar.gz`.

   Note the Archlinux host must have the necessary dependencies:
   - `python-markdown`
   - `arch-install-scripts`

3. Run `build.bat` to get the appx package. You may specify `built.bat rel` to get a release build.

4. Install the package appx package. For example, via powershell:

   ``` powershell
   AppPackages\Arch\Arch_1.0.0.0_x64_Test\Add-AppDevPackage.ps1
   ```

   Note: It seems that powershell core does not like this script.
