# Terraform Files Boilerplate

This Shell script generates a boilerplate for Terraform files and Git pre-commit hook if git is installed. Please see the [Terraform Documentation](https://www.terraform.io/docs/configuration/variables.html) for more information and look in the scripts freely.

## Usage

Simply make executable [main.sh](main.sh) and execute. Kindly note that the scripts below are deleted after generating boilerplate. How I use it is add the repo to the remote of my new project, pull, then execute main.sh. The side effect is you would have to create your own `README.md` file

```sh
# Add git@github.com:whizyrel/terraform-boilerplate.git to remote of my new project

chmod +x main.sh

./main.sh

# REMOVE git@github.com:whizyrel/terraform-boilerplate.git from your remote if you wish

```

## Scripts

The following scripts are used:

- [tf-files.sh](tf-files.sh)

- [init-git-hooks.sh](init-git-hooks.sh)

- [hooks/pre-commit](hooks/pre-commit)
