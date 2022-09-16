# Definitions
ARG USER_NAME=vit
ARG USER_ID=1000
ARG GROUP_NAME=vit
ARG GROUP_ID=1000
ARG BASE_DIR=/opt/${USER_NAME}

FROM amd64/ubuntu:xenial AS downloader

ARG USER_NAME
ARG USER_ID
ARG GROUP_NAME
ARG GROUP_ID
ARG BASE_DIR

# Tag specific vars
ARG KS_PLATFORM=ubuntu-16.04
ARG KS_ARCH=x64

# Versions of tools 
ARG CMAKE_VERSION=3.12.4
ARG GRADLE_VERSION=6.4.1
ARG JDK_VERSION=11.0.7_10

# Expected vars
ARG KS_REPO_URL_REL=https://artifactory.kaisquare.com/artifactory/libs-release
ARG KS_REPO_USER=<user>
ARG KS_REPO_PASSWORD=<password>

RUN echo "cmake-${CMAKE_VERSION}, gradle-${GRADLE_VERSION}, jdk-${JDK_VERSION} building.."

# Update & install tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unzip \
        wget 

# Change workdir
WORKDIR ${BASE_DIR}

RUN mkdir -p tools

# Download and build cmake
#RUN wget --no-check-certificate -nv --user ${KS_REPO_USER} --password ${KS_REPO_PASSWORD} ${KS_REPO_URL_REL}/com/ncs/vit/vms/tools/cmake-${KS_PLATFORM}-${KS_ARCH}/${CMAKE_VERSION}/cmake-${KS_PLATFORM}-${KS_ARCH}-${CMAKE_VERSION}.zip \
#        && unzip cmake-${KS_PLATFORM}-${KS_ARCH}-${CMAKE_VERSION}.zip \
#        && rm cmake-* \
#        && tar -zxf $(find tools -name 'cmake-*')\
#        && mv cmake* cmake
# VA needs newer cmake which is not available in our repo
RUN wget --no-check-certificate -nv https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2-linux-x86_64.tar.gz -O tools/cmake-3.20.2-linux-x86_64.tar.gz && \
    tar -zxf $(find tools -name 'cmake-*') && \
    mv cmake* cmake

# Download and build gradle
RUN wget --no-check-certificate -nv --user ${KS_REPO_USER} --password ${KS_REPO_PASSWORD} ${KS_REPO_URL_REL}/com/ncs/vit/vms/tools/gradle-${KS_PLATFORM}-${KS_ARCH}/${GRADLE_VERSION}/gradle-${KS_PLATFORM}-${KS_ARCH}-${GRADLE_VERSION}.zip && \
    unzip gradle-${KS_PLATFORM}-${KS_ARCH}-${GRADLE_VERSION}.zip && \
    rm gradle-* && \
    unzip $(find tools -name 'gradle-*') && \
    mv gradle* gradle

# Download and build jdk
RUN wget --no-check-certificate -nv --user ${KS_REPO_USER} --password ${KS_REPO_PASSWORD} ${KS_REPO_URL_REL}/com/ncs/vit/vms/tools/jdk-${KS_PLATFORM}-${KS_ARCH}/${JDK_VERSION}/jdk-${KS_PLATFORM}-${KS_ARCH}-${JDK_VERSION}.zip --progress=dot:giga && \
    unzip jdk-${KS_PLATFORM}-${KS_ARCH}-${JDK_VERSION}.zip && \
    rm jdk-* && \
    mkdir jdk && \
    tar -zxf $(find tools -name '*jdk*') \
        --directory jdk \
        --strip-components 1

# Download and install python
RUN wget --no-check-certificate -nv https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh -O miniconda-installer.sh && \
    chmod +x miniconda-installer.sh && \
    bash ./miniconda-installer.sh -b -p tools/miniconda -f && \
    ./tools/miniconda/bin/conda create -p python2 -y python=2.7 && \
    ./tools/miniconda/bin/conda create -p python -y python=3.6

# Remove temp files
RUN rm -rf tools


# Target image
FROM amd64/ubuntu:xenial

ARG USER_NAME
ARG USER_ID
ARG GROUP_NAME
ARG GROUP_ID
ARG BASE_DIR
ARG TOOLS_DIR=${BASE_DIR}/tools

RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        gdb \
        libx11-dev libgtk2.0-dev libpython-dev \
        ssh \
        rsync \
        sudo && \
    apt-get clean

RUN mkdir -p ${BASE_DIR}/ssh && \
    mkdir -p ${BASE_DIR}/.ssh && \
    ( \
        echo 'LogLevel DEBUG2'; \
        echo 'PasswordAuthentication yes'; \
        echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
    ) > ${BASE_DIR}/ssh/sshd_config_test_clion && \
    mkdir /run/sshd && \
    mkdir -p ${TOOLS_DIR}

COPY --from=downloader ["${BASE_DIR}", "${TOOLS_DIR}"]
COPY entrypoint.sh ${TOOLS_DIR}/entrypoint.sh

RUN addgroup --gid ${GROUP_ID} ${GROUP_NAME} && \
    adduser --uid ${USER_ID} --gid ${GROUP_ID} --home ${BASE_DIR} --disabled-password ${USER_NAME} --no-create-home -gecos '' && \
    mkdir -p /etc/sudoers.d && \
    echo "${USER_NAME} ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER_NAME} && \
    chmod 0440 /etc/sudoers.d/${USER_NAME} && \
    ( \
        echo JAVA_HOME="${TOOLS_DIR}/jdk"; \
        echo GRADLE_HOME="${TOOLS_DIR}/gradle"; \
        echo PATH="${TOOLS_DIR}/cmake/bin:${TOOLS_DIR}/jdk/bin:${TOOLS_DIR}/gradle/bin:${TOOLS_DIR}/python/bin:$PATH"; \
    ) > ${BASE_DIR}/.profile && \
    chown -R ${USER_NAME}:${GROUP_NAME} ${BASE_DIR} && \
    chmod 0700 ${TOOLS_DIR}/entrypoint.sh

# Go to work directory
WORKDIR ${BASE_DIR}
ENV HOME=${BASE_DIR} \
    JAVA_HOME="${TOOLS_DIR}/jdk" \
    GRADLE_HOME="${TOOLS_DIR}/gradle" \
    PATH="${TOOLS_DIR}/cmake/bin:${TOOLS_DIR}/jdk/bin:${TOOLS_DIR}/gradle/bin:${TOOLS_DIR}/python/bin:$PATH"
USER ${USER_NAME}

ENTRYPOINT ["/bin/bash", "-c", "$HOME/tools/entrypoint.sh"]

