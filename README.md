# centos7-nginx


## Run

``` bash
docker run --privileged --restart=always -it -d  --hostname=vue-msf  --name=vue-msf-docker \
-p 2202:22 \
-p 80:80 \
-p 8000:8000 \
-p 8080:8080 \
-p 443:443 \
-p 6379:6379 \
-p 6380:6380 \
-p 6381:6381 \
-p 7379:7379 \
-p 7380:7380 \
-p 7381:7381 \
-v /d/PDT/data/html:/vue-msf/data/www \
daocloud.io/sunny5156/vue-msf-docker:latest

ps:/d/PDT/data/html 此路径修改成自己的路径
```

## ssh 登陆

``` bash
IP:127.0.0.1
端口:2202
账号:super
密码:123456
```

## 前端模块安装

``` javascript
sudo npm install 
```

## 代码热更新

``` bash
nodemon -L --exec "php" server.php start
```


