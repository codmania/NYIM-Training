#NYIM 
====

New York Institutional Metrics Training (NYIM Training)
Training-NYC.com Version 10

##### Development Use
mysql.server start
rake db:migrate
you may need to delete "System" file in Public folder


####To restart server
First have your public key installed by Viktor viktor.tron@gmail.com. It may be possible to add via github

ssh root@207.210.201.229
/etc/init/delayed_job.conf
ln -s /lib/init/upstart-job /etc/init.d/delayed_job

--needed?
ls -l /etc/init/delayed_job.conf
cat /etc/init/delayed_job.conf



This is antiquated. I think. 
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

--
####Deploying

eval `ssh-agent `; ssh-add  ~/.ssh/id_rsa
cap deploy

####Other notes
Emails
After class
https://github.com/3rdI/nyim/blob/master/lib/nyim_jobs/send_feedback_reminders.rb

The asset is called course_ends
This
https://github.com/3rdI/nyim/blob/master/config/deploy/hostv/crontab

--

Trainer Class Reminder
asset is Trainer_class_reminder
This is pulling from the asset (not in the GUI)

--

Send Course Reminders
Course_reminder

--
##To Check Logs
grep 'send_trainer_class_reminders' /home/training/nyim/current/log -

this checks if curl called by the cron daemon actualy makes it as a request to the app
grep 'send_trainer_class_reminders' /home/training/nyim/current/log/production.log

grep 'CourseReminders' /home/training/nyim/current/log/delayed_job.log


####Centos Release 6.6
# cat /etc/redhat-release

May need this line to restart
initctl start delayed_job


######
/etc/httpd/conf/includes/*
Direct modifications to the Apache configuration file ma
y be lost upon subsequent regeneration of the configuration file. To have modifications retained, all
modifications must be checked into the configuration system by running:
/usr/local/cpanel/bin/apache_conf_distiller --update
To see if your changes will be conserved, regenerate the
Apache configuration file by running:              
/usr/local/cpanel/bin/build_apache_conf and check the configuration file for your alterations. If your changes have been ignored, then they will    
need to be added directly to their respective template files.

To customize this VirtualHost use an include file at the following location
Include "/usr/local/apache/conf/userdata/std/2/training/training-nyc.com/*.conf"

/home/training/www/training-nyc.com/shared/httpd.conf
 
 