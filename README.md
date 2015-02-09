#NYIM 
====

New York Institutional Metrics Training (NYIM Training)
Training-NYC.com Version 10

####To restart server
First have your public key installed by Viktor viktor.tron@gmail.com. It may be possible to add via github


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

