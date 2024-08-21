#!
clear
sudo setenforce 0
sudo systemctl enable --now prometheus 
sudo systemctl enable --now node_exporter
sudo systemctl enable --now grafana-server
