# clipac
Cisco Like IP Address Changer
![demo](https://user-images.githubusercontent.com/29778890/51610456-2cc5e900-1f60-11e9-954f-cf12156c8dfb.gif)

## Run
* Windows  
Run as administrator `clipac.bat`  
* Linux [<sup>[1]</sup>](#note-1)  
`sudo ./clipac.sh`


## Usage
* Show interface  
`clipac# show interface`  
* Show IP Address  
`clipac# show ip`  
* Show IP Address for each interfaces  
`clipac# show ip  interface [interface]`  
* Change static IP Address  
`clipac(config-if)# ip address [ip address][(subnet)][(gateway)]`  
* Change IP Address by DHCP  
`clipac(config-if)# ip address dhcp`  
* Enable / Unable interface  
`clipac(config-if)# [(no)] shutdown`  
* Exit this app  
All mode `quit`  
* Show help  
All mode `help`  
* Change hostname[<sup>[2]</sup>](#note-2)  
`clipac(config)# hostname [hostname]`  
* Comment  
A comment is any line beginning with an exclamation("!") point.  



## Command Mode Summary
|<b>Mode</b> |<b>Access Method</b> |<b>Prompt</b> |<b>Exit Method</b> |
|:--- |:--- |:--- |:--- |
|User EXEC |Begin a session with your switch. |clipac> |Enter **logout** or **quit**. |
|Privileged EXEC |While in user EXEC mode, enter the **enable** command. |clipac# |Enter **disable** to exit. |
|Global configuration |While in privileged EXEC mode, enter the **configure** command. |clipac(config)# |To exit to privileged EXEC mode, enter **exit** or **end**. |
|Interface configuration |While in global configuration mode, enter the **interface** command (with a specific interface). |clipac(config&#8722;if)#  |To exit to global configuration mode, enter **exit**. To return to privileged EXEC mode, enter **end**. |


## Note
<a name="note-1"></a>
1. Unimplemented  
<a name="note-2"></a>
2. Will not be saved.  
3. Still many bugs...  
