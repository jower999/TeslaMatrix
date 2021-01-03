Import-module Pester
Import-Module $PSScriptRoot\TeslaMatrix.psm1 -ArgumentList @{TestMode=$true} -Force

Describe Get-Vehicles {
    Context 'Get-Vehicles' {
        BeforeEach {
            Mock InitializeModule {}
            Mock Get-Credential {return new-object pscredential -ArgumentList ("fakeuser", (ConvertTo-SecureString "fakepwd" -force -AsPlainText))}
            Mock Get-AccessToken {return $null}
        }
        It 'When having no cars in account, then return no cars' {
            Mock Invoke-RestMethod {return @{response=$null;count=0}}
            Import-Module $PSScriptRoot\TeslaMatrix.psm1 -Force
            Get-Vehicles | Should -be $null
            Assert-MockCalled Invoke-RestMethod -Times 1
        }

        It 'When having 1 car in account, then return 1 cars' {
            Mock Invoke-RestMethod {return new-object psobject -Property @{response=($testcar);count=1}}
            Import-Module $PSScriptRoot\TeslaMatrix.psm1 -Force
            Get-Vehicles | Should -be $testcar
            Assert-MockCalled Invoke-RestMethod -Times 1
        }

        It 'When having 2 cars in account, then return 2 cars' {
            Mock Invoke-RestMethod {return new-object psobject -Property @{response=($testcar);count=1}}
            Import-Module $PSScriptRoot\TeslaMatrix.psm1 -Force
            Get-Vehicles | Should -be $testcars
            Assert-MockCalled Invoke-RestMethod -Times 1
        }
    }
}

$testcar = @"                                                            
{
  "response": [
    {
      "id": 12345678901234567,
      "vehicle_id": 1234567890,
      "vin": "5YJSA11111111111",
      "display_name": "Nero",
      "option_codes": "MDLS,RENA,AF02,APF1,APH2,APPB,AU01,BC0R,BP00,BR00,BS00,CDM0,CH05,PBCW,CW00,DCF0,DRLH,DSH7,DV4W,FG02,FR04,HP00,IDBA,IX01,LP01,ME02,MI01,PF01,PI01,PK00,PS01,PX00,PX4D,QTVB,RFP2,SC01,SP00,SR01,SU01,TM00,TP03,TR00,UTAB,WTAS,X001,X003,X007,X011,X013,X021,X024,X027,X028,X031,X037,X040,X044,YFFC,COUS",
      "color": null,
      "tokens": ["abcdef1234567890", "1234567890abcdef"],
      "state": "online",
      "in_service": false,
      "id_s": "12345678901234567",
      "calendar_enabled": true,
      "api_version": 7,
      "backseat_token": null,
      "backseat_token_updated_at": null
    }
  ],
  "count": 1
}
"@ | ConvertFrom-Json | Select-Object -ExpandProperty response

$testcars = @($testcar, $testcar)
