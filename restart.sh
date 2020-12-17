pid=$(pidof net)
kill -9 $pid &
sleep 3
ins_path=`cat /root/tenon.path`
echo $ins_path
cd $ins_path && sh start_node.sh
iptables -F
