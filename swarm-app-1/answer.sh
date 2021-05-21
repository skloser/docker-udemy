1. Make swarm
    - Go to one of the virtual machines - "docker swarm init --advertise-addr {IP}"
    - Go to other nodes and join them "docker swarm join --token SWMTKN-1-2396r4sgza2cbzalbgoj54zaiu0xliuf9sh8eou6x8qcypi7x6-07swf8nxv0ssxorn3fz791mh0 {IP}"
2. Make networks
    - docker network create -d overlay frontend
    - docker network create -d overlay backend
3. Create volume
    - docker volume create db-data
4. Create vote frontend service
    - docker service create --name vote --replicas 2 --network frontend -p 80:80 bretfisher/examplevotingapp_vote
5. Create redis key/value store
    - docker service create --name redis --replicas 1 --network frontend redis:3.2
6. Create worker backend processor of redis and storing results in postgres
    - docker service create --name worker --network frontend --network backend --replicas 1 bretfisher/examplevotingapp_worker:java
7. Create postgres db
    - docker service create --name db --network backend --replicas 1 -e POSTGRES_HOST_AUTH_METHOD=trust --mount type=volume,source=db-data,target=/var/lib/postgresql/data postgres:9.4
8. Create result web app that shows results
    - docker service create --name result --replicas 1 --network backend -p 5001:80 bretfisher/examplevotingapp_result