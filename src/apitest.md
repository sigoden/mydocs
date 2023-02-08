# Apitest: 接口自动化测试工具

Apitest 是一款使用类JSON的DSL编写测试用例的自动化测试工具。


## 安装

推荐从[Github Releases](https://github.com/sigoden/apitest/releases)下载可执行文件。

Apitest工具是单可执行文件，不需要安装，放到`PATH`路径下面就可以直接运行

```
# linux
curl -L -o apitest https://github.com/sigoden/apitest/releases/latest/download/apitest-linux 
chmod +x apitest
sudo mv apitest /usr/local/bin/

# macos
curl -L -o apitest https://github.com/sigoden/apitest/releases/latest/download/apitest-macos
chmod +x apitest
sudo mv apitest /usr/local/bin/

# npm
npm install -g @sigodenjs/apitest
```
## 开始使用

编写测试文件 `httpbin.jsona`

```
{
  test1: {
    req: {
      url: "https://httpbin.org/post",
      method: "post",
      headers: {
        'content-type': 'application/json',
      },
      body: {
        v1: "bar1",
        v2: "Bar2",
      },
    },
    res: {
      status: 200,
      body: { @partial
        json: {
          v1: "bar1",
          v2: "bar2"
        }
      }
    }
  }
}

```

运行测试

```
apitest httpbin.jsona

main
  test1 (0.944) ✘
  main.test1.res.body.json.v2: bar2 ≠ Bar2

  ...
```

用例测试失败，从Apitest打印的错误信息中可以看到, `main.test1.res.body.json.v2` 的实际值是 `Bar2` 而不是 `bar2`。

我们修改 `bar2` 成 `Bar2` 后，再次执行 Apitest

```
apitest httpbin.jsona

main
  test1 (0.930) ✔
```

## 特性

### JSONA-DSL

使用类JSON的DSL编写测试。文档即测试。

```
{
  test1: { @describe("用户登录")
    req: {
      url: 'http://localhost:3000/login'
      method: 'post',
      body: {
        user: 'jason',
        pass: 'a123456,
      }
    },
    res: {
      status: 200
      body: {
        user: 'jason',
        token: '', @type
        expireIn: 0, @type
      }
    }
  }
}
```

根据上面的用例，我不用细说，有经验的后端应该能猜出这个接口传了什么参数，服务端返回了什么数据。

Apitest 的工作原理就是根据`req`部分的描述构造请求传给后端，收到后端的响应数据后依据`res`部分的描述校验数据。

拜托不要被DSL吓到啊。其实就是JSON，减轻了一些语法限制(不强制要求双引号，支持注释等)，只添加了一个特性：注解。上面例子中的`@describe`,`@type`就是注解。

点击[jsona/spec](https://github.com/jsona/spec)查看JSONA规范

> 顺便说一句，有款vscode插件提供了DSL(jsona)格式的支持哦。

为什么使用JSONA？

接口测试的本质的就是构造并发送`req`数据，接收并校验`res`数据。数据即是主体又是核心，而JSON是最可读最通用的数据描述格式。
接口测试还需要某些特定逻辑。比如请求中构造随机数，在响应中只校验给出的部分数据。

JSONA = JSON + Annotation(注解)。JSON负责数据部分，注解负责逻辑部分。完美的贴合接口测试需求。

### 数据即断言

这句话有点绕，下面举例说明下。

```json
{
  "foo1": 3,
  "foo2": ["a", "b"],
  "foo3": {
    "a": 3,
    "b": 4
  }
}
```
假设接口响应数据如上，那么其测试用例如下:

```
{
  test1: {
    req: {
    },
    res: {
      body: {
        "foo1": 3,
        "foo2": ["a", "b"],
        "foo3": {
          "a": 3,
          "b": 4
        }
      }
    }
  }
}
```
没错，就是一模一样的。Apitest 会对数据的各个部分逐一进行比对。有任何不一致的地方都会导致测试不通过。

常规的测试工具提供的策略是做加法，这个很重要我才加一句断言。而在 Apitest 中，你只能做减法，这个数据不关注我主动忽略或放松校验。

比如前面的用例

```
{
  test1: { @describe("用户登录")
    ...
    res: {
      body: {
        user: 'jason',
        token: '', @type
        expireIn: 0, @type
      }
    }
  }
}
```

我们还是校验了所有的字段。因为`token`和`expireIn`值是变的，我们使用`@type`告诉 Apitest 只校验字段的类型，而忽略具体的值。

 ### 数据可访问

后面的测试用例很容易地使用前面测试用例的数据。

```
{
  test1: { @describe("登录")
    ...
    res: {
      body: {
        token: '', @type
      }
    }
  },
  test2: { @describe("发布文章")
    req: {
      headers: {
        authorization: `"Bearer " + test1.res.body.token`, @eval // 此处访问了前面测试用例 test1 的响应数据
      },
    }
  }
}
```

### 支持Mock

有了Mock, 从此不再纠结编造数据。

### 支持Mixin

巧用 Mixin，摆脱复制粘贴。

### 支持CI

本身作为一款命令行工具，就十分容易和后端的ci集成在一起。而且 apitest 还提供了`--ci`选项专门就ci做了优化。

### 支持TDD

用例就是json，所有你可以分分钟编写，这就十分有利于 tdd 了。

你甚至可以只写 `req` 部分，接口有响应后再把响应数据直接贴过来作为 `res` 部分。经验之谈 🐶

默认模式下(非ci)，当 Apitest 碰到失败的测试会打印错误并退出。 Apitest 有缓存测试数据，你可以不停重复执行错误的用例，边开发边测试， 直到走通才进入后续的测试。

同时，你还可以通过 `--only` 选项选择某个测试用例执行。

### 支持用户定义函数

这个功能你根本不需要用到。但我还是担心在某些极限或边角的场景下需要，所以还是支持了。

Apitest 允许用户通过 js 编写用户定义函数构造请求数据或校验响应数据。(还敢号称跨编程语言吗？🐶) 

### 跳过,延时,重试和循环

### 支持Form,文件上传,GraphQL

## 后记

项目仓库: [github.com/sigoden/apitest](https://github.com/sigoden/apitest)