### 第三方节点接入，一键式启动，并接入去中心化Tenon VPN网络，提供服务和路由，并通过挖矿获取收益

### 当前支持： centos7

## 挖矿收益计算方式
    
    每天收益 = 总的广告收益 * (节点消耗带宽  / 整个平台消耗带宽) * (1 - 平台收益系数)
```diff
+   平台收益系数为 5%
```
    比如今天广告总收益100000币，共享节点消耗带宽10G，平台总消耗带宽1000G，则你加入节点的收益是:
    100000 * (10 / 1000) * (1 - 0.05) = 950
    
    即接入的当前节点今天收益 950Tenon 币


## VPS或者VDS接入步骤

### 1. 下载代码： 
  
      yum install -y wget && wget https://github.com/tenondvpn/tenonvpn-join/archive/5.0.2.zip
   

### 2. 初始化环境，执行完成后会重启系统，程序也会自动启动

      yum install -y unzip && unzip 5.0.2.zip && mv tenonvpn-join-5.0.2 tnet && cd tnet && sh init_env.sh
      
      
      等待安装完成并重启机器
      
### 3. 获取挖矿私钥和查询网址
      sh get_private_key.sh
 
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
  
      yum install -y wget && wget https://github.com/tenondvpn/tenonvpn-join/archive/5.0.2.zip
   

### 2. 初始化环境，执行完成后会重启系统，程序也会自动启动

      yum install -y unzip && unzip 5.0.2.zip && mv tenonvpn-join-5.0.2 tnet && cd tnet && sh init_env.sh min_port max_port
      
```diff  
+     其中 min_port: 开放的连续端口的最小值， max_port: 开放的连续端口的最大值
```
      等待安装完成并重启机器
      
### 3. 获取挖矿私钥和查询网址
      sh get_private_key.sh
 
      sh get_mining_url.sh
      
      打开网址即可查询这个节点的每天收益，并转账等。      
      
