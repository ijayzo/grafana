#!
clear
echo "starting the node exporter"
echo
sudo systemctl restart prometheus
echo 
echo "check <ip>:9100 on your web browser"
sudo yum install -y https://dl.grafana.com/oss/release/grafana-11.1.4-1.x86_64.rpm
echo
echo
sudo systemctl enable --now grafana-server 
echo
echo
echo "access your grafana server at <ip>:3000 using admin/admin"

