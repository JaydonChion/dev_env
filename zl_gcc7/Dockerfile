FROM ubuntu:bionic
RUN sed -i 's/archive.ubuntu.com/ap-southeast-1.ec2.archive.ubuntu.com/g' /etc/apt/sources.list 
RUN sed -i 's/security.ubuntu.com/ap-southeast-1.ec2.archive.ubuntu.com/g' /etc/apt/sources.list 
RUN apt update
RUN apt install ca-certificates gcc -y
RUN apt install gcc -y
WORKDIR /root
CMD ["bash"]
