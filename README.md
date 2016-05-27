# Ixis Alpine Web

A highly opinionated alpine (3.3) based docker image for use with the Ixis container stack.

This image obtains application code from Amazon S3 and unpacks to `/webapp`.

## Included Packages

* Apache 2
* PHP 5
* Drush 8
* Ansible 2

## Ansible playbooks

*need to add information for this*

## Variables

`$AWS_REGION` Define the AWS region your application code is stored in at S3.

`$S3_URL` Define the url your application is stored in at S3 e.g. `my-bucket/application.tar.gz`.
