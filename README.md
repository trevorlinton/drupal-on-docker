
# Drupal 8 in Docker

## Warning

This is somewhat experimental as drupal isn't intended to run on a 12-factor system. But, might as well try.

Current version: `8.3.7`

This is a drupal 8 fresh install with fly-system (S3 file system) to support deployment on systems where file systems cannot be written to (such as heroku, cloud foundary, docker, etc)

## Pre-reqs

```
HASH_SALT=abcdefg0123456
DATABASE_URL=user:pass@tcp(host:port)/dbname
S3_ACCESS_KEY=ABCDEFG
S3_BUCKET=foo-553234
S3_LOCATION=foo-553234.s3.amazonaws.com
S3_SECRET_KEY=abcdefg
```

The mysql uri must be in format `username:password@tcp(database-hostname.com:3306)/database-name`

## Running

```bash
docker run --env DATABASE_URL --env HASH_SALT --env S3_ACCESS_KEY --env S3_BUCKET --env S3_LOCATION --env S3_SECRET_KEY -p 8080:8080 drupal:8.3.7
```

## First Launch

1. Go to /core/install.php
2. Finish installation
3. Go to /admin/config/media/file-system and enable "Flysystem: s3" in "Default download method"

## Building An Image

0. Modify `Dockerfile` add the "FROM" to be your favoriate flavor of debian. 
1. Add bash commands to build in `Dockerfile`
2. Change any apache config settings in `apache2.conf` and site specific ones in `apache-site.conf`
3. Change any base drupal settings in `settings.php`.

Then run

```bash
docker build . -t drupal:8.3.7
```
