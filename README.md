# Arch WSL

This is a fork of the reference WSL image builder, configured for my ideal archlinux setup - with WSL2 and [Genie](https://github.com/arkane-systems/genie)!

## Getting Started

1. Set up a signing certificate, easiest via the [`New-SelfSignedCertificate`](https://docs.microsoft.com/en-us/powershell/module/pkiclient/new-selfsignedcertificate?) command. For example:

   ``` powershell
   New-SelfSignedCertificate -Type Custom -Subject "CN=Common Name, O=Organisation, L=Somewhere, C=Country" -KeyUsage DigitalSignature -FriendlyName "Friendly Name" -CertStoreLocation "Cert:\CurrentUser\My" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")
   ```

2. Run `sudo get_rootfs.sh` on a Linux host to get `install.tar.gz`, this can be copied to the root of the project.

3. Run `build.bat` to get the appx package.

4. Install the package appx package. For example, via powershell:

   ``` powershell
   Add-AppxPackage x64\Release\Arch-Appx\Arch-Appx_1.0.0.0_x64_Release.appx
   ```
