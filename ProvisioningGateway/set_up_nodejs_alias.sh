#!/bin/bash
# The  sudo only recognize the PATH  in secure_path in file in /etc/sudoers
# To see more details : run cmd :  
# sudo visudo


# Approviate  1: Alias node and npm into  the /usr/bin which default find sudo
sudo ln -s "$(which node)" /usr/bin/node
sudo ln -s "$(which node)" /usr/lib/node
sudo ln -s "$(which npm)"  /usr/bin/npm

# Approviate  2: edit secure_path to add your node path (in file /etc/sudoers)
# From :
# Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin
# To :
# Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:<path to node  folder>