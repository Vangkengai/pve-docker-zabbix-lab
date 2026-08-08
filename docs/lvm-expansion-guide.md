# PVE 薄池空间溢出导致 QEMU io-error 的排查与在线扩容复盘

## 1. 故障现象
PVE 虚拟机（Debian）突发卡死，控制台抛出 `QEMU io-error`，虚拟机自动进入 `Paused` 挂起状态。

## 2. 根因分析
执行 `pvesm status` 检查存储，发现 PVE 的 `local-lvm` 薄池（Thin Pool）使用率达到 100%，触发了 KVM 的 I/O 保护机制，防止虚拟机数据损坏。

## 3. 解决步骤
1. **磁盘无损分区拉伸**：
   使用 `cfdisk /dev/sda` 调整宿主机物理磁盘分区，扩容 `/dev/sda3`。
2. **刷新物理卷 (PV)**：
   ```bash
   pvresize /dev/sda3
