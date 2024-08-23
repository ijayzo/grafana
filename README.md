# grafana

using https://www.fosstechnix.com/install-prometheus-and-grafana-on-ubuntu-22-04/ as a reference.

---

@ Local Machine

Please follow instructions in the "Terraform instances" README (https://github.com/ijayzo/terraformInstances/) if you want to create the instance with terraform and aws cli using my repos. Otherwise, the process is to create an aws instance (bigger than t2.micro). After the ec2 instance is created, make sure to copy in all the files that are not terraform files into the ec2 machine (service files, and scripts).

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
	- Differences in expressions from SQL: no need to use "select * FROM <desired query>" just name the desired query. Don't use WHERE to add a label to the metric, must use {label} and can do things like {label!=varable} and don't need AND from SQL, just use a comma, i.e. {label1=val1, label2=val2}. Can copy and paste labels from the prometheus webUI. SQL has OR, PromQL uses "=~" & using "|" (Regex). Instead of using NOT LIKE, we use the "!~" operator. WHERE Timestamp gets replaced with "@ <unix timestamp>"; if we cant 5 minutes from the previous time we user "<metric> offset 5m"; m is a time unit, multiple supproted by prometheus. 
	- We can use "/" to comment out a query, then "shift+Enter" makes new line.
	- Use [] to find metrics by a period of time, i.e. only see the last [5m] 
        - example = http_server_requests_seconds_count{uri="/api/todos", method="GET". status=~"2..|3..|4..", status!~"5.."}
	- Data types: (allows prometheus to work with time series data effectively and providing the flexibility in querying and analyzing metrics for monitoring and observability purposes)
		1. Scalar (simple numeric floating poing values) = i.e. sum(<metric>) will return a floating point number = aggregated value, no timestamp
		2. Instant Vector (a single vlaue at a given timestamp) = running the query for a metric will return (i.e.) 20@<unix timestamp> = used to retrieve current metric values or perform instant calculations 
		3. Ranged Vectors = select a range of samples back fro the current instant. use this data to easily calcultae rates of change, trends, or performing aggregations over a specified window.  
	- Differences in functions from SQL (find the functions allowd in docs): Group By gets replaced with "by (<group by particular label>)". Rate = (value at t(f) - value at t(i))/(period in seconds), iRate (value at t(f) - value at t(f-1))/(period in seconds), Increase (value at t(f) - value at t(i)). 
	- example SUM(http_server_requests_seconds_count{uri="/api/todos"})
	- example rate(http_server_requests_seconds_count{uri="/api/todos", method="GET". status=~"2..|3..|4..", status!~"5.."}[3m])
	- example histogram_quantile(0.9, sum by(le) (rate(<metric>[10m])))
	- Prometheus queries for the four "golden" metrics that help us monitor our realtime applications
		
		1. Traffic = Rate = (i.e.) sum(rate(http_request_duration_seconds_count{}[10m]))
		2. Error Rate = Error Rate = (i.e.) sum(rate(http_request_duration_seconds_count{code!="200"}[10m]))
		3. Latency = Duration = (i.e.) histogram_quantile(0.9, sum by(le) (rate(http_request_duration_seconds_bucket[10m])))
		4. Saturation = Saturation = (i.e.) 100 - (avg by (node) (irate(node_cpu_seconds_total{node="minikube"}[5m])) * 100)

			note : "RED" metrics = Rate, Error Rate, Duration 
	
	# CPU (Central Processing Unit) Utilization = quantifies the percentage of time a computer's central processor is actively engaged in executing tasks. = a system-level performance metric that measures how much CPU time (Total CPU time is the sum of user time and system time; and total elapsed time is the length of the monitoring interval) an application needs to process a request. = indication of the total percentage of processing power exhausted to process data and running various programs on a network device, server, or computer at any given point. 
	+ Besides top and htop, there are multiple other commands, such as mpstat, sar, and vmstat, in Linux, providing granular insights into system performance, including CPU utilization. top is the only one that comes pre-installed to Linux distros. 
	+ Here are some metrics that can be used to measure CPU utilization: 
	- User Time = the time the cpu spends executing user processes. The time the CPU spends executing instructions in user-mode processes. These processes are typically associated with applications and tasks initiated by the user.
	- System Time (Kernel Time) = the time the cpu spends executing system/kernel processes. 
	- Idle Time = the time the cpu is idle, not executing any processes 
	- I/O Wait Time = the time the cpu waits for i/o operations to complete 
	- Interrupt Time = Time spent handling hardware interrupts
	- CPU usage percentage = Calculated by dividing the total CPU time by the total elapsed time during the monitoring interval. =  the proportion of time the processor spends actively performing computations compared to its idle time
	- CPU pressure charts = High values in the some and full charts can indicate that processes are waiting for CPU resources, which can lead to high CPU utilization. 
	- Load average = For single-CPU systems, load average can be used to measure system utilization during a given time period. For systems with multiple CPUs, the load needs to be divided by the number of processors to get a comparable measure. 
	- Steal time = The percentage of time a virtual machine process waits for CPU time from the physical CPU. On a Linux server, the "top" command can be used to monitor processes and resource usage, where steal time is labeled as "st". 

		note : Other metrics that can be used to measure system resources include memory, disk, and network bandwidth. 







