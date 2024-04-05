#!/bin/bash

# Accept user id, group id, and username as arguments
USER_ID=${1:-1000}
GROUP_ID=${2:-1000}
USER_NAME=${3:-root}

# Ensure /etc/sudoers.d exists
mkdir -p /etc/sudoers.d

# Create group and user with specified GID/UID and username
groupadd -g $GROUP_ID $USER_NAME || true # Avoid error if group exists
useradd -m -u $USER_ID -g $GROUP_ID -s /bin/bash $USER_NAME || true # Avoid error if user exists

# Add user to sudoers
echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER_NAME
chmod 0440 /etc/sudoers.d/$USER_NAME # Set correct permissions

# Change ownership of the Rust directories to the new user
chown -R $USER_ID:$GROUP_ID /usr/local/cargo
chown -R $USER_ID:$GROUP_ID /usr/local/rustup

# If additional commands are provided, execute them
if [ $# -gt 3 ]; then
    # Remove the first three arguments (UID, GID, USERNAME)
    shift 3
    exec gosu $USER_NAME "$@"
else
    exec gosu $USER_NAME /bin/bash
fi
