# Opscan: 用 Rust 开发的端口扫描工具

## 特性

* 快, 1秒扫描6万个端口
* 简洁，扫一眼就会使用
* 易安装，提供全平台单可执行文件，无需安装下载即用

## 示例

列出所有本地监听端口:

```
$ opscan
127.0.0.1 22    ssh
127.0.0.1 631   ipp
127.0.0.1 12345 netbus
127.0.0.1 40559 unknown
```

测试某个端口是否畅通:

```
$ opscan www.baidu.com -p 80
www.baidu.com 80   http

$ opscan www.baidu.com -p 81
```

列出局域网内开放了某个端口的地址:

```
$ opscan 192.168.8 -p 22
192.168.8.5   22 ssh
192.168.8.4   22 ssh
```

扫描网站的 Top-N 端口:

```
opscan scanme.nmap.org -p top100
opscan scanme.nmap.org -p top666
```

使用 Docker:
```
docker run --rm -it sigoden/opscan opscan.nmap.org
```

详见 [https://github.com/sigoden/opscan](https://github.com/sigoden/opscan)