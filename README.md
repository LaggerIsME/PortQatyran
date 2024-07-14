<div align="center">

![PortQatyran Blue](https://github.com/LaggerIsME/PortQatyran/assets/98150971/309363a2-8db6-41fe-885d-32ccf0dc4380)

**Automated network scanner for hunting IPs and port changes**

![image](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![image](https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white)
![image](https://img.shields.io/badge/Debian-A81D33?style=for-the-badge&logo=debian&logoColor=white)
![image](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![image](https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)
</div>


## What is this?
PortQatyran is an automated network scanner designed to hunt for IP and port changes. Based on the [rustscan scanner](https://github.com/RustScan/RustScan), it efficiently scans networks for open ports, logs executed commands, and sends notifications in chat via Telegram about the scan results. The tool is highly configurable, allowing users to set scanning frequencies and manually initiate scans.

## Why "PortQatyran"?
The name "PortQatyran" is inspired by the Kazakh word for shark "qatyran" symbolizing its efficiency and speed in detecting network changes. The logo represents an RJ-45 connector with a shark face, which is usually used to connect equipment ports.

## Features
* **Fast Network Scanning**: Quickly scans networks for open port IP addresses
* **Scheduling**: Set the scanning frequency using cron jobs
* **Sandboxed Application**: Runs in a secure, isolated environment
* **Logging**: Logs all executed commands for auditing.
* **Easy Setup**: Simple configuration via environment files.
* **Configuration Display**: Shows tool configuration with the qatyranfetch command.
* **Manual Scanning**: Initiate scans manually using the portqatyran command.
* **Telegram Notifications**: Sends scan results via Telegram.
* **Notification Modes**: Supports aggressive and passive notification modes (passive mode in progress).

## Tools and libraries
* Bash
* Rustscan
* Cron
* Curl
* Nmap
* Debian 12
* Docker
* Docker Compose

## Usage
* Clone the repository: 
```bash 
git clone https://github.com/LaggerIsME/PortQatyran.git
```
* Download and install a Docker: https://docs.docker.com/engine/install/
* Move to the directory: 
```bash 
cd PortQatyran
```
* Copy the `example.env` to `.env`:
```bash
cp example.env .env
```
* Configure variables in `.env` file:
```bash
# Timezone settings
DEFAULT_TIMEZONE="Asia/Almaty"

# Rustscan settings
# Could be "random" or "serial"
SCAN_MODE="serial"
# Number of ports to scan at once
BATCH_SIZE=1000
# IP Addreses for scan. Write without spaces.
PREY_IPS="127.0.0.1,192.168.124.200"
# Set Only Ports or Port Range
# Ports. Write without spaces
#PORTS="80,443,5432"
# Port range
PORT_RANGE="0-65535"
# Exlude ports. Write without spaces.
EXCLUDE_PORTS=""

# PortQatyran settings.
# Could be "aggresive". In future will be "pacific"
NOTIFICATION_MODE="aggresive"
TELEGRAM_BOT_TOKEN=""
TELEGRAM_CHAT_ID=""
```
* Move to the directory: 
```bash 
cd network_scanner/
```
* Configure schedule in `auto.cronjob` file:
```bash
# For example: every 2 minutes run rustscan
*/2 * * * * /bin/bash -l -c "/app/scripts/main.sh $NOTIFICATION_MODE"
```
## About us
* Tool creator: LaggerIsME ([@LaggerIsME](https://github.com/LaggerIsME) | [LinkedIn](https://www.linkedin.com/in/pythondelay/))
* Logo designer: NoyanTM ([@NoyanTM](https://github.com/NoyanTM) | [LinkedIn](https://www.linkedin.com/in/noyantendikov/))

## License
PortQatyran is licensed under the [GNU General Public License v3.0](https://github.com/LaggerIsME/PortQatyran/blob/master/LICENSE)
