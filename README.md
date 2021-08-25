# WordPress Server

Infra to host a wordpress server with AWS EC2 and RDS

Powershell
$env:TF_VAR_host='3Qg)q*$$>GXuC9xQ'
$env:TF_VAR_wordpress_database      ='wordpress'
$env:TF_VAR_wordpress_user          ='wordpress'
$env:TF_VAR_wordpress_user_password ='3Qg)q*$$>GXuC9xQ'
$env:TF_VAR_master_rds_user         ='root'
$env:TF_VAR_master_rds_user_password='3Qg)q*$$>GXuC9xQ'

Shell
export host=''
export wordpress_database=wordpress
export wordpress_user=wordpress
export wordpress_user_password='3Qg)q*$$>GXuC9xQ'
export master_rds_user=root
export master_rds_user_password='3Qg)q*$$>GXuC9xQ'

http://`ecs-dns`/wp-admin/install.php

ecs_public_address

sudo vim /var/www/html/wp-config.php

i

paste

:x

`ecs-dns`

mysql -u [username] -h [rds-host] -D [database] -p[password]
