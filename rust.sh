#!/bin/sh

PATH="/home/gitpod/.cargo/bin:$PATH"
mkdir -p /home/gitpod/.local/share/bash-completion/completions/rustup
rustup completions bash >/home/gitpod/.local/share/bash-completion/completions/rustup

# mkdir -m 0755 -p /workspace/.cargo/bin 2>/dev/null
# echo "export CARGO_HOME=/workspace/.cargo" >>/home/gitpod/.bashrc
echo "export CARGO_HOME=/home/gitpod/.cargo" >>/home/gitpod/.bashrc
printf '%s\n' 'export PATH=$CARGO_HOME/bin:$PATH' >>/home/gitpod/.bashrc
