FROM ruby:2.1-alpine

MAINTAINER Vijaya Chandran Mani <http://www.vijaycs85.com>

RUN mkdir /usr/app
WORKDIR /usr/app

COPY . /usr/app/

# ENV HTTP_PROXY http://[ip address]:[port]
# ENV HTTPS_PROXY http://[ip address]:[port]
# ENV http_proxy http://[ip address]:[port]
# ENV https_proxy http://[ip address]:[port]

RUN apk --update add \
                git \
                build-base \
                nodejs

# RUN git config --global http.proxy [ip address]:[port]
RUN git config http.sslVerify false

RUN bundle install

EXPOSE 3030

CMD ["dashing", "start"]
