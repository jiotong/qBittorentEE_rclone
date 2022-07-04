## 自用qBittorrent整合rclone自动上传脚本：

### 整理自以下项目:

rclone上传脚本来源
https://github.com/666wcy/qbittorent_rclone_upload

qBittorrent来源
https://github.com/SuperNG6/Docker-qBittorrent-Enhanced-Edition

rclone
https://github.com/rclone/rclone

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|qBittorrentEE|4.3.9.10|(amd64;arm64)|
|rclone|1.50.2|(amd64;arm64) |



### docker命令行设置：

1. 创建qbittorrent容器
   ```bash
        docker create  \
           --name=qbittorrentee  \
           -e WEBUIPORT=8080  \
           -e PUID=1026 \
           -e PGID=100 \
           -e TZ=Asia/Shanghai \
           -p 6881:6881  \           
           -p 6881:6881/udp  \
           -p 8080:8080  \
           -v /配置文件位置:/config \
           -v /下载位置:/downloads \
           -v /上传脚本位置:/upload \
           --restart unless-stopped \
           greedcrow/qbittorrentee-rclone:lastest
     ```

     ```bash
          docker start qbittorrentee
     ```
     ```bash
          docker logs qbittorrentee
     ```
     ```bash
          docker restart qbittorrentee
     ```
     ```bash
          docker stop qbittorrentee
     ```
     ```bash
          docker rm qbittorrentee
     ```


### qBittorrent使用

1. 卷

|参数|说明|
|-|:-|
| `本地文件夹1:/downloads` |qBittorrent下载位置|
| `本地文件夹2:/config` |qBittorrent配置文件位置|
| `本地文件夹3:/upload` |rclone上传脚本配置文件位置|

2. 端口

|参数|说明|
|-|:-|
| `本地端口1:6881` |BT下载监听端口|
| `本地端口2:6881/udp` |BT下载DHT监听端口|
| `本地端口3:8080` |web访问端口 http://IP:8080;(默认用户名:admin;默认密码:adminadmin);</br>此端口需与容器端口和环境变量保持一致，否则无法访问|


### 搜索：

#### 开启：视图-搜索引擎:
##### 说明：

1. 自带 [https://github.com/qbittorrent/search-plugins/tree/master/nova3/engines](https://github.com/qbittorrent/search-plugins/tree/master/nova3/engines) 搜索插件
2. 其它搜索插件下载地址 [https://github.com/qbittorrent/search-plugins/wiki/Unofficial-search-plugins](https://github.com/qbittorrent/search-plugins/wiki/Unofficial-search-plugins)
3. 一些搜索插件网站需过墙才能用
4. jackett搜索插件需配置jackett.json(位置config/qBittorrent/data/nova3/engines)，插件需配合jackett服务的api_key。</br>可自行搭建docker版jackett(例如linuxserver/jackett)。


## rclone配置

在config配置文件夹下新建文件夹**rclone**，放入自己的**rclone.conf**配置文件


## 自动上传文件配置

编辑upload文件夹下的qb_auto.sh文件![]()

```
the_dir="${save_dir//\/downloads\//}"	#如果你修改了主下载地址，请修改这里

qb_version="4.3.9"	#qb版本
qb_username="admin"		#qb用户名
qb_password="adminadmin"	#qb密码
qb_web_url="http://localhost:8080"	#qb的web地址
leeching_mode="true"	#这个不用管
log_dir="/config/log"	#需要打印的日志地址
rclone_dest="yun"		#需要上传的rclone驱动器名称
rclone_parallel="32"	#rclone上传线程
auto_del_flag="test"	#上传完成后将种子改变的分类名
```

默认上传后不删除文件，如果需要删除，将sh中所有的**#qb_del**的#号删除



## qb命令配置

设置 **Torrent 完成时运行外部程序**

```shell
bash /upload/qb_auto.sh  "%N" "%F" "%R" "%D" "%C" "%Z" "%I"
```



## 效果展示

![qb配置](https://github.com/jiotong/qbittorent_rclone/raw/main/qb.png)

