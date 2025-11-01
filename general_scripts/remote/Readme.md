### ---------------------------------------------------------------
# For Creating ssh key gen and alias for remote ssh access
# create an ed25519 key (recommended)
ssh-keygen -t ed25519 -f ~/.ssh/my_key -C "sarathkumar@192.168.0.10"
# If asked for a passphrase: choose one for better security, or press Enter for none (less secure).


chmod 600 ~/.ssh/my_key
chmod 644 ~/.ssh/my_key.pub

ssh-copy-id -i ~/.ssh/my_key.pub sarathkumar@192.168.0.10
cat ~/.ssh/my_key.pub | ssh sarathkumar@192.168.0.10 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys'

Open (or create) ~/.ssh/config and add an entry like this:
Host mypi
  HostName 192.168.0.10
  User sarathkumar
  IdentityFile ~/.ssh/my_key
  IdentitiesOnly yes
  AddKeysToAgent yes

### ---------------------------------------------------------------
