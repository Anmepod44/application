Improved Instructions for Freelancer - Hetzner Server Access

Server Details
--------------
1. IP Address: <Your_Server_IP>
2. Username: root (or temporary user)
3. SSH Key: key.pem (for secure access)

Instructions
------------
1. Use the SSH command with the provided .pem file:
   ssh -i path/to/key.pem root@<Your_Server_IP>

2. Run the installation script:
   bash install_modules.sh

3. Start the dashboard:
   python3 /application/main_app.py

4. Access the dashboard:
   http://<Your_Server_IP>:8080

Automated Features
------------------
- New modules added to /application/modules will be automatically detected and installed.
- Dependencies listed in each module's requirements.txt will be installed automatically.
- The system logs module errors and provides insights via module_errors.log.

Security Reminder
-----------------
Change the root password or disable the SSH key after the project.
