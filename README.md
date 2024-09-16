# PersistX
Tool for Persistence in Linux

# Overview
Linux persistence tool designed for stealthy post-exploitation scenarios.

## Options
1-APT Persistence-Adds a post-install hook to execute a hidden script after any apt-get operations.
2-Auto Generate SSH keypair for all users-Creates an SSH keypair for persistent remote access.
3-Crontab Persistence- Sets up a cron job to execute the hidden script on every reboot.

## Requirements
Root privileges (the script checks and prompts for this).
