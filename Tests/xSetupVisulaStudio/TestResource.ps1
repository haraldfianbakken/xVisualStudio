Import-Module "..\..\DSCResources\xSetupVisualStudio\xSetupVisualStudio.psm1" -Force -Global

# Test install visual studio code
$s  = [xSetupVisualStudio]::new()
$s.Ensure = 'Present';
$s.ProductName = 'Microsoft Visual Studio Code'

$isPresent = $s.Test();
if(-not $isPresent){
    $s.Set()
}

# Test to install visual studio enterprise

$s  = [xSetupVisualStudio]::new()
$s.Ensure = 'Present';
$s.ProductName = 'Microsoft Visual Studio Enterprise 2015'

$isPresent = $s.Test();
if(-not $isPresent){
    $s.Set()
}