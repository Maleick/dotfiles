# Red Team Dotfiles - Arch Linux Test Environment
FROM archlinux:latest

# Update system and install base dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    base-devel \
    bash \
    zsh \
    tmux \
    vim \
    git \
    curl \
    wget \
    python \
    python-pip \
    shellcheck \
    sudo \
    figlet \
    lolcat

# Install AUR helper (yay) for additional packages
RUN pacman -S --noconfirm git && \
    git clone https://aur.archlinux.org/yay.git /tmp/yay && \
    cd /tmp/yay && \
    makepkg -si --noconfirm && \
    rm -rf /tmp/yay

# Install optional tools for comprehensive testing
RUN pacman -S --noconfirm \
    fzf \
    ripgrep \
    asciinema \
    bat \
    exa \
    fd \
    && pacman -Scc --noconfirm

# Install BATS test framework
RUN git clone https://github.com/bats-core/bats-core.git /tmp/bats && \
    cd /tmp/bats && \
    ./install.sh /usr/local && \
    rm -rf /tmp/bats

# Create test user
RUN useradd -m -s /bin/zsh testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install zsh plugins (system-wide)
RUN pacman -S --noconfirm zsh-syntax-highlighting zsh-autosuggestions

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Copy dotfiles
COPY --chown=testuser:testuser . /home/testuser/dotfiles

# Set up test environment
RUN mkdir -p /home/testuser/.config && \
    mkdir -p /home/testuser/.cache && \
    mkdir -p /home/testuser/.ssh && \
    chmod 700 /home/testuser/.ssh

# Install dotfiles
WORKDIR /home/testuser/dotfiles
RUN bash bootstrap.sh || bash install.sh

# Run health check
RUN chmod +x scripts/healthcheck.sh && \
    ./scripts/healthcheck.sh || true

# Test modular configuration
RUN zsh -c "source config/zshrc.new && command -v /help" || \
    zsh -c "source zsh/.zshrc && command -v /help"

# Default command runs comprehensive tests
CMD ["make", "ci-local"]