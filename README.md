# PersistX
Tool for Persistence in Linux

# Overview
Linux persistence tool designed for stealthy post-exploitation scenarios.
![image](https://github.com/user-attachments/assets/8946dacd-b449-4f7f-bac1-1735a8ce5d3a)




## Options
1-Hook apt-get update command-Adds a post-install hook to execute a hidden script after any apt-get operations.

2-Crontab Persistence- Sets up a cron job to execute the hidden script on every reboot.

3-Generate SSH keypair-Creates an SSH keypair for persistent remote access.

## Usage
Run the script as root:

``sudo ./PersistX.sh``

## Requirements
Root privileges (the script checks and prompts for this).
