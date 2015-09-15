# Inspired by Deepak's setup here - https://gist.github.com/deepak/5925003

FROM ubuntu:14.04

RUN apt-get update -qq && apt-get install -y build-essential nodejs npm git curl mysql-client libmysqlclient-dev libxml2-dev libxslt-dev libreadline-dev
RUN mkdir -p /il_dashboard

# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN echo '# rbenv setup' > /etc/profile.d/rbenv.sh
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN chmod +x /etc/profile.d/rbenv.sh

# install ruby-build
RUN mkdir /usr/local/rbenv/plugins
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build

ENV RBENV_ROOT /usr/local/rbenv
ENV PATH $RBENV_ROOT/bin:$RBENV_ROOT/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN rbenv install  1.9.3-p448
#RUN rbenv install  2.0.0-p598
RUN bash -l -c 'rbenv global 1.9.3-p448; gem install bundler; rbenv rehash'

WORKDIR /il_dashboard

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN ruby -v
RUN bundle install

ADD . /il_dashboard

CMD bundle exec thin start
