

##### Third-party nodes join us, one-click startup, and join in the decentralized Tenon VPN network, providing services and routing
##### Currently supports: centos, debian, ubuntu ...

## Access steps
### 1. Download the code:

      git clone https://github.com/tenondvpn/tenonvpn-join.git
      or
      wget https://github.com/tenondvpn/tenonvpn-join/archive/master.zip

### 2. init system, system will restart after execution， node will start automatically

      bash init_env.sh
      
### 3. Check whether it is successful. If more than 7 ports are started, it is successful!

      netstat -nlp | grep net

# 
# 

第三方节点接入，一键式启动，并接入去中心化Tenon VPN网络，提供服务和路由

当前支持： centos, debian, ubuntu ...


## 接入步骤

### 1. 下载代码： 
  
      git clone https://github.com/tenondvpn/tenonvpn-join.git
      或者
      wget https://github.com/tenondvpn/tenonvpn-join/archive/master.zip
   

### 2. 初始化环境，执行完成后会重启系统，程序也会自动启动
      bash init_env.sh  

### 3. 检查是否成功，如果启动了7个端口以上，则成功了！

      netstat -nlp | grep net
    
    


