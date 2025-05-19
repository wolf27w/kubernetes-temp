###redis哨兵模式集群

首先需要把Dockerfile  redis.conf  run.sh  sentinel.conf四个文件放到同一个目录做集群镜像，然后把构建的镜像redis-sentinel:7.0上传到私有仓库。


```
# docker build -t swr.cn-beijing-1.mhyun.com/ops/redis-sentinel:7.0
# docker push swr.cn-beijing-1.mhyun.com/ops/redis-sentinel:7.0

```

然后创建集群

```
# kubectl apply -f redis.yaml -n demo
# kubectl get pod -n demo | grep redis-sen
redis-sentinel-0                                       1/1     Running   0          7m53s
redis-sentinel-1                                       1/1     Running   0          7m35s
redis-sentinel-2   
```

所有容器启动成功，说明集群已经部署成功，下面检验一下集群的状态。

```
# kubectl exec -it -n afsp redis-sentinel-0 /bin/bash
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
root@redis-sentinel-0:/data# redis-cli -h redis-sentinel-0.redis-sentinel
redis-sentinel-0.redis-sentinel:6379> auth RedisDBforeFt20200911
OK
redis-sentinel-0.redis-sentinel:6379> info Replication
# Replication
role:master
connected_slaves:2
slave0:ip=10.16.1.146,port=6379,state=online,offset=1232,lag=0
slave1:ip=10.16.1.49,port=6379,state=online,offset=1232,lag=0
master_failover_state:no-failover
master_replid:81df53a168dc0d19a361e1e4b656ae3b3963b89f
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:1232
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:1232
redis-sentinel-0.redis-sentinel:6379>

```


redis集群哨兵模式创建成功，检查一下集群的master节点是否可以自动切换，现在master节点上kill掉redis服务，然后在启动服务，如果master节点在sentine没有选举成功之前启动，旧master有优先级，这里就不做多测试

如果出现旧主节点没有启动成功之前在redis-sentinel-1和redis-sentinel-2之间选举出主节点，会出现redis-sentinel-0也会时master节点，解决方法就是把redis-sentinel-1和redis-sentinel-2之间的主节点删除然后在删除redis-sentinel-1和redis-sentinel-2之间的从节点即可，也可以直接升级会重新选举。
