# ProjClean: 从系统中清除项目不必要文件目录

从系统中清除清理并删除包含库、依赖项、构建等的不必要目录。这些文件可以随时通过运行安装或构建命令轻松重新生成，清理它们可以节省磁盘空间，例如 Rust 项目中的 target 目录和 Node 项目中的 node_modules 目录。

![screenshot](https://user-images.githubusercontent.com/4012553/172361654-5fa36424-10da-4c52-b84a-f44c27cb1a17.gif)

## 命令行

```
USAGE:
    projclean [OPTIONS] [--] [PATH]

ARGS:
    <PATH>    Start searching from

OPTIONS:
    -h, --help              Print help information
    -r, --rule <RULE>...    Add a search rule
    -t, --targets           Print found target
    -V, --version           Print version information
```

查找 node_modules 文件夹

```
projclean -r node_modules
```

从 $HOME 开始查找 node_modules 文件夹

```
projclean $HOME -r node_modules
```

同时查找 node_moduels 文件夹 和 rust 项目的 target 文件夹

```
projclean $HOME -r node_modules -r target@Cargo.toml
```

## 规则

Projclean 根据搜索规则查找目标。

规则由两部分组成：

```
<target-folder>[@flag-file]
```

> 目标文件夹和标志文件都可以是纯文本或正则表达式。

标志文件用于过滤掉只匹配名称但不匹配项目的文件夹。
 
例如。 该目录包含以下内容：

```
.
├── misc-proj
│   └── target
└── rust-proj
    ├── Cargo.toml
    └── target
```

规则 `target` 匹配了所有 `target` 文件夹

```
$ projclean -t -r target
/tmp/demo/rust-proj/target
/tmp/demo/misc-proj/target
```

规则 `target@Cargo.toml` 仅匹配属于 rust 项目下 `target` 文件夹

```
$ projclean -t -r target@Cargo.toml
/tmp/demo/rust-proj/target
```

## 项目

常用项目的常用搜索规则：

| name    | command                                           |
| :------ | :------------------------------------------------ |
| js      | `-r node_modules`                                 |
| rs      | `-r target@Cargo.toml`                            |
| vs      | `-r '^(Debug\|Release)$@\.sln$'`                  |
| ios     | `-r '^(build\|xcuserdata\|DerivedData)$@Podfile'` |
| android | `-r build@build.gradle`                           |
| java    | `-r target@pom.xml`                               |
| php     | `-r vendor@composer.json`                         |

## 其他

[https://github.com/sigoden/projclean](https://github.com/sigoden/projclean)
