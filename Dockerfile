FROM ubuntu:18.04

# Following TAOBench instructions
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt install -y build-essential cmake g++-11

# Including SuperiorMySqlpp
WORKDIR /usr/local/include

RUN apt install unzip

COPY ./include .
RUN unzip ./superior_mysqlpp.zip

# Copying repository
WORKDIR /taobench
COPY . .

# Downgrading libmysqlclient
# SuperiorMySqlpp currently doesn't support MySQL library version 8 and newer
# This order must be followed, libmysqlclient-dev depends on libmysqlclient20 which depends on mysql-common
RUN dpkg -i ./libmysqlclient/mysql-common_5.7.38-1ubuntu18.04_amd64.deb
RUN dpkg -i ./libmysqlclient/libmysqlclient20_5.7.38-1ubuntu18.04_amd64.deb
RUN dpkg -i ./libmysqlclient/libmysqlclient-dev_5.7.38-1ubuntu18.04_amd64.deb

# Building executable
RUN cmake . -DWITH_MYSQL=ON
RUN make

ENTRYPOINT echo "Ready to start";sleep 1d
