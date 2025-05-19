###ingress部署说明

ingress作为集群入口,这里使用了两个版本分别是1.8和1.12,两个版本的使用方式是一样的,只是在集群使用中,1.8版本中的v1和v2是配置ingressclass的nginx-v1和nginx-v2对应,这个主要是分离流量使用的,两个ingress对应不同的外网,通过ingreeclass做分离



