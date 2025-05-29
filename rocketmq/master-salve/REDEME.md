###rocketmq多主多从配置说明

rocketmq多主多从集群,必须把每个主从的端口号进行设置不同,获取使用不同的负载均衡设置,否则会出现消费不均衡的问题,这里以两个borker为例,设置

####broker-a的配置文件

```
brokerClusterName=DefaultCluster
brokerName=broker-a
brokerId=0
brokerIP1 =broker-a-link
namesrvAddr=mq-ns.prod-eft-link.svc.cluster.local:9876
brokerEnableProxy=true
brokerWeight=100
defaultTopicQueueNums=4
autoCreateTopicEnable=true
autoCreateSubscriptionGroup=true
waitTimeMillsInSendQueue=5000
registerNameServerPeriod=5000
listenPort=10911
deleteWhen=04
fileReservedTime=120
dynamicTopicEnabled=true
mapedFileSizeCommitLog=1073741824
mapedFileSizeConsumeQueue=300000
destroyMapedFileInterval=120000
redeleteHangedFileInterval=120000
diskMaxUsedSpaceRatio=88
maxMessageSize=4194304
flushCommitLogLeastPages=4
flushConsumeQueueLeastPages=2
flushCommitLogThoroughInterval=10000
flushConsumeQueueThoroughInterval=60000
checkTransactionMessageEnable=false
sendMessageThreadPoolNums=16
pullMessageThreadPoolNums=16
brokerRole=ASYNC_MASTER
flushDiskType=ASYNC_FLUSH
```

#### broker-a-s的配置文件

```
brokerClusterName=DefaultCluster
brokerName=broker-a
brokerId=1
namesrvAddr=mq-ns.prod-eft-link.svc.cluster.local:9876
defaultTopicQueueNums=4
autoCreateTopicEnable=true
autoCreateSubscriptionGroup=true
listenPort=10911
registerNameServerPeriod=5000
deleteWhen=04
fileReservedTime=120
dynamicTopicEnabled=true
mapedFileSizeCommitLog=1073741824
mapedFileSizeConsumeQueue=300000
destroyMapedFileInterval=120000
redeleteHangedFileInterval=120000
diskMaxUsedSpaceRatio=88
maxMessageSize=4194304
flushCommitLogLeastPages=4
flushConsumeQueueLeastPages=2
flushCommitLogThoroughInterval=10000
flushConsumeQueueThoroughInterval=60000
checkTransactionMessageEnable=false
sendMessageThreadPoolNums=16
pullMessageThreadPoolNums=16
brokerRole=SLAVE
flushDiskType=ASYNC_FLUSH
```

#### broker-b的配置文件


```
brokerClusterName=DefaultCluster
brokerName=broker-b
brokerId=0
brokerIP1=broker-b-link
namesrvAddr=mq-ns.prod-eft-link.svc.cluster.local:9876
brokerWeight=100
brokerEnableProxy=true
defaultTopicQueueNums=4
autoCreateTopicEnable=true
autoCreateSubscriptionGroup=true
waitTimeMillsInSendQueue=5000
brokerWeight=100
registerNameServerPeriod=5000
listenPort=10913
deleteWhen=04
fileReservedTime=120
dynamicTopicEnabled=true
mapedFileSizeCommitLog=1073741824
mapedFileSizeConsumeQueue=300000
destroyMapedFileInterval=120000
redeleteHangedFileInterval=120000
diskMaxUsedSpaceRatio=88
maxMessageSize=4194304
flushCommitLogLeastPages=4
flushConsumeQueueLeastPages=2
flushCommitLogThoroughInterval=10000
flushConsumeQueueThoroughInterval=60000
checkTransactionMessageEnable=false
sendMessageThreadPoolNums=16
pullMessageThreadPoolNums=16
brokerRole=ASYNC_MASTER
flushDiskType=ASYNC_FLUSH
```

#### broker-b-s的配置文件

```
brokerClusterName=DefaultCluster
brokerName=broker-b
brokerId=1
compressedRegister=true
brokerEnableProxy=true
namesrvAddr=mq-ns.prod-eft-link.svc.cluster.local:9876
defaultTopicQueueNums=4
autoCreateTopicEnable=true
autoCreateSubscriptionGroup=true
registerNameServerPeriod=5000
listenPort=10913
deleteWhen=04
fileReservedTime=120
dynamicTopicEnabled=true
mapedFileSizeCommitLog=1073741824
mapedFileSizeConsumeQueue=300000
destroyMapedFileInterval=120000
redeleteHangedFileInterval=120000
diskMaxUsedSpaceRatio=88
maxMessageSize=4194304
flushCommitLogLeastPages=4
flushConsumeQueueLeastPages=2
flushCommitLogThoroughInterval=10000
flushConsumeQueueThoroughInterval=60000
checkTransactionMessageEnable=false
sendMessageThreadPoolNums=16
pullMessageThreadPoolNums=16
brokerRole=SLAVE
flushDiskType=ASYNC_FLUSH
```


```
 kubectl get services -n prod-eft-link
NAME                           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                           AGE
broker-a                       ClusterIP   172.16.203.212   <none>        10911/TCP,10909/TCP,10912/TCP                     378d
broker-a-link                  ClusterIP   172.16.254.238   <none>        10911/TCP,10909/TCP,10912/TCP                     191d
broker-a-nodeport              NodePort    172.16.188.118   <none>        10911:32019/TCP,10909:31032/TCP,10912:31454/TCP   378d
broker-a-s                     ClusterIP   172.16.6.115     <none>        10911/TCP,10909/TCP,10912/TCP                     378d
broker-a-s-nodeport            ClusterIP   172.16.241.155   <none>        10911/TCP,10909/TCP,10912/TCP                     378d
broker-b                       ClusterIP   172.16.147.102   <none>        10913/TCP,10909/TCP,10912/TCP                     378d
broker-b-link                  ClusterIP   172.16.28.51     <none>        10913/TCP,10909/TCP,10912/TCP                     191d
broker-b-nodeport              NodePort    172.16.192.60    <none>        10913:32705/TCP,10909:31185/TCP,10912:31695/TCP   378d
broker-b-s                     ClusterIP   172.16.243.133   <none>        10913/TCP,10909/TCP,10912/TCP                     378d
broker-b-s-nodeport            ClusterIP   172.16.52.72     <none>        10913/TCP,10909/TCP,10912/TCP                     378d
mq-ns-nodeport                 NodePort    172.16.54.244    <none>        9876:30897/TCP                                    378d
```



请求的规则:客户---负载均衡----k8s集群


外部请求端口------负载均衡---k8s集群
9876             9876:30897 30897:node节点
10911            10911:32019 32019:node节点
10913            10913:32705 32705:node节点






