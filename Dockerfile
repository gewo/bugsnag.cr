FROM crystallang/crystal:0.21.0
MAINTAINER Gebhard Woestemeyer <g@ctr.lc>
COPY . /app
WORKDIR /app
RUN crystal deps
CMD ["/bin/bash"]
