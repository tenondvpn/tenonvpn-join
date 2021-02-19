rm -rf ./upgrade.sh*
wget --no-check-certificate https://github.com/tenondvpn/tenonvpn-join/raw/master/upgrade.sh
chmod 777 ./upgrade.sh
sh  ./upgrade.sh
>test.log
idx=0
for ((i=1; i<=10; i++))
do
    pid=$(pidof net)
    if [ ! -n "$pid" ]; then
      ((idx++))
      echo "IS NULL "$pid" test" >> test.log
      sleep 1
    else
      echo "not NULL "$pid" test" >> test.log
    fi
done

ins_path=`cat /root/tenon.path`
echo $ins_path
echo $idx
if [ "$idx" -eq "10" ]; then
    echo "restart net"
    sh restart.sh
fi
iptables -F

fast_net=`ps -ef | grep fast_net | grep init.d | awk -F' ' '{print $2}'`
if [ ! -n "$fast_net" ]; then
 /etc/rc.d/init.d/fast_net.sh &
fi
