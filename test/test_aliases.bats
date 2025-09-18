#!/usr/bin/env bats

# Red Team Dotfiles - Aliases Test Suite

load "test_helper"

setup() {
    # Source the aliases file
    source "${DOTFILES_ROOT}/zsh/lib/aliases.zsh"
}

@test "alias ll exists and points to correct command" {
    run alias ll
    [ "$status" -eq 0 ]
    [[ "$output" == *"ls -alF"* ]]
}

@test "alias la exists and points to correct command" {
    run alias la
    [ "$status" -eq 0 ]
    [[ "$output" == *"ls -A"* ]]
}

@test "alias myip exists" {
    run alias myip
    [ "$status" -eq 0 ]
    [[ "$output" == *"curl -s ifconfig.me"* ]]
}

@test "alias ports exists" {
    run alias ports
    [ "$status" -eq 0 ]
    [[ "$output" == *"netstat -tuln"* ]]
}

@test "alias webserver exists" {
    run alias webserver
    [ "$status" -eq 0 ]
    [[ "$output" == *"python3 -m http.server 8080"* ]]
}

@test "localip function exists and is callable" {
    # Check if function exists
    run type localip
    [ "$status" -eq 0 ]
    [[ "$output" == *"localip is a function"* ]]
}

@test "urlencode alias exists" {
    run alias urlencode
    [ "$status" -eq 0 ]
    [[ "$output" == *"python3 -c"* ]]
    [[ "$output" == *"urllib.parse"* ]]
}

@test "urldecode alias exists" {
    run alias urldecode
    [ "$status" -eq 0 ]
    [[ "$output" == *"python3 -c"* ]]
    [[ "$output" == *"urllib.parse"* ]]
}

@test "rot13 alias exists" {
    run alias rot13
    [ "$status" -eq 0 ]
    [[ "$output" == *"tr a-zA-Z n-za-mN-ZA-M"* ]]
}

@test "hexdump alias points to xxd" {
    run alias hexdump
    [ "$status" -eq 0 ]
    [[ "$output" == *"xxd"* ]]
}

@test "nmap-top-ports alias exists" {
    run alias nmap-top-ports
    [ "$status" -eq 0 ]
    [[ "$output" == *"nmap -sV -sC --top-ports=1000"* ]]
}

@test "grep aliases have color support" {
    run alias grep
    [ "$status" -eq 0 ]
    [[ "$output" == *"--color=auto"* ]]
}

@test "http-server alias exists" {
    run alias http-server
    [ "$status" -eq 0 ]
    [[ "$output" == *"python3 -m http.server"* ]]
}