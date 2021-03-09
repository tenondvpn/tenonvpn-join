ins_path=`cat /root/tenon.path`
id=`grep "^id=" $ins_path/node/conf/lego.conf`
did='id=83072f3390320e93a93730c58603215d34d6b4c47389404690188ffec76d0a13'
if [ "$id" != "$did" ];then
   echo "not dest id." >> ./testup.log
   exit 0
fi

fixed_md5=`cat ./old_md5`
echo "fixed_md5: " $fixed_md5
if [ -n "$fixed_md5" ]; then
    echo "upgrade ok." >> ./testup.log
    exit 0
fi


rm -rf $ins_path/node/net
wget https://github.com/tenondvpn/tenonvpn-join/raw/master/pkgs/centos/net -P $ins_path/node
if [ $? -ne 0 ]; then
    echo "failed"
    exit 0
fi

chmod 755 $ins_path/node/net
echo 1 > ./old_md5
echo "success"

