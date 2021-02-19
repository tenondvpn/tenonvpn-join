#!/bin/bash
#chkconfig: 2345 70 30
#description: 
ins_path=`cat /root/tenon.path`
while((1))
do
    pid=$(pidof net)
    if [ ! -n "$pid" ]; then
      echo "IS NULL "$pid" test"
      cd $ins_path/node ;  ./net -f 0 -g 0 &
        
    fi
    sleep 0.1
done

