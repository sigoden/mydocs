# DynImgen: 自托管动态图片生成服务

DynImgen 是一款自托管动态图片生成服务，用来生成邀请海报，分享图片，用户名片等。

![demo](https://user-images.githubusercontent.com/4012553/172307949-8e739dcd-e322-44d7-8f29-6dd9aec87d71.gif)


## 使用步骤

1. 设计师导出设计图为svg文件

```svg
<svg>
  <rect />
  <image src="img.png" /> 
  <image src="qr.png" />
  <text>66666</text>
</svg>
```

2. 工程师编辑svg文件，把变动的部分用模板变量替代

```svg
<svg>
  <rect />
  <img src="{{ img | fetch }}">
  <img src="{{ qr | to_qr }}">
  <text>{{ code }}</text>
</svg>
```

3. 运行 `dynimgen`，必须确保svg模板在 `dynimgen` 工作目录下。

```sh
$ ls data
Times New Roman.ttf   poster1.svg

$ dynimgen data/
[2022-06-05T14:51:53Z INFO  dynimgen::generator] Mount `/poster1`
[2022-06-05T14:51:53Z INFO  dynimgen] Listen on 0.0.0.0:8080
```

4. 按照如下规则构建图片地址

```
<域名> + <模板文件路径> + ? + <模板变量>
```

例如,

- 域名: http://localhost:8080
- 模板文件路径: /poster1
- 模板变量: { img: "https://picsum.photos/250", qr: "dynimgen", code: 12345 }

组成链接:

http://localhost:8080/poster1?img=https://picsum.photos/250&qr=dynimgen&code=12345


访问该链接，你会得到一张PNG图片。

`dynimgen` 做了什么：

1. 请求路径中提取模板文件路径和变量数据
2. 将变量传递給模板引擎生成新的svg文件
3. 渲染svg文件为png文件，返回图片
 

## 方案优势

### 服务端渲染优势

- 没有浏览器兼容，平台兼容等问题
- 代码复用性高，h5、小程序、app的生成海报服务都可以使用。
- 能够及时方便的更新

### SVG模板优势

- 直接从PS/AI等设计软件导出SVG
- 不需要用html/canvas/dsl重现实现一遍
- 无损还原设计稿，不丢失任何细节
- 自由使用字体样式

### RUST优势

- 高性能，高并发
- 单可执行程序，跨平台，易部署

## 其他

[https://github.com/sigoden/dynimgen](https://github.com/sigoden/dynimgen)
