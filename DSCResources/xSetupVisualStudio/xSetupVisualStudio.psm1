enum Ensure
{
       Absent
       Present
}

[DscResource()]
class xSetupVisualStudio 
{

       [DscProperty(Key)]
       [ValidateSet('Microsoft Visual Studio Enterprise 2015','Microsoft Visual Studio Professional 2015','Microsoft Visual Studio Code')]
       [string] $ProductName

       [DscProperty()]
       [string] $SetupFile
        
       [DscProperty()]
       [string]$InstallationArgs = '/Full'

       [DscProperty()]
       [string] $AdminDeploymentFile    
           
       [DscProperty()]
       [string] $ProductKey

       [DscProperty(Mandatory)]
       [Ensure] $Ensure

       [DscProperty(NotConfigurable)]
       [bool] $IsValid

       [void] validateArguments(){
            
            if($this.AdminDeploymentFile){
                $this.InstallationArgs = "/AdminFile $($this.AdminDeploymentFile)"
            }
            
            if(-not $this.SetupFile -or (-not (Test-Path $this.SetupFile)))
            {
                
                switch -Exact ($this.ProductName){
                    'Microsoft Visual Studio Enterprise 2015'  {
                        $this.SetupFile = 'https://download.microsoft.com/download/C/7/8/C789377D-7D49-4331-8728-6CED518956A0/vs_enterprise_ENU.exe'
                    }
                    'Microsoft Visual Studio Professional 2015' {
                        $this.SetupFile = 'https://download.microsoft.com/download/D/2/8/D28D3B41-BF4A-409A-AFB5-2C82C216D4E1/vs_professional_ENU.exe'
                    }
                    'Microsoft Visual Studio Code' {
                        $this.SetupFile = 'https://go.microsoft.com/fwlink/?LinkID=623230'
                    }
                    default { 
                        $this.SetupFile  = 'https://download.microsoft.com/download/D/2/8/D28D3B41-BF4A-409A-AFB5-2C82C216D4E1/vs_professional_ENU.exe'
                    }
                }
                
            }            
            

            if($this.SetupFile -and $this.SetupFile.StartsWith('http')){
                Write-Verbose "Downloading installation files from $($this.SetupFile)"
                $target = Join-Path $env:TEMP "VS_Setup.exe"
                [System.Net.WebClient]::new().DownloadFile($this.SetupFile, $target);
                $this.SetupFile = $target;
            }


            if(-not $this.SetupFile -or -not (Test-Path $this.SetupFile)){            
                throw "Setup file cannot be fetched. URLs for downloading are wrong or you've specified an invalid target in SetupFile - $($this.SetupFile)"
            }
            
            if(-not $this.AdminDeploymentFile -and -not $this.InstallationArgs)
            {
                throw "Invalid arguments! Specify either a deployment file or InstallationArgs"
            }
            
       }



       [xSetupVisualStudio] Get()
       {
            Write-Debug "Getting package";                        
            $this.Ensure = [Ensure]::Absent;            

            if($this.HasInstalledApp($this.ProductName)){
                $this.Ensure = [Ensure]::Present;
            }
            return $this;            

       }

       [void] Set()
       {
            $this.validateArguments();

            if($this.Ensure -eq [Ensure]::Present)
            {                
                $logFile = Join-path $Env:Temp "VisualStudioInstallation.log"

                if($this.ProductName -eq 'Microsoft Visual Studio Code'){
                    $args = "/SILENT /Log $logFile"
                } else {
                    $args = "/Quiet /NoRestart $($this.InstallationArgs) /Log $logFile"
                    if($this.ProductKey)
                    {
                        $args = $args + " /ProductKey $this.ProductKey"
                    }
                }

                Write-Verbose "Starting Visual studio installation with $args " 
                Start-Process -FilePath $this.SetupFile -ArgumentList $args -Wait -NoNewWindow       
                Write-Verbose "Successfully installed VS" 
            }
            else
            {
                if($this.ProductName -ne 'Microsoft Visual Studio Code'){
                    $args = "/Quiet /Force /Uninstall /Log $Env:Temp\VS_Uninstall.log"                
                    Write-Verbose "Starting uninstallation usnig $args" 
                    Start-Process -FilePath $this.SetupFile -ArgumentList $args -Wait -NoNewWindow       
                    Write-Verbose "Uninstalled VS successfully" 
                } else {
                    Write-Error 'Uninstalling VS full edition is not supported yet'

                }
            }
       }

       [bool] Test()
       {
            Write-Verbose "Testing if $($this.ProductName) exists"
            return $this.HasInstalledApp($this.ProductName);
       }

       [bool] HasInstalledApp($displayName){            
            return $this.GetInstalledApps().DisplayName -contains $displayName;            
       }

       [PSObject[]] GetInstalledApps()
       {            
            $Sys64Path = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
            $Sys32Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
            if((Test-Path $Sys64Path)){
                $keys  = Get-childitem $Sys64Path;                
            } else {
                $keys= Get-childitem $Sys32Path;                         
            }
            return $keys|ForEach-Object {   
                $name = $_.GetValue('DisplayName');
                if($name){                            
                    New-Object PSObject -Property @{
                        "DisplayName" = $_.GetValue("DisplayName");
                        "DisplayVersion" = $_.GetValue("DisplayVersion");
                        "UninstallString" = $_.GetValue("UninstallString");
                        "Publisher" = $_.GetValue("Publisher")            
                    }         
                }                   
            }            
       }      
}