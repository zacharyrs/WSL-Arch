# Arch WSL

This is a fork of the reference WSL image builder, configured for my ideal archlinux setup.

## Getting Started

1. Generate a test certificate:
    1. In Visual Studio, open `DistroLauncher-Appx/MyDistro.appxmanifest`
    2. Select the Packaging tab
    3. Select "Choose Certificate"
    4. Click the Configure Certificate drop down and select Create test certificate.

2. Run `get_rootfs.sh` to get `install.tar.gz`, this can be copied to the root of the project.

### Building the Project (Command line):

To compile the project, you can simply type `build` in the root of the project to use MSBuild to build the solution. This is useful for verifying that your application compiles. It will also build an appx for you to sideload on your dev machine for testing.

`build.bat` assumes that MSBuild is installed at one of the following paths:
`%ProgramFiles*%\MSBuild\14.0\bin\msbuild.exe` or
`%ProgramFiles*%\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\msbuild.exe` or
`%ProgramFiles*%\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe`.

If that's not the case, then you will need to modify that script.

Once you've completed the build, the packaged appx should be placed in a directory like `WSL-DistroLauncher\x64\Release\DistroLauncher-Appx` and should be named something like `DistroLauncher-Appx_1.0.0.0_x64.appx`. Simply double click that appx file to open the sideloading dialog. 

You can also use the PowerShell cmdlet `Add-AppxPackage` to register your appx:

``` powershell
powershell Add-AppxPackage x64\Debug\DistroLauncher-Appx\DistroLauncher-Appx_1.0.0.0_x64_Debug.appx
```
