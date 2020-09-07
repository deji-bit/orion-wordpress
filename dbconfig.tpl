#!/bin/bash
echo "${db_host_name}" >> /home/ec2-user/dbhostname
echo "var=\$(cat /home/ec2-user/dbhostname)" > /home/ec2-user/dbscript.sh
echo "sed -i \"s/localhost/\$var/\" /var/www/html/dejiblog/wp-config.php" >> /home/ec2-user/dbscript.sh
echo "sed -i \"s/database_name_here/DB_WP_ORION/\" /var/www/html/dejiblog/wp-config.php" >> /home/ec2-user/dbscript.sh
echo "sed -i \"s/username_here/Dadmin/\" /var/www/html/dejiblog/wp-config.php" >> /home/ec2-user/dbscript.sh
echo "sed -i \"s/password_here/Dadminadm1n/\" /var/www/html/dejiblog/wp-config.php" >> /home/ec2-user/dbscript.sh
chmod u+x /home/ec2-user/dbscript.sh
./home/ec2-user/dbscript.sh