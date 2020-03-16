FROM python:3.6.10

RUN set -ex && \
    apt-get update && \
    apt-get install -y \
    git \
    wget \
    curl \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -U pip
RUN pip install Cython

# apply patch
RUN cd /tmp \
  && git clone https://github.com/hottolink/pydams.git \
  && wget http://newspat.csis.u-tokyo.ac.jp/download/dams-4.3.4.tgz \
  && tar -xzvf dams-4.3.4.tgz \
  && patch -d ./dams-4.3.4 -p1 < ./pydams/patch/dams-4.3.4.diff

# install dams
RUN cd /tmp/dams-4.3.4 \
  && ./configure \
  && make \
  && make install \
  && ldconfig \
  && ldconfig -v | grep dams \
  && make dic \
  && make install-dic

# install pydams
RUN cd /tmp/pydams \
  && make all

# remove working directories
RUN rm -rf /tmp/dams /tmp/pydams

# see if pydams package works
# RUN python -c 'from pydams import DAMS;from pydams.helpers import pretty_print; DAMS.init_dams(); pretty_print(DAMS.geocode("東京都千代田区千代田1-1"))'