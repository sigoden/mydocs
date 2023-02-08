# Xf: 多态命令，自动脚本别名

Xf 是一款多态命令，自动脚本别名的命令行工具。

Xf 会从当前目录往上寻找目标文件，根据找到的不同文件执行不同的命令。

## 介绍

Xf 读取配置文件加载规则。

> 配置文件默认位置是 `$HOME/.xf`，可以设置 `XF_CONFIG_PATH` 环境变量指定其他位置

规则格式为:

```
<文件>: <命令>
```

`xf` 尝试查找 `<文件>`，找到后该执行 `<命令>`。

> `xf` 内置一条优先级最低规则: `Xfile: $file $@`


配置如下规则：

```
Taskfile: bash $file $@
```

执行 `xf foo`。

首先，xf会在当前目录查找 `Taskfile` 文件，如果找到则执行 `bash $file foo`.

如果未找到，则在当前目录继续寻找 `Xfile` 文件 ，如果找到则执行 `Xfile foo` (内置规则).

如果都未找到，则进入上层目录继续这个流程。
 
文件匹配规则:

1. 忽略大小写。`Xfile` 能匹配文件 `xfile`， `xFile`。

2. 查找文件名包含规则文件名。`Xfile` 能匹配文件 `Xfile.sh`，`Xfile.cmd`。

## 变量

规则命令中可以使用如下内置变量 

- `$@` - 透传命令行参数
- `$file` - 文件路径
- `$fileDir` - 文件目录，命令在文件目录中执行
- `$currentDir` - 当前目录


这些变量(`$@`除外)也会同步到环境变量:

- `$file` => `$XF_FILE`
- `$fileDir` => `$XF_FILE_DIR`
- `$currentDir` => `$XF_CURRENT_DIR`

## 命令名

实际上，命令名称会影响内置规则和环境变量前缀。

如果将可执行文件 `xf` 重命名为 `task`

1. 内置规则将是 `Taskfile: $file $@`

2. 默认的配置文件路径将变成 `$HOME/.task`。

3. 环境变量 `XF_CONFIG_PATH` 变成 `TASK_CONFIG_PATH`。

4. `$file` 对应环境变量将变成 `TASK_FILE`。

## 其他

[https://github.com/sigoden/xf](https://github.com/sigoden/xf)
