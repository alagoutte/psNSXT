#Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Public_fabric = @( Get-ChildItem -Path $PSScriptRoot\Public\Fabric\*.ps1 -ErrorAction SilentlyContinue )
$Public_infra = @( Get-ChildItem -Path $PSScriptRoot\Public\Policy\Infra\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach ($import in @($Public + $Public_fabric + $Public_infra + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Here I might...
# Read in or create an initial config file and variable
# Export Public functions ($Public.BaseName) for WIP modules
# Set variables visible to the module and its functions only

#Export-ModuleMember -Function $Public.Basename