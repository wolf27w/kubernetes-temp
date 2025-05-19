#!/bin/bash
pod_seq=$(echo $POD_NAME | awk -F"-" '{print $3}')
if [[ ${pod_seq} -ne 0 ]];then    #为从机
    sed -i '/^slaveof /d' /usr/local/etc/redis/redis.conf
    echo "slaveof redis-sentinel-0.redis-sentinel 6379" >> /usr/local/etc/redis/redis.conf #redis-0.redis代表第一个redis的访问地址
fi
/usr/local/bin/redis-server /usr/local/etc/redis/redis.conf
sleep 15    #如果redis-0没起来,它里面的哨兵也起不来，等待一段时间再启动哨兵
/usr/local/bin/redis-sentinel /usr/local/etc/redis/sentinel.conf &
tail -f /var/log/redis.log