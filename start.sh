#!/bin/bash

DATABASE_USERNAME=`echo $DATABASE_URL | sed -n 's/\([A-z0-9]*\):.*/\1/p'`
DATABASE_PASSWORD=`echo $DATABASE_URL | sed -n 's/.*:\([A-z0-9]*\)@.*/\1/p'`
DATABASE_HOST=`echo $DATABASE_URL | sed -n 's/.*@tcp(\([A-z0-9\.\-]*\).*/\1/p'`
DATABASE_PORT=`echo $DATABASE_URL | sed -n 's/.*@tcp([A-z0-9\.\-]*:\([0-9]*\)).*/\1/p'`
DATABASE_NAME=`echo $DATABASE_URL | sed -n 's/.*\/\([A-z0-9]*\)$/\1/p'`

RESULT=`echo "SELECT count(*) FROM information_schema.tables WHERE table_schema = '$DATABASE_NAME' AND table_name = 'config' LIMIT 1;" |  mysql --show-warnings=FALSE --column-names=FALSE -u $DATABASE_USERNAME --password=$DATABASE_PASSWORD --host=$DATABASE_HOST --port=$DATABASE_PORT $DATABASE_NAME`

if [ "$RESULT" != '1' ]; then
	echo "Installing database ... "
	cat create.sql | mysql --show-warnings=FALSE --column-names=FALSE -u $DATABASE_USERNAME --password=$DATABASE_PASSWORD --host=$DATABASE_HOST --port=$DATABASE_PORT $DATABASE_NAME
fi

read -r -d '' DATA << EOM

\$settings['hash_salt'] = '$HASH_SALT';
\$databases['default']['default'] = array (
  'database' => '$DATABASE_NAME',
  'username' => '$DATABASE_USERNAME',
  'password' => '$DATABASE_PASSWORD',
  'prefix' => '',
  'host' => '$DATABASE_HOST',
  'port' => '$DATABASE_PORT',
  'namespace' => 'Drupal\\\\Core\\\\Database\\\\Driver\\\\mysql',
  'driver' => 'mysql',
);

\$settings['install_profile'] = 'standard';
\$config_directories['sync'] = 'sites/default/files/config_FDSpP793-nnkLVJp4IrZCd1hkBlT-_D-RfyO4WY9Yu3cNSUAhUyvyAFrsfuCPnWWuJzovY4vuQ/sync';


\$settings['flysystem'] = array(
  's3' => [
    'type' => 's3',
    'driver' => 's3',
    'config' => [
      'key' => '$S3_ACCESS_KEY',
      'secret' => '$S3_SECRET_KEY',
      'region' => 'us-west-2',
      'bucket' => '$S3_BUCKET',
      'cname' => '$S3_LOCATION'
    ]
  ]
);

EOM

echo "$DATA" >> settings.php


if [ "$RESULT" != '1' ]; then
  echo "Enabling flysystem modules"
  cd /var/www/html/
  sudo -u www-data ./vendor/bin/drush en flysystem -y
  sudo -u www-data ./vendor/bin/drush en flysystem_s3 -y
fi

apachectl stop
apachectl -DFOREGROUND
