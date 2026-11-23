
1. Tapo 110 Smart Plug- Macbook device control 
   Check "README.md" for its IP address
   
   Step-1:
      mkdir -p ~/home-assistant && cd ~/home-assistant
      python3 -m venv venv
      ./venv/bin/pip install tapo
   Step-2: run the script manually to test
      ~/home-assistant/venv/bin/python iot/tapo110/battery_guard.py

   Step-3: Create Service file
      mkdir -p ~/.config/systemd/user
      
      cat << 'EOF' > ~/.config/systemd/user/battery-guard.service
      [Unit]
      Description=Check MacBook battery and toggle Tapo P110

      [Service]
      Type=oneshot
      WorkingDirectory=/home/sarathkumar/home-assistant
      ExecStart=/home/sarathkumar/home-assistant/venv/bin/python /home/sarathkumar/home-assistant/iot/tapo110/battery_guard.py
      EOF


   Step-3: Create timer file
         cat << 'EOF' > ~/.config/systemd/user/battery-guard.timer
      [Unit]
      Description=Run Battery Guard every minute

      [Timer]
      OnBootSec=1min
      OnUnitActiveSec=1min
      AccuracySec=5s

      [Install]
      WantedBy=timers.target
      EOF
   
   Step-4: Enable the service
      systemctl --user daemon-reload
      systemctl --user enable --now battery-guard.timer

   INFOS:
   - Verify the service command
      journalctl --user -u battery-guard.service -n 10
      
   - Stop whenever automation goes to Home Assistant server
      systemctl --user disable --now battery-guard.timer



2. 

