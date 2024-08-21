#!
sudo dnf update -y
sudo dnf install wget -y
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
cd /tmp/
wget https://github.com/prometheus/prometheus/releases/download/v2.54.0/prometheus-2.54.0.linux-amd64.tar.gz
tar -xvf prometheus-2.54.0.linux-amd64.tar.gz
cd prometheus-2.54.0.linux-amd64
sudo mv console* /etc/prometheus
sudo mv prometheus.yml /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus
sudo mv prometheus /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
echo
echo
echo verify the file 
echo
echo
sudo cat /etc/prometheus/prometheus.yml
echo
echo
echo hope you had your service file in place 
echo
echo
echo reload daemon
echo
echo
sudo systemctl daemon-reload
sleep 5
echo
echo
sudo systemctl enable --now prometheus
echo
echo
echo "please access <your public ipv4 address>:9090 to find the prometheus dashboard"
echo
echo
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
sudo tar xvfz node_exporter-*.*-amd64.tar.gz
sudo mv node_exporter-*.*-amd64/node_exporter /usr/local/bin/
sudo useradd -rs /bin/false node_exporter
echo
echo
echo "hope you had your node_exporter.service file in place"
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
echo
echo
echo "please add the following to the /etc/prometheus/prometheus.yml"
echo "- job_name: 'Node_Exporter'

    scrape_interval: 5s

    static_configs:

      - targets: ['<Server_IP_of_Node_Exporter_Machine>:9100']"


