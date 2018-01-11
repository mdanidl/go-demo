#!/bin/bash

sudo apt-get update && apt-get upgrade
sudo apt-get install awscli -y

export APP_VERSION=${v_num}

sudo echo 'APP_VERSION=${v_num}' >> /etc/environment

wget https://s3-eu-west-1.amazonaws.com/ecsd-mdanidl/go-demo/artifacts/${v_num}/go-demo

sudo chmod +x ./go-demo
sudo mv ./go-demo /usr/local/bin/go-demo

sudo sed -i 's/exit 0/d' /etc/rc.local
sudo echo "go-demo >> /var/log/go-demo.log 2>&1 &" >> /etc/rc.local
go-demo >> /var/log/go-demo.log 2>&1 &
