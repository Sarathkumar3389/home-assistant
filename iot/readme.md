
1. Tapo 110 Smart Plug- Macbook device control 
   Check "README.md" for its IP address
   
   Step-1:
   mkdir -p ~/home-assistant && cd ~/home-assistant
   python3 -m venv venv
   ./venv/bin/pip install tapo
   Step-2:
   run the script manually to test
   ~/home-assistant/venv/bin/python iot/tapo110/battery_guard.py

   Step-3:
   mkdir -p ~/.config/systemd/user
   
   cat << 'EOF' > ~/.config/systemd/user/battery-guard.service
   [Unit]
   Description=Check MacBook battery and toggle Tapo P110

   [Service]
   Type=oneshot
   ExecStart=%h/tapo-battery/venv/bin/python %h/tapo-battery/battery_guard.py
   EOF


2. 

