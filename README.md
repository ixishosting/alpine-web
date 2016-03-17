# Alpine Web

A Docker image for running Apache and PHP on Alpine Linux.

This image is tailored for running Drupal and assumes your code is stored in git.  On launch the image will pull down the code into /app/ and assets will be stored in /assets/

## Variables

    GIT_BRANCH=name-of-branch
    GIT_URL=https://username:password@address-of-git-repo.git
