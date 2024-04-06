#!/bin/bash

# Initialize default values
USER_ID=0
GROUP_ID=0
COMMAND_TO_RUN=""

# Process named arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --uid) USER_ID="$2"; shift ;;
        --gid) GROUP_ID="$2"; shift ;;
        --run) COMMAND_TO_RUN="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ "$USER_ID" != "0" ]; then
    USER_NAME=builder
    # Ensure /etc/sudoers.d exists
    mkdir -p /etc/sudoers.d

    # Create group and user with specified GID/UID
    groupadd -g $GROUP_ID $USER_NAME
    useradd -m -u $USER_ID -g $GROUP_ID -s /bin/bash $USER_NAME

    # Add user to sudoers
    echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER_NAME
    chmod 0440 /etc/sudoers.d/$USER_NAME # Set correct permissions

    # Change ownership of the Rust directories to the new user
    chown -R $USER_ID:$GROUP_ID /usr/local/cargo
    chown -R $USER_ID:$GROUP_ID /usr/local/rustup

    # If a command is provided, run as non-root builder
    if [ -n "$COMMAND_TO_RUN" ]; then
        exec gosu $USER_NAME bash -c "$COMMAND_TO_RUN"
    else
        echo "No command specified to run."
        exit 1
    fi
else
    # If a command is provided, run as root
    if [ -n "$COMMAND_TO_RUN" ]; then
        exec bash -c "$COMMAND_TO_RUN"
    else
        echo "No command specified to run."
        exit 1
    fi
fi
