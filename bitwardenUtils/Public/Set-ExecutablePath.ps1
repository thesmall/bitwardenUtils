function Set-ExecutablePath {
    [CmdletBinding()]
    param(
        [System.IO.DirectoryInfo] $FilePath,

        [Switch] $WriteConfigurationToDisk,

        [Switch] $Force
    )

    begin {

    }

    process {
        #Assign the BW executable path to an environment variable.
        if (Get-Item $FilePath -ErrorAction 'SilentlyContinue') {
            $env:BWUTILS_EXECUTABLE_PATH = $FilePath.FullName

            if ($WriteConfigurationToDisk) {
                #Create the directory if it doesn't exist.
                if (-not $(Get-Item $env:BWUTILS_CONFIGURATION_DIRECTORY -ErrorAction 'SilentlyContinue')) {
                    try {
                        $bwFolderParams = @{
                            Path     = $env:BWUTILS_CONFIGURATION_DIRECTORY
                            ItemType = 'Directory'
                        }
    
                        New-Item @bwFolderParams -ErrorAction 'Stop'
                    }
                    catch {
                        throw
                    }
                }
    
                $bwExecFileParams = @{
                    Path  = $env:BWUTILS_CONFIGURATION_DIRECTORY
                    Name  = "BWUTILS_EXECUTABLE_PATH"
                    Value = $FilePath.FullName
                    Force = $Force.IsPresent
                }
    
                New-Item @bwExecFileParams -ErrorAction 'Stop'
            }
        }
        else {
            $writeErrorParams = @{
                Message   = "The specified path: $($FilePath.FullName) does not exist."
                Exception = 'System.Management.Automation.ItemNotFoundException'
                Category  = 'ObjectNotFound'
            }
            Write-Error @writeErrorParams 
        }
    }

    end {

    }
}