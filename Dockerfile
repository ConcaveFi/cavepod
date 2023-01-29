FROM ubuntu:latest

LABEL org.opencontainers.image.title="Cavepod"
LABEL org.opencontainers.image.description="Docker Image for Gitpod to use for web3 project"
LABEL org.opencontainers.image.source="https://github.com/ConcaveFi/cavepod"
LABEL org.opencontainers.image.authors="Concave.Fi"

# Non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Update apt database
RUN apt-get update

# Install essentials
RUN apt-get install -y apt-utils software-properties-common apt-transport-https sudo \
    build-essential psmisc tmux htop wget curl telnet gnupg gdb git gitk autoconf locales gdebi \
    meld dos2unix meshlab jq vim iputils-ping shellcheck ripgrep nnn fzf entr zip \
    unzip bash-completion less time man-db lsof

# Set the locale
RUN locale-gen en_US.UTF-8

RUN add-apt-repository ppa:ethereum/ethereum
RUN add-apt-repository ppa:aslatter/ppa
RUN apt-get update && apt-get install -y alacritty solc ethereum

# Install VSCode
RUN wget -O code.deb https://go.microsoft.com/fwlink/?LinkID=760868 && \
    gdebi -n code.deb && \
    rm code.deb

# Install browser
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    gdebi -n google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

RUN curl -L https://foundry.paradigm.xyz | bash
RUN chmod +x $HOME/.foundry/bin/foundryup && \
    $HOME/.foundry/bin/foundryup

# Install jupyter
RUN apt-get install -y python3 python3-dev python3-pip python3-setuptools && \
    if [ ! -f "/usr/bin/python" ]; then ln -s /usr/bin/python3 /usr/bin/python; fi && \
    pip3 install ipython jupyter

# Install magic-wormwhole to get things from one computer to another safely
RUN apt-get install -y magic-wormhole

# Install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify && \
    echo "<html><head><meta http-equiv=\"Refresh\" content=\"0; url=vnc.html?autoconnect=true&reconnect=true&reconnect_delay=1000&resize=scale&quality=9\"></head></html>" > /opt/novnc/index.html

# Set environmental variables
ENV DISPLAY=:1

# Create user gitpod
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod && \
    # passwordless sudo for users in the 'sudo' group
    sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

############################################# Switch to gitpod user
USER gitpod

# Install informative git for bash
RUN git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

# Set up .bashrc
WORKDIR /home/gitpod
RUN echo "GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bashrc && \
    echo "source \${HOME}/.bash-git-prompt/gitprompt.sh" >> ~/.bashrc && \
    echo "YARP_COLORED_OUTPUT=1" >> ~/.bashrc && \
    echo "LD_LIBRARY_PATH=/usr/local/lib:\${LD_LIBRARY_PATH}" >>  ~/.bashrc

# Intall Rust
RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --no-modify-path --default-toolchain stable \
    -c rls rust-analysis rust-src rustfmt clippy

############################################# Switch to root user
USER root

# Make Alacritty as default term
RUN update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50
RUN update-alternatives --config x-terminal-emulator 

# Install hyperfine
COPY hyperfine.sh /tmp/hyperfine.sh
RUN chmod +x /tmp/hyperfine.sh && \
    sh /tmp/hyperfine.sh

# Install Packer, Terraform
COPY hashicorp.sh /tmp/hashicorp.sh
RUN chmod +x /tmp/hashicorp.sh && \
    sh /tmp/hashicorp.sh

# Install NerdFont
RUN mkdir -p /home/gitpod/.local/share/fonts
COPY fonts.sh /tmp/fonts.sh
RUN chmod +x /tmp/fonts.sh && \
    sh /tmp/fonts.sh

# Intall Go
COPY go.sh /tmp/go.sh
RUN chmod +x /tmp/go.sh && \
    sh /tmp/go.sh

# Intall Rust
COPY rust.sh /tmp/rust.sh
RUN chmod +x /tmp/rust.sh && \
    sh /tmp/rust.sh

# Owned by gitpod user
RUN chown -R gitpod.gitpod /home/gitpod

# Clean up
RUN rm -Rf \
    apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Launch bash
WORKDIR /workspace
CMD ["bash"]
