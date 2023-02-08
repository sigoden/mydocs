# Argc: 轻松处理 shell 命令行参数

Argc 是一款可以轻松处理 shell 命令行参数的命令行工具

![demo](https://user-images.githubusercontent.com/4012553/158063004-e7a3534c-eb1a-47fb-9bbd-89a49345589a.gif)


使用 Argc 编写命令行程序，我们只需要做两件事情:

1. 在注释中描述我们需要的选项，参数，子命令
2. 调用如下命令委托 Argc 替我们处理命令行参数

```sh
eval "(argc $0 "$@")"
```
Argc 会为我们做如下工作:

1. 从注释中提取参数定义
2. 解析命令行参数
3. 如果参数有异常，输出错误文本或帮助信息
4. 如果一切正常，输出解析好的参数变量
5. 如果有子命令，调用子命令函数

我们可以很轻松地通过变量 `$argc_<选项名/参数名>` 访问对应选项或参数。

## 标签

Argc 依据根据标签 (注释中带`@`标记字段) 生成解析规则和帮助文档。

### @describe

```sh
@describe [string]

# @describe A demo cli
```

定义描述

### @version

```sh
@version [string]

# @version 2.17.1 
```

定义版本


### @author

```sh
@author [string]

# @author nobody <nobody@example.com>
```

定义作者

### @help
```sh
@help [false|string]

# @help false   
# @help Print help information
```
自定义帮助子命令

1. `# @help false` 不生成帮助子命令
2. `# @help Print help information` 自定义帮助子命令描述信息

### @cmd

```sh
@cmd [string]

# @cmd Upload a file
upload() {
}

# @cmd Download a file
download() {
}
```
定义子命令

### @option

```sh
# @cmd [short] [long][modifier] [notation] [string]

# @option    --foo                A option
# @option -f --foo                A option with short alias
# @option    --foo <PATH>         A option with notation
# @option    --foo!               A required option
# @option    --foo*               A option with multiple values
# @option    --foo+               A required option with multiple values
# @option    --foo[a|b]           A option with choices
# @option    --foo[=a|b]          A option with choices and default value
# @option    --foo![a|b]          A required option with choices
# @option -f --foo <PATH>         A option with short alias and notation
```

定义值选项

#### 修饰符

长选项名后面带的符号就是修饰符

- `*`: 选项可选，可有多个值
- `+`: 选项必选，可有多个值
- `!`: 选项必选
- `=value`: 选项带有默认值
- `[a|b|c]`: 选项可选项集合
- `[=a|b|c]`: 选项可选项集合，第一个可选项是默认值

#### 值占位

用来标示该选项是个值选项，而不是标志位。

如果不提供，默认使用选项名作为占位。

可以使用占位提示选项值类型 `<NUM>`, `<PATH>`, `<PATTERN>`, `<DATE>`


### @flag

```sh
@flag [short] [long] [help string]

# @flag     --foo       A flag
# @flag  -f --foo       A flag with short alias
```
定义标志选项

### @arg

```sh
@arg <name>[modifier] [help string]

# @arg value            A positional argument
# @arg value!           A required positional argument
# @arg value*           A positional argument support multiple values
# @arg value+           A required positional argument support multiple values
# @arg value[a|b]       A positional argument with choices
# @arg value[=a|b]      A positional argument with choices and default value
# @arg value![a|b]      A required positional argument with choices
```

定义位置参数

#### 修饰符

同[option修饰符](#%E4%BF%AE%E9%A5%B0%E7%AC%A6)


## 其他

[https://github.com/sigoden/argc](https://github.com/sigoden/argc)
