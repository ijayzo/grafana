# grafana

using https://www.fosstechnix.com/install-prometheus-and-grafana-on-ubuntu-22-04/ as a reference.

---

@ Local Machine

Please follow instructions in the "Terraform instances" README (https://github.com/ijayzo/terraformInstances/) if you want to create the instance with terraform and aws cli using my repos. Otherwise, the process is to create an aws instance (bigger than t2.micro).After the ec2 instance is created, make sure to copy in all the files that are not terraform files into the ec2 machine (service files, and scripts).

---

@ EC2 Instance

Add the service files to the /etc/systemd/system/ directory with the names defined in the repo. 

Add the script files anywhere, but remember to make them executable and to add the .sh suffix to the file (run the command to create the script in your working directory and then change permissions i.e. vi script.sh ; chmod u+x script.sh).

	To run the script, the command will be the absolute path of the script i.e. ~/script.sh.

	The first script has an output at the end that must be appended to the specified yaml file, as well as editted to include the correct ip address. This script will download and install prometheus. It gets the node-explorer ready as well. 

	The second scrript will downlaod and install grafana.
	
	The third script is useful only if you reboot machine and don't have SELinux persistently disabled or in permissive mode. 

---

@ Web Browser

Input <EC2 Public IPv4 address>:<port> in your web browser. 
	
	9090 Prometheus 
	9100 Node Exporter
	3000 Grafana

- In Grafana (3000)
	
	# Configure Prometheus as Grafana DataSource	
	+ Click the hamburger (three lines), click the dropdown icon next to Connections, click on Data sources then Add Data sources and select Prometheus. 
	+ now configure Prometheus data source by providing Prometheus URL, i.e. http://3.22.104.246:9090

	# Creating Grafana Dashboard to Monitor Linux Server
	+ Easy way is to import dashboards from some other user. Click the hamburger, then dashboards, then the Plus sign with a dropdown icon, import dashboard and paste 14513, then click load.

	+ The not so easy way is to create dashboards with PromQL. PromQL syntax varies/depends on the table definition. 
	+ 


