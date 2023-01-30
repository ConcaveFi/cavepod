#!/bin/sh

GO_VERSION=$(curl https://go.dev/dl/?mode=json | jq -r '.[0].version' 2>/dev/null | cut -d "o" -f2)
GO_VERSION=${GO_VERSION:-1.19.5}
curl https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz -o go.tar.gz
tar -C /home/gitpod/ -xzf go.tar.gz
rm go.tar.gz

GOROOT="/home/gitpod/go"
GOPATH="/workspace/go"
mkdir -p "$GOPATH/src" "$GOPATH/pkg" "$GOPATH/bin"
PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

go install -v github.com/uudashr/gopkgs/cmd/gopkgs@v2 &&
    go install -v github.com/ramya-rao-a/go-outline@latest &&
    go install -v github.com/cweill/gotests/gotests@latest &&
    go install -v github.com/fatih/gomodifytags@latest &&
    go install -v github.com/josharian/impl@latest &&
    go install -v github.com/haya14busa/goplay/cmd/goplay@latest &&
    go install -v github.com/go-delve/delve/cmd/dlv@latest &&
    go install -v github.com/golangci/golangci-lint/cmd/golangci-lint@latest &&
    go install -v golang.org/x/tools/gopls@latest &&
    go install -v honnef.co/go/tools/cmd/staticcheck@latest

echo "export GOROOT=/home/gitpod/go" >>/home/gitpod/.bashrc
echo "export GOPATH=/workspace/go" >>/home/gitpod/.bashrc
printf '%s\n' 'export PATH=$GOROOT/bin:$GOPATH/bin:$PATH' >>/home/gitpod/.bashrc
