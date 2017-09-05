#!/bin/bash

docker run --env DATABASE_URL --env HASH_SALT --env S3_ACCESS_KEY --env S3_BUCKET --env S3_LOCATION --env S3_SECRET_KEY -p 8080:8080 drupal:8.3.7
echo "Open http://localhost:8080/core/install.php?langcode=en&profile=standard&continue=1"