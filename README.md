sshinead
========

SSH IN Active Directory

Is a little idea I had to store ssh public keys in active directory where they could then be retrieved by Chef,
Salt, Ansible, what ever.  It was going to be the ETL between AD and CM.  
Currently it allows you to manage key to user, and user to group.

sshinead.rb --get-key jbertrand
sshinead.rb --add-to-group -g sysadmin -u jbertrand
....
you get the idea.  

This is important!
The way it works is that AD has extra user attributes that you can use, so if you are already using "extensionattribute1" then you need to modify the code because that is where it is going to stick the ssh key.  
I opted to use extensionattribute1 because I didn't want to make any permanent changes to the AD schema.

