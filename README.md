#NYIM 
====

New York Interactive Media
Training-NYC.com Version 10

####To restart server
First have your public key installed by Viktor viktor.tron@gmail.com

ssh root@207.210.201.229
ps auxwww | grep delayed_job | grep -v grep
killall svscan
/etc/init.d/nyim_service
ps auxwww | grep delayed_job | grep -v grep

Make sure to close the window and do nothing besides these commands

--
restarted apache with 
  sudo service httpd restart
check status with 
  sudo service httpd status
