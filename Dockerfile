FROM ruby:2.1.2

# Stop getting errors from things that expect a TTY by default
ENV DEBIAN_FRONTEND=noninteractive

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
COPY ./wraith-*.gem ./
RUN gem install wraith

RUN apt-get update
RUN echo "export phantomjs=/usr/bin/phantomjs" > .bashrc
RUN apt-get install -y libfreetype6 libfontconfig1 nodejs npm libnss3-dev libgconf-2-4
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install npm
RUN npm install -g phantomjs@2.1.7 casperjs@1.1.1

# Install Chrome direct from Google
RUN curl -sSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee  /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable

# Make sure decent fonts are installed. Thanks to http://www.dailylinuxnews.com/blog/2014/09/things-to-do-after-installing-debian-jessie/
RUN echo "deb http://ftp.us.debian.org/debian jessie main contrib non-free" | tee -a /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ jessie/updates contrib non-free" | tee -a /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y ttf-freefont ttf-mscorefonts-installer ttf-bitstream-vera ttf-dejavu ttf-liberation

# Make sure a recent (>6.7.7-10) version of ImageMagick is installed.
RUN apt-get install -y imagemagick

# Clean up to save space
RUN apt-get clean

ENTRYPOINT [ "wraith" ]
