# Red Team Dotfiles - Ubuntu Test Environment
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install base dependencies
RUN apt-get update && apt-get install -y \
    bash \
    zsh \
    tmux \
    vim \
    git \
    curl \
    wget \
    build-essential \
    python3 \
    python3-pip \
    shellcheck \
    bats \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install optional tools for comprehensive testing
RUN apt-get update && apt-get install -y \
    fzf \
    ripgrep \
    asciinema \
    figlet \
    lolcat \
    && rm -rf /var/lib/apt/lists/* || true

# Create test user
RUN useradd -m -s /bin/zsh testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Copy dotfiles
COPY --chown=testuser:testuser . /home/testuser/dotfiles

# Set up test environment
RUN mkdir -p /home/testuser/.config && \
    mkdir -p /home/testuser/.ssh && \
    chmod 700 /home/testuser/.ssh

# Install dotfiles
WORKDIR /home/testuser/dotfiles
RUN bash bootstrap.sh || bash install.sh

# Install zsh plugins for fallback system
RUN sudo apt-get update && sudo apt-get install -y \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    && sudo rm -rf /var/lib/apt/lists/*

# Run health check
RUN chmod +x scripts/healthcheck.sh && \
    ./scripts/healthcheck.sh || true

# Test modular configuration
RUN zsh -c "source config/zshrc.new && command -v /help" || \
    zsh -c "source zsh/.zshrc && command -v /help"

# Default command runs comprehensive tests
CMD ["make", "ci-local"]
