##### 第三方节点接入，一键式启动，并接入去中心化Tenon VPN网络，提供服务和路由

##### 当前支持： centos7


## VPS或者VDS接入步骤

### 1. 下载代码： 
  
      yum install -y wget && wget https://github.com/tenondvpn/tenonvpn-join/archive/5.0.0.zip
   

### 2. 初始化环境，执行完成后会重启系统，程序也会自动启动

      yum install -y unzip && unzip 5.0.0.zip && mv tenonvpn-join-5.0.0 tnet && cd tnet && sh init_env.sh
      
      
      等待安装完成并重启机器
      
### 3. 获取挖矿查询网址
 
      sh get_mining_url.sh
      
      打开网址即可查询这个节点的每天收益，并转账等。
      
#
#
## NAT接入步骤
```diff
-     Nat节点接入，必须预先设置好连续的端口范围，比如  10000 ~ 10020，
-     即这台Nat机器开放了 10000 到 10020 之间的所有端口，
-     否则节点加入无效，也无法获取挖矿收益
```

### 1. 下载代码： 
  
      yum install -y wget && wget https://github.com/tenondvpn/tenonvpn-join/archive/5.0.0.zip
   

### 2. 初始化环境，执行完成后会重启系统，程序也会自动启动

      yum install -y unzip && unzip 5.0.0.zip && mv tenonvpn-join-5.0.0 tnet && cd tnet && sh init_env.sh min_port max_port
      
```diff  
+     其中 min_port: 开放的连续端口的最小值， max_port: 开放的连续端口的最大值
```
      等待安装完成并重启机器
      
### 3. 获取挖矿查询网址
 
      sh get_mining_url.sh
      
      打开网址即可查询这个节点的每天收益，并转账等。      
      
