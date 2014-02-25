/etc/init.d/httpd stop
cd ~/nyim/shared/
tar czvf backup/log.`date +%Y-%m-%d-%H-%M-%S`.tgz log
for f in log/cronjobs.log log/httpd.log log/delayed_job.log log/production.log; do echo -n > $f; done
/etc/init.d/httpd start