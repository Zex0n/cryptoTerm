FROM ruby:2.4.0

# Most of these deps are for running JS tests. You can add whatever extra deps your project has (ffmpeg, imagemagick, etc)
RUN apt-get update
RUN apt-get install -y build-essential nodejs qt5-default libqt5webkit5-dev xvfb postgresql postgresql-contrib

# Point Bundler at /gems. This will cause Bundler to re-use gems that have already been installed on the gems volume
ENV BUNDLE_PATH /gems
ENV BUNDLE_HOME /gems

# Increase how many threads Bundler uses when installing. Optional!
ENV BUNDLE_JOBS 4

# How many times Bundler will retry a gem download. Optional!
ENV BUNDLE_RETRY 3

# Where Rubygems will look for gems, similar to BUNDLE_ equivalents.
ENV GEM_HOME /gems
ENV GEM_PATH /gems

# You'll need something here. For development, you don't need anything super secret.
ENV SECRET_KEY_BASE development123

# Add /gems/bin to the path so any installed gem binaries are runnable from bash.
ENV PATH /gems/bin:$PATH

RUN gem install bundler

# Allow SSH keys to be mounted (optional, but nice if you use SSH authentication for git)
VOLUME /root/.ssh

# Setup the directory where we will mount the codebase from the host
VOLUME /app
WORKDIR /app

CMD /bin/bash