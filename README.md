[![Gitpod image](https://img.shields.io/badge/Gitpod-ready--to--code-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/ConcaveFi/cavepod)

# Cavepod

Custom Docker Image for Gitpod. Image hosted on github package.

## Config

### gitpod.yml image usage

Usage prod:

```yml
image: ghcr.io/ConcaveFi/cavepod:latest
```

Usage dev:
```yml
image:
  file: Dockerfile
```

## Reference

### Based on `ubuntu:latest` with Bash

 - Alacritty as default terminal
 - Foundry
 - Jupyter
 - Go
 - Rust
 - NPM

### Additionnal packages

 - Bash-git-prompt
 - Hyperfine
 - Hashicorp Packer/Terraform

 ### Hosting on ghcr.io

 > **Note**
 >
 > To host the Docker Image on Github Package you need to add a PAT token with the scope of `package`
 > See the github workflow for the push and deploy.
 