FROM crystallang/crystal:0.21.1
MAINTAINER Gebhard Woestemeyer <g@ctr.lc>
COPY . /app
WORKDIR /app
RUN shards update
CMD ["/bin/bash"]
