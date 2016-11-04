# xVisualStudio
A DSC Resource to install / uninstall visual studio

NB: Uninstalling of VS Code does not work yet.

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


## Install VS 2015 enterprise using online installer'
```powershell
Configuration InstallVS {
    Node localhost {

        xSetupVisualStudio installVSCode {
            Ensure='Present'
            ProductName='Visual Studio 2015 Enterprise'
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
            ProductName='Visual Studio 2015 Enterprise'
            ProductKey = 'xxxx-xxxx-xxxx-xxxx' # GUID
            SetupFile = 'c:\tmp\vs_installer.exe'
        }
    }
}
``` 

