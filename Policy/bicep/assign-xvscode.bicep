resource testVM 'Microsoft.Compute/virtualMachines@2021-03-01' existing = {
    name: 'testVM'
}
  
resource xVSCodePolicy 'Microsoft.GuestConfiguration/guestConfigurationAssignments@2020-06-25' = {
    name: 'Ensure VSCode is installed'
    scope: testVM
    location: resourceGroup().location
    properties: {
      guestConfiguration: {
        name: 'xVSCode'
        contentUri: '<Url_to_Package.zip>'
        contentHash: '<SHA256_hash_of_package.zip>'
        version: '1.*'
        assignmentType: 'ApplyAndMonitor'
        configurationParameter: [
          {
            name: 'Ensure;ExpectedValue'
            value: 'Present'
          }
          {
            name: 'Ensure;RemediateValue'
            value: 'Present'
          }
          ]
        }
      }
    }
  }
