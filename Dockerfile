FROM google/golang
MAINTAINER Date-Fitness develope group "zhengyuangrant@126.com"

# Build app
WORKDIR /gopath/app
ENV GOPATH /gopath/app/Date-Fitness/backend
ADD . /gopath/app/

RUN git clone https://github.com/Date-Fitness/Date-Fitness.git

ENTRYPOINT ["/bin/bash","/gopath/app/Date-Fitness/backend/build_docker.sh"]

EXPOSE 80
