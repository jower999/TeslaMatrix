TeslaMatrix powershell module is based on the unofficial documentation of the tesla API
The documentation can be found on https://tesla-api.timdorr.com

How to use:
Import the module is done just by typing Import-Module TeslaMatrix 
During Import the module will ask for your tesla credentials.
You can also save your credentials in a local credential object and pass it to the Import-Module command as shown below.
Import-Module TeslaMatrix -argumentlist @{Credential=$cred}
You can also, if preferred, only send your tesla refresh token to the module. The the module will ask the tesla API for a new token based on that.
Import-Module TeslaMatrix -argumentlist @{RefreshToken="1234567890"}


