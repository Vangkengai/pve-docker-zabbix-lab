# pve-docker-zabbix-lab

Proxmox VE 嵌套虚拟化、Docker 容器运维、网络治理与 Zabbix 告警闭环

# PVE & Docker Infrastructure with Zabbix Monitoring Lab

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Environment](https://img.shields.io/badge/PVE-Nested-orange.svg)
![Container](https://img.shields.io/badge/Docker-Zabbix--Stack-blue.svg)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-brightgreen.svg)
![Scripting](https://img.shields.io/badge/Automation-Python%20%7C%20Shell-blue.svg)
![Alerting](https://img.shields.io/badge/Webhook-DingTalk-brightgreen.svg)

本项目记录嵌套虚拟化环境部署 Proxmox VE 平台、Docker 容器化架构、网络端口治理、LVM 存储扩容以及 Zabbix + 钉钉机器人自动化监控告警闭环的完整运维实践，并集成 GitHub Actions 自动化持续交付与 Python/Shell 脚本编排。

## 架构

```text
[ Developer (Git Push) ] ──> [ GitHub Repo ] ──> [ GitHub Actions (CI/CD Pipeline) ]
                                                           │
                                                           │ (SSH 自动部署)
                                                           ▼
[ Windows 宿主机 ]
   └── [ PVE 嵌套虚拟化平台 ]
         └── [ Debian VM (Docker Host) ]
               ├── Nginx Container (Port 80/8080)
               ├── Zabbix Server & Web (Port 10051/8080)
               ├── Zabbix Agent 2 (指标采集) ──> DingTalk Webhook 告警
               └── Python / Shell Scripts (JSON-RPC API 交互 & 故障自愈)
```
<img width="1900" height="1143" alt="image" src="https://github.com/user-attachments/assets/ff1ae229-a887-4631-b994-faaf3e7b226c" />
<img width="1812" height="1133" alt="image" src="https://github.com/user-attachments/assets/06b2d176-428b-426b-9245-0a5dc4635159" />
<img width="530" height="460" alt="b07e64a6-5506-48d8-9eea-2a01ca8efa14" src="https://github.com/user-attachments/assets/8a2b43d4-c0b3-465f-82e0-65d319e662b0" />
