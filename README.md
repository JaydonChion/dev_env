# dev_env
Different Dockerfile for different purposes

Example:
To create a Ubuntu18 environment
1. run ./build.sh ubuntu18_base
2. then rename the docker created by : docker tag ori_name new_name
3. remove old tag by: docker rmi ori_name

untested:
the docker will start port 2218, can ssh using port 2218 using visual studio and work on it
