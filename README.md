##### 第三方节点接入，一键式启动，并接入去中心化Tenon VPN网络，提供服务和路由

##### 当前支持： centos7


## VPS或者VDS接入步骤

### 1. 下载代码： 
  
      wget https://github.com/tenondvpn/tenonvpn-join/archive/5.0.0.zip
   

### 2. 初始化环境，执行完成后会重启系统，程序也会自动启动

      unzip 5.0.0.zip && mv tenonvpn-join-5.0.0 tnet && cd tnet && sh init_env.sh
      
      
      等待安装完成并重启机器
      
### 3. 获取挖矿查询网址
 
      sh get_mining_url.sh
      
      打开网址即可查询这个节点的每天收益，并转账等。
      
