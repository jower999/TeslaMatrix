TeslaMatrix is a powershell module for managing your Tesla car from the command line.

If you are about to order a new tesla car, please consider using my referral code. 
For that you (and I) will get 1000 miles / 1500 km of free super charging and you will have a chance to win a Model Y (one time per month) and a Roadster (once every 3 months)
Click this link https://ts.la/john53080 or use the method Get-FreeSuperCharging inside the module.

How to use:
Import the module is done just by typing Import-Module TeslaMatrix 
During Import the module will ask for your tesla credentials.
You can also save your credentials in a local credential object and pass it to the Import-Module command as shown below.
Import-Module TeslaMatrix -argumentlist @{Credential=$cred}
You can also, if preferred, only send your tesla refresh token to the module. The module will ask the tesla API for a new token based on that.
Import-Module TeslaMatrix -argumentlist @{RefreshToken="1234567890"}

Most functions in this module takes as input the id of the vehicle you want to do the operation to. 
The default value, if id is not specified, is the currently selected vehicle.
If you only have one vehicle in your account that vehicle is the selected vehicle.

If you have more than one vehicle, then you can easily select the active vehicle using the Select-Vechicle function
Either by using the id of the vehicle or the name. When you import the module, the first vehicle in your account is automatically selected.

Select-Vechicle -name Neo 
or
Select-Vehicle -id 1234567890

To view the vehicles in your account, use the function Get-Vehicles.

To get the list of functions in the module, you can write Get-Command -Module TeslaMatrix.
To get help on functions you can write Get-Help FunctionName (as in Get-Help Invoke-ValetMode)

Sourcecode can be found on github (https://github.com/jower999/TeslaMatrix).
You are most welcome to contribute by forking the code and sending me a pull-request.

TeslaMatrix powershell module is based on the unofficial documentation of the tesla API
The documentation can be found on https://tesla-api.timdorr.com
