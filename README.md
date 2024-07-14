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
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam diam erat, ultrices eget ultrices quis, cursus vitae metus. In feugiat sem turpis, eget auctor eros ultricies vitae. Cras hendrerit posuere felis a lobortis. Duis at ipsum eget eros vulputate lacinia pulvinar sit amet sapien. In lacinia sem quam, at rutrum neque consequat eget. Sed blandit mauris eget sollicitudin tristique. Suspendisse non sapien ac dui convallis vulputate quis nec elit. Maecenas viverra aliquet quam, a pretium lectus posuere non. Integer semper in lectus at fermentum. Vestibulum vehicula turpis massa, eget accumsan leo eleifend eget.

## About us
* Tool creator: LaggerIsME ([@LaggerIsME](https://github.com/LaggerIsME) | [LinkedIn](https://www.linkedin.com/in/pythondelay/))
* Logo designer: NoyanTM ([@NoyanTM](https://github.com/NoyanTM) | [LinkedIn](https://www.linkedin.com/in/noyantendikov/))

## License
PortQatyran is licensed under the [GNU General Public License v3.0](https://github.com/LaggerIsME/PortQatyran/blob/master/LICENSE)
