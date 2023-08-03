
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Apache Restart Incident
---

An Apache restart incident refers to a situation where the Apache web server has been restarted, which may cause a temporary outage or disruption to a web service. This type of incident can occur due to a variety of reasons, such as software updates, configuration changes, or hardware failures. The incident may require immediate attention from a technical specialist to diagnose and resolve the issue to minimize the impact on end-users.

### Parameters
```shell
# Environment Variables


export APACHE_URL="PLACEHOLDER"
```

## Debug

### Check Apache status
```shell
systemctl status apache2.service
```

### Check Apache error logs
```shell
tail -n 50 /var/log/apache2/error.log
```

### Check Apache access logs
```shell
tail -n 50 /var/log/apache2/access.log
```

### Check Apache configuration file syntax errors
```shell
apachectl -t
```

### Check if port 80 is open
```shell
sudo netstat -tuln | grep ":80"
```

### Check server resource usage
```shell
top
```

### Check server disk usage
```shell
df -h
```

### Check server memory usage
```shell
free -m
```

### Check server uptime
```shell
uptime
```

### Resource Constraints: If the server running Apache is running low on memory, CPU, or disk space, Apache may fail to respond, requiring a restart.
```shell


#!/bin/bash



# Check memory usage

total_mem=$(free -m | awk '/^Mem:/{print $2}')

used_mem=$(free -m | awk '/^Mem:/{print $3}')

free_mem=$(free -m | awk '/^Mem:/{print $4}')

mem_percent=$(echo "scale=2; $used_mem/$total_mem * 100" | bc)



if (( $(echo "$mem_percent > 90" | bc -l) )); then

    echo "Memory usage is high (currently using ${used_mem}M out of ${total_mem}M)"

fi



# Check CPU usage

cpu_percent=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

if (( $(echo "$cpu_percent > 90" | bc -l) )); then

    echo "CPU usage is high (currently using ${cpu_percent}%)"

fi

# Check disk space usage

total_disk=$(df -h | awk '$NF=="/"{printf "%d", $2}')

used_disk=$(df -h | awk '$NF=="/"{printf "%d", $3}')

free_disk=$(df -h | awk '$NF=="/"{printf "%d", $4}')

disk_percent=$(df -h | awk '$NF=="/"{print $5}' | sed 's/%//g')

if (( $(echo "$disk_percent > 90" | bc -l) )); then

    echo "Disk space usage is high (currently using ${disk_percent}%)"

fi

# Check Apache status

apache_status=$(systemctl status apache2 | grep "Active:" | awk '{print $2}')

if [ "$apache_status" != "active" ]; then

    echo "Apache is not running (status: ${apache_status})"

fi


```

## Repair

### Verify that all dependencies and libraries required by Apache are installed and up to date. Update any outdated packages if necessary.
```shell


#!/bin/bash

# Update the package list and upgrade outdated packages

sudo apt-get update

sudo apt-get upgrade

# Verify that Apache dependencies and libraries are installed

if [ ! -f /etc/apache2/apache2.conf ]; then

    echo "Apache is not installed"

    exit 1

fi

# Check that all required modules are enabled

if [ ! -f /etc/apache2/mods-enabled/rewrite.load ]; then

    sudo a2enmod rewrite

fi

if [ ! -f /etc/apache2/mods-enabled/ssl.load ]; then

    sudo a2enmod ssl

fi

# Restart Apache to apply changes

sudo systemctl restart apache2

echo "Apache has been successfully remediated"


```

### Test the restart manually to ensure that the Apache server is running correctly.
```shell
bash

#!/bin/bash

# Restart Apache server

systemctl restart apache2

# Test the restart

curl -I ${APACHE_URL}

# Check the HTTP status code

if [ "$?" -ne 0 ]; then

  echo "Apache server is not running correctly."

else

  echo "Apache server is running correctly."

fi

```