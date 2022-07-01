## 自用：

### 整理自以下项目:

rclone上传脚本来源
https://github.com/666wcy/qbittorent_rclone_upload

qBittorrent来源
https://github.com/gshang2017/docker/tree/master/qBittorrent

rclone
https://github.com/rclone/rclone

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|qBittorrent-qBittorrentEE|4.4.3.1-4.4.3.12|(amd64;arm64v8;arm32v7) 集成Trackers自动更新|
|rclone|1.50.2|(amd64;arm64v8;arm32v7) |



### docker命令行设置：

1. 创建qbittorrent容器

        docker create \
           --name=qbittorrent \
           -e QB_WEBUI_PORT=8989 \
           -e QB_EE_BIN=false \
           -e UID=1000 \
           -e GID=1000 \
           -e UMASK=022 \
           -p 6881:6881 \
           -p 6881:6881/udp \
           -p 8989:8989 \
           -v /配置文件位置:/config \
           -v /下载位置:/downloads \
           -v /上传脚本位置:/upload \
           --restart unless-stopped \
           greedcrow/qbittorrent:v2.1



### qBittorrent使用

### 变量:

|参数|说明|
|-|:-|
| `--name=qbittorrent` |容器名|
| `-p 8989:8989` |web访问端口 [IP:8989](IP:8989);(默认用户名:admin;默认密码:adminadmin);</br>此端口需与容器端口和环境变量保持一致，否则无法访问|
| `-p 6881:6881` |BT下载监听端口|
| `-p 6881:6881/udp` |BT下载DHT监听端口
| `-v /配置文件位置:/config` |qBittorrent配置文件位置|
| `-v /下载位置:/Downloads` |qBittorrent下载位置|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|
| `-e UMASK=022` |umask设置,默认为022|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e QB_WEBUI_PORT=8989` |web访问端口环境变量|
| `-e QB_EE_BIN=false` |(true\|false)设置使用qBittorrent-EE,默认不使用|
| `-e QB_TRACKERS_UPDATE_AUTO=true` |(true\|false)自动更新qBittorrent的trackers,默认开启|
| `-e QB_TRACKERS_LIST_URL=` |trackers更新地址设置,仅支持ngosang格式,默认为 </br>https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt |

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
| `本地端口3:8989` |web访问端口 [IP:8989](IP:8989);(默认用户名:admin;默认密码:adminadmin);</br>此端口需与容器端口和环境变量保持一致，否则无法访问|


### 搜索：

#### 开启：视图-搜索引擎:
##### 说明：

1. 自带 [https://github.com/qbittorrent/search-plugins/tree/master/nova3/engines](https://github.com/qbittorrent/search-plugins/tree/master/nova3/engines) 搜索插件
2. 其它搜索插件下载地址 [https://github.com/qbittorrent/search-plugins/wiki/Unofficial-search-plugins](https://github.com/qbittorrent/search-plugins/wiki/Unofficial-search-plugins)
3. 一些搜索插件网站需过墙才能用
4. jackett搜索插件需配置jackett.json(位置config/qBittorrent/data/nova3/engines)，插件需配合jackett服务的api_key。</br>可自行搭建docker版jackett(例如linuxserver/jackett)。

### 其它:

1. Trackers只有一个工作,新增的Trackers显示还未联系，需在qBittorrent.conf里 </br>旧：[Preferences]下增加Advanced\AnnounceToAllTrackers=true，</br>新：[BitTorrent]下增加Session\AnnounceToAllTrackers=true。


## rclone配置

在config文件夹下新建文件夹**rclone**，放入自己的**rclone.conf**配置文件


## 自动上传文件配置

编辑upload文件夹下的qb_auto.sh文件![]()

```
the_dir="${save_dir//\/downloads\//}"	#如果你修改了主下载地址，请修改这里

qb_version="4.3.0.1"	#qb版本
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

