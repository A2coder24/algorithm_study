---
title: 博客搭建过程
---

## 记录自己怎么从零开始搭建一个简单的博客。

使用 hexo 框架，文件托管在 Github，Netlify 部署网站，国内访问使用 Cloudflare 进行 CDN 加速。整个过程不需要服务器，备案，只需要一个域名。

下面介绍博客搭建的过程，以及工具及其用法。

## 使用的工具和环境

在虚拟机上进行博客搭建的，操作系统是 Ubuntu 22.04.5 LTS。怎么使用虚拟机、装 Ubuntu 系统网络上有很多了，我就不多赘述。

## hexo 框架

### 介绍

![](../asset/hexo_1.png)
hexo 基于 Nodejs 的静态网页生成框架，它支持 Markdown 语法，编辑简单，能够快速生成 html 文件，部署简单，兼容性强

### 环境配置

使用 hexo 首先需要 Nodejs 环境，搜索官网进行下载，自行选装版本(LTS)。

![](../asset/nodejs_1.png)

```bash
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 22
```

> 注: 使用 Ubuntu 自带的 apt 或 apt-get 包管理系统，会导致系统无法拉起 GNOME 桌面，建议使用官方下载

输入以下命令，验证是否安装成功，输出正确版本信息，说明环境配置成功。

```bash
# Verify the Node.js version:
node -v # Should print "v22.22.2".

# Verify npm version:
npm -v # Should print "10.9.7".
```

由于 npm 使用官方源下载比较慢，输入以下命令，设置为国内源。

```bash
npm config get registry # 查看设置的源

npm config set registry https://registry.npmmirror.com # 设置为国内源

npm config get registry # 查看是否设置成功
```

### 博客生成

#### 安装

使用 npm 包管理器，安装 Hexo，输入一下命令：

```bash
npm install hexo-cli -g # 全局安装hexo命令行工具
```

> 其中 -g 参数表示全局安装，没有这个参数就只在当前目录下安装，建议全局安装。

### 初始化

```bash
hexo init "博客目录名" # 目录名称不含空格的时候双引号可以省略
```

输出如下：

```bash
INFO  Cloning hexo-starter https://github.com/hexojs/hexo-starter.git
INFO  Install dependencies
# 一些可能的中间信息
INFO  Start blogging with Hexo!
```

进入博客目录，安装所需依赖

```bash
cd "博客目录名"
npm install # 所安装依赖可以在package.json文件的dependencies字段中找到
```

### 博客目录组成

查看目录结构：

```bash
tree -L 1
```

结果如下：

```bash
.
├── _config.landscape.yml
├── _config.yml
├── db.json
├── node_modules
├── package.json
├── package-lock.json
├── public
├── scaffolds
├── source
└── themes
```

简单说明一下各文件含义：

- \_config.yml 为全局配置文件，网站的很多信息都在这里配置，比如说网站名称，副标题，描述，作者，语言，主题等等。具体可参考官方文档：[https://hexo.io/zh-cn/docs/configuration](https://hexo.io/zh-cn/docs/configuration)
- source 里面的\_post 文件夹，存放网站的 markdown 文件，初始化之后，可以看到里面有一个 hello\-world.md 文件。同时也可以创建文件夹用来存放 md 文件所引用的图片
- themes 网站主题目录，用来存放主题。hexo 有很多主题支持，更多主题：[https://hexo.io/themes](https://hexo.io/themes)

### 博客添加新文章

```bash
hexo new post "test" # 会在 source/_posts/ 目录下生成文件 ‘test.md’，打开编辑
hexo generate        # 生成静态HTML文件到 /public 文件夹中
hexo server          # 本地运行server服务预览，打开 http://localhost:4000 即可预览你的博客
```

本地预览效果：
![](../asset/hexo_2.png)
