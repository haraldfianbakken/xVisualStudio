# xVisualStudio 
A DSC Resource to install / uninstall visual studio

Version: 1.0.0

Will be release to PSGallery soon!

NB: Uninstalling of VS Code does not work yet.

Note: Installing Enterprise/Pro without installation args will add /Full installation



## How to use

## Install VS Code using online installer

```powershell
Configuration InstallVS {
    Node localhost {

        xSetupVisualStudio installVSCode {
            Ensure='Present'
            ProductName='Microsoft Visual Studio Code'
        }
    }
}
```


## Install VS 2015 enterprise using online installer
```powershell
Configuration InstallVS {
    Node localhost {

        xSetupVisualStudio installVSCode {
            Ensure='Present'
            ProductName='Microsoft Visual Studio Enterprise 2015'
            ProductKey = 'xxxx-xxxx-xxxx-xxxx' # GUID
        }
    }
}
```

## Install using local setup files (e.g. no internet access)

```powershell 
Configuration InstallVS {
    Node localhost {

        xSetupVisualStudio installVSCode {
            Ensure='Present'
            ProductName='Microsoft Visual Studio Enterprise 2015'
            ProductKey = 'xxxx-xxxx-xxxx-xxxx' # GUID
            SetupFile = 'c:\tmp\vs_installer.exe'
        }
    }
}
``` 


## Install using specific installer arguments
Because the full installation takes a lot of time and will make your DSC be stuck in applying for a long time while installing VS full. 
If you're interested in specific features only, install using this

```powershell 
Configuration InstallVS {
    Node localhost {

        xSetupVisualStudio installVSCode {
            Ensure='Present'
            ProductName='Microsoft Visual Studio Enterprise 2015'
            ProductKey = 'xxxx-xxxx-xxxx-xxxx' # GUID
            SetupFile = 'c:\tmp\vs_installer.exe'
            InstallationArgs = '/InstallSelectableItems <items>'
        }
    }
}
``` 

## Other supported features

AdminDeploymentFile - If installing VS professional or enterprise you can give it an admin file for installation using this param
