#!/bin/bash


# Create 10 containers
for i in {1..10}
do
    (docker stop container$i; docker rm container$i) 

done

# Create 10 containers
for i in {1..10}
do
    docker run -d --name=container$i ubuntu sleep infinity
done

# Create 10 bridges
for i in {1..10}
do
    brctl addbr br$i
done

# Create 10 veth pairs
for i in {1..10}
do
    ip link add veth$i type veth peer name veth$i-br
done

# Add veth pairs to bridges
for i in {1..10}
do
    brctl addif br$i veth$i-br
done

# Add veth pairs to containers
for i in {1..10}
do
    ./pipework br$i container$i veth$i
done

# Start bridges
for i in {1..10}
do
    ifconfig br$i up
done

# Start veth pairs
for i in {1..10}
do
    ifconfig veth$i up
done

# Start containers
for i in {1..10}
do
    docker start container$i
done
