# PersistX
When you can't see it, it's already too late

# Overview

Linux persistence tool designed for stealthy post-exploitation scenarios.
 It includes functionalities for setting up persistence through crontab, hooking into the apt-get update command, and generating SSH keys for users.
 
Inspired by my earlier Linux persistence project (PersisLinuxAPT), this script combines few techniques I’ve studied into a all-in-one tool for Linux Persistence. (https://github.com/AgentN1c0l3/PersisLinuxAPT)
![image](https://github.com/user-attachments/assets/d640b656-2a41-48f1-a53a-7067548ea5a0)





## Options
 • Hook apt-get update command-Adds a post-install hook to execute a hidden script after any apt-get operations.

 • Crontab Persistence- Sets up a cron job to execute the hidden script on every reboot.

 • Generate SSH keypair-Creates an SSH keypair for persistent remote access.

## Usage
Run the script as root:

``sudo ./PersistX.sh``

## Requirements
Root privileges (the script checks and prompts for this).

## Note
Use the for educational purposes only.
