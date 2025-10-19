# 🔒 Password Manager (Bash + GPG)

A simple **command-line password manager** written in **Bash**, using **GPG encryption** to securely store, retrieve, and manage passwords — all protected by a master password.

---

## ⚙️ Features
- 🔐 Secure password storage using GPG encryption  
- 🔑 Master password authentication  
- 🧩 Add, view, search, and delete saved passwords  
- ⚡ Generate strong random passwords  
- 🖥️ Simple and intuitive text-based interface  

---

## 🛠️ Requirements
Install the required packages (on Ubuntu/Linux):

```bash
sudo apt update
sudo apt install gpg bash coreutils
````

---

## 🚀 Steps to Run

1. **Open the project folder:**

   ```bash
   cd /path/to/pass
   ```

2. **Edit the script and set your master password:**

   ```bash
   nano pass.sh
   ```

   Replace this line:

   ```bash
   MASTER_PASSWORD="ENTER YOUR MASTER PASSWORD HERE"
   ```

3. **Make the script executable:**

   ```bash
   chmod +x pass.sh
   ```

4. **Run the password manager:**

   ```bash
   ./pass.sh
   ```

---

## 🧭 Menu Options

```
1. Generate Password
2. Add Password
3. Retrieve Password
4. View All Passwords
5. Delete Password
6. Search by Partial Name
7. Exit
```

---

## 🔐 Security Notes

* All passwords are stored **encrypted** in `passwords.gpg`.
* The **master password** is required to decrypt and access saved passwords.
* ⚠️ **If you forget your master password, stored data cannot be recovered.**

---

