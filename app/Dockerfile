# docker build . -t karwank/dfw-app
# docker push karwank/dfw-app
FROM ubuntu:18.04 AS dfw-app

RUN apt-get update && apt-get install -y nano varnish gpg curl patch gawk g++ autoconf automake bison libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool libyaml-dev make patch pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev libssl-dev git sudo wget
# add user to not operate as root
RUN useradd -ms /bin/bash user && echo user:password | chpasswd –crypt-method=SHA512 && adduser user sudo
USER user
WORKDIR /home/user

# create app dir
ENV APP_PATH /home/user/app
RUN mkdir -p /home/user/app

SHELL ["/bin/bash", "-l", "-c"]

# install RVM
RUN mkdir ~/.gnupg
RUN echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf
RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash
RUN echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile && echo "export PATH=\"$PATH:$HOME/.rvm/bin\"" >> .bashrc

# install Ruby
RUN  $HOME/.rvm/bin/rvm install 2.5.5 -C --disable-binary --autolibs=read-only
ENV PATH  = "$HOME/.rvm/bin:$HOME/.rvm/rubies/ruby-2.5.5:${PATH}"
WORKDIR $APP_PATH

COPY Gemfile Gemfile.lock ./
USER root
RUN chown user:user Gemfile*
USER user
RUN rvm use --default 2.5.5 && rvm ruby-2.5.5 do rvm gemset create app && rvm use 2.5.5@app && gem install bundler && bundle install
