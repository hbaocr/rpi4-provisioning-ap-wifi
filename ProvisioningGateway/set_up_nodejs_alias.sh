#!/bin/bash
# need  to setup sothat  npm can run  in sudo
sudo ln -s "$(which node)" /usr/bin/node
sudo ln -s "$(which node)" /usr/lib/node
sudo ln -s "$(which npm)"  /usr/bin/npm