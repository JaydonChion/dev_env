FROM ubuntu:16.04
ARG UID=1000
ARG UNAME=zawlin
ARG PASS=zawlin
ARG GID=1000
ENV USER=$UNAME
RUN sed -i 's/archive.ubuntu.com/ap-southeast-1.ec2.archive.ubuntu.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/ap-southeast-1.ec2.archive.ubuntu.com/g' /etc/apt/sources.list && \
    apt update && \
    apt install ca-certificates apt-transport-https gcc g++ gcc-5 g++-5 wget git software-properties-common gdb rsync zip ssh vim-gtk python python-dev x11-apps sudo -y


# install cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" && \
    apt update && \
    apt install cmake -y

# install java 
RUN cd /tmp && wget https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz --progress=dot:giga && \
    tar xvf OpenJDK11U-jdk_x64_linux_hotspot_11.0.12_7.tar.gz && \
    rm *.tar.gz && \
    mv jdk-11.0.12+7 /opt/ && \
    ln -rs /opt/jdk-11.0.12+7/bin/java* /usr/bin/


RUN adduser $UNAME && adduser $UNAME sudo && echo "$UNAME:$PASS"|chpasswd
RUN sed -i "s/Port 22/Port 2222/g" /etc/ssh/sshd_config
RUN usermod -u $UID $UNAME && groupmod -g $GID $UNAME
WORKDIR /home/$UNAME
ENTRYPOINT service ssh restart && su $USER && bash

