#!/bin/bash

PASSWORD_FILE="passwords.gpg"
MASTER_PASSWORD="ENTER YOUR MASTER PASSWORD HERE"

encrypt_passwords() {
    echo "$1" | gpg --batch --yes --passphrase "$MASTER_PASSWORD" -c -o "$PASSWORD_FILE"
}

decrypt_passwords() {
    gpg --quiet --batch --yes --decrypt --passphrase "$MASTER_PASSWORD" "$PASSWORD_FILE" 2>/dev/null
}

generate_password() {
    tr -dc 'A-Za-z0-9!@#%&*' < /dev/urandom | head -c 12
    echo
}

add_password() {
    read -p "Enter service name (e.g., Gmail): " service
    read -s -p "Enter the password for $service: " password
    echo

    existing=""
    if [ -f "$PASSWORD_FILE" ]; then
        existing=$(decrypt_passwords)
    fi

    updated="$existing
$service: $password"

    encrypt_passwords "$updated" && echo "✔ Password for $service saved successfully!" || echo "✖ Error: Failed to encrypt and save password!"
}

retrieve_password() {
    read -p "Enter service name to retrieve password: " service

    if [ ! -f "$PASSWORD_FILE" ]; then
        echo "✖ Password file does not exist!"
        return
    fi

    result=$(decrypt_passwords | grep -i "^$service:")
    if [ -z "$result" ]; then
        echo "✖ No password found for $service!"
    else
        echo "🔑 $result"
    fi
}

search_passwords() {
    read -p "Enter partial service name to search: " keyword
    if [ ! -f "$PASSWORD_FILE" ]; then
        echo "✖ Password file does not exist!"
        return
    fi

    matches=$(decrypt_passwords | grep -i "$keyword")
    if [ -z "$matches" ]; then
        echo "✖ No passwords found matching '$keyword'"
    else
        echo "🔍 Matching Passwords:"
        echo "$matches"
    fi
}

view_all_passwords() {
    if [ ! -f "$PASSWORD_FILE" ]; then
        echo "✖ Password file does not exist!"
        return
    fi

    echo "📜 All Stored Passwords:"
    decrypt_passwords
}

delete_password() {
    read -p "Enter service name to delete password: " service

    if [ ! -f "$PASSWORD_FILE" ]; then
        echo "✖ Password file does not exist!"
        return
    fi

    existing=$(decrypt_passwords)
    match=$(echo "$existing" | grep -i "^$service:")

    if [ -z "$match" ]; then
        echo "✖ No password found for $service!"
        return
    fi

    filtered=$(echo "$existing" | grep -vi "^$service:")
    encrypt_passwords "$filtered" && echo "✔ Password for $service deleted!" || echo "✖ Error deleting password."
}

# Master password check
read -s -p "Enter Master Password: " input_password
echo
if [ "$input_password" != "$MASTER_PASSWORD" ]; then
    echo "✖ Incorrect Master Password! Exiting..."
    exit 1
fi

# Menu
echo "🔒 Password Manager"
while true; do
    echo ""
    echo "1. Generate Password"
    echo "2. Add Password"
    echo "3. Retrieve Password"
    echo "4. View All Passwords"
    echo "5. Delete Password"
    echo "6. Search by Partial Name"
    echo "7. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) generate_password ;;
        2) add_password ;;
        3) retrieve_password ;;
        4) view_all_passwords ;;
        5) delete_password ;;
        6) search_passwords ;;
        7) echo "👋 Exiting..."; exit ;;
        *) echo "✖ Invalid choice!" ;;
    esac
done
