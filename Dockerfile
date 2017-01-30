FROM crystallang/crystal:0.20.1
MAINTAINER Gebhard Woestemeyer <g@ctr.lc>

RUN sed -i.orig -e 's/httpredir/ftp.de/g' /etc/apt/sources.list
RUN apt-get update \
&& apt-get install -y apt-transport-https curl build-essential pkg-config \
   libssl-dev llvm libedit-dev libgmp-dev libxml2-dev libyaml-dev \
   libreadline-dev git-core mysql-client netcat-openbsd redis-tools

CMD ["/bin/bash"]
