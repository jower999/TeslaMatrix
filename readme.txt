TeslaMatrix powershell module is based on the unofficial documentation of the tesla API
The documentation can be found on https://tesla-api.timdorr.com

How to use:
Import the module is done just by typing Import-Module TeslaMatrix 
During Import the module will ask for your tesla credentials.
You can also save your credentials in a local credential object and pass it to the Import-Module command as shown below.
Import-Module TeslaMatrix -argumentlist @{Credential=$cred}
You can also, if preferred, only send your tesla refresh token to the module. The module will ask the tesla API for a new token based on that.
Import-Module TeslaMatrix -argumentlist @{RefreshToken="1234567890"}

If you are about to order a new tesla car, please consider using my referral code. 
For that you will get 1000 miles / 1500 km of free super charging and you will have a chance to win a Model Y (one time per month) and a Roadster (once every 3 months)
Click this link https://ts.la/john53080 or use the method Get-FreeSuperCharging inside the module.
