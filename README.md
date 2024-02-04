# docker-ghost
```使用docker自行搭建ghost部落格```
- [架構圖](#架構圖)
- [操作步驟](#操作步驟)
  - [將專案clone下來](#將專案clone下來)
  - [nginx部分](#nginx部分)
  - [mysql部分](#mysql部分)
  - [ghost部分](#ghost部分)
- [修改設定檔](#修改設定檔)
- [運行專案](運行專案)
- [訪問首頁](訪問首頁)
- [管理者介面](管理者介面)
- [參考](參考)
# 操作步驟
## 將專案clone下來
```
git clone https://github.com/JackViewLand/docker-ghost.git
```
將自己https憑證放在 ```nginx/certs``` 資料夾中

# 架構圖
<img width="774" alt="ghost-compose-context" src="https://github.com/JackViewLand/docker-ghost/assets/122655131/0bed11af-2f21-4c13-9bf2-853b63cd94c9">

# 修改設定檔
## nginx部分
  ### 修改ghost.conf
  ```
  vi nginx/conf/ghost.conf
  ```
  分為兩個server block 區塊，第一個 server block 監聽 ```http(80 port)```，第二個 server block 監聽```https(443 port)```
  ### ghost.conf
  * 請將兩個 server block 中的```server_name```換成自己的域名
  * 將```listen 443```區塊的 ssl_certificate 與 ssl_certificate_key 修改成自己憑證。
    ```
    server {
      listen 80 default_server;
      listen [::]:80;
      server_name ghost.jack0420.shop; #修改成自己的域名
    
    ```
    ```
    server {
      listen 443 ssl default_server;
      listen [::]:443 ssl;
      server_name ghost.jack0420.shop; #修改成自己的域名
      ssl_protocols TLSv1.2 TLSv1.3;
      ssl_certificate /etc/nginx/certs/self-sign.pem; #修改成自己的憑證
      ssl_certificate_key /etc/nginx/certs/self-sign.key; #修改成自己的憑證
    
    ```
  **如果目前還沒有ssl憑證，可以先將listen 443的區塊先行註解測試。**
## mysql部分
  ### 修改帳號密碼
  ```
  vi docker-compose.yml
  ```
  * docker-compose.yml
    ```
      mysql:
        image: mysql:latest
        container_name: mysql
        volumes:
          - ./dbdata:/var/lib/mysql:z  # Persist storage
        expose:
          - "3306"
        environment:
          - MYSQL_ROOT_PASSWORD=root #修改root密碼
          - MYSQL_DATABASE=ghostdata 
          - MYSQL_USER=ghost # 修改使用者名稱
          - MYSQL_PASSWORD=ghost #修改使用者密碼
        networks:
          - ghost
        restart: always
    ```
## ghost部分
  ```
  {
      "url": "http://ghost.jack0420.shop", #修改自己的域名
      "server": {
          "port": 2368,
          "host": "0.0.0.0"
      },
      "database": {
          "client": "mysql",
          "connection": {
              "host": "mysql",
              "port": 3306,
              "user": "ghost", #填入mysql使用者
              "password": "ghost", #填入mysql使用者密碼
              "database": "ghostdata", #填入使用的database
              "charset": "utf8mb4"
          }
      },
  ```
# 運行專案
```
docker-compose up -d
```

# 訪問首頁
<img width="1409" alt="ghost首頁" src="https://github.com/JackViewLand/docker-ghost/assets/122655131/13cd5d02-0f3e-43a1-8569-2d63805100ea">

# 管理者介面
要進入管理者介面，在域名後面帶上 ```/ghost``` 這個url

# 參考
* [Github-docker-compose-ghost-quickstart](https://github.com/robincher/docker-compose-ghost-quickstart)
