Configuration InstallVS2015 {

    Import-DscResource -ModuleName PSDesiredStateConfiguration;
    Import-DscResource -ModuleName xSetupVisualStudio;

    Node localhost {
        
        xSetupVisualStudio installVisualStudio {
            ProductName = 'Visual Studio 2015 Enterprise'
            Ensure = 'Present'                      
        }

    }
}

InstallVS2015 -OutputPath .\ -Verbose

Start-DscConfiguration -Wait -Verbose -debug -Path .\ -Force 