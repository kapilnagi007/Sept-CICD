#!/usr/bin/env bash


sudo apt-get update
echo "Ubuntu Package Index"


sudo apt-get install docker nginx -y 
echo "Docker and Nginx is installed"


sudo systemctl enable --now docker
echo "Docker is Enabled"

sudo systemctl enable --now nginx
echo "Nginx is Enabled"

sudo docker --version
sudo docker run --rm hello-world
echo "verified docker is working"

sudo nginx -v
sudo systemctl is-active --quiet nginx


echo "Docker and Nginx is installed"