FROM debian:buster

VOLUME /src

# Add piwheels support (pre-compiled binary Python packages for RPi)
COPY files/pip.conf /etc

ENV DEBUG=0
ENV RUN_PYTHON_TESTS=1
ENV RUN_WEB_TESTS=0

ENV PYTHON_TESTS_DIR=""
ENV PYTHON_TARGET_DIR=""
ENV PYTHON_COVERAGE_DIR=""
ENV WEB_TESTS_DIR=""

WORKDIR /src


COPY scripts/entrypoint.sh /entrypoint
COPY scripts/run_python_tests.sh /run_python_tests
COPY scripts/run_web_tests.sh /run_web_tests
ENTRYPOINT ["/entrypoint"]

RUN apt-get update

# Initialise Node.js v12 repository
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Test suite build dependencies
RUN apt-get install --no-install-recommends -y \
  build-essential \
  cmake \
  pkg-config \
  python3-dev \
  yarnpkg \
  nodejs

# pyenv dependencies
RUN apt-get update && apt install -y \
    make \
    git \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev

# Install pyenv
RUN curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

# Initialise pyenv
RUN echo -e 'export PYENV_ROOT="$HOME/.pyenv"\nexport PATH="$PYENV_ROOT/bin:$PATH"\neval "$(pyenv init --path)"' >> ~/.profile

# Additional library dependencies to run specific tests across pi-top codebase
RUN apt-get install --no-install-recommends -y \
  # SDK - camera
  libv4l-dev \
  # SDK - additional OpenCV dependencies
  libatlas-base-dev \
  liblapack-dev \
  libopenblas-dev \
  libsm6 \
  libxext6 \
  libfontconfig1 \
  libxrender1 \
  libgl1-mesa-glx

# Python bootstrap for 'pip'
RUN apt-get install --no-install-recommends -y \
  python3 \
  python3-pip \
  python3-setuptools \
  python3-wheel

# Update pip to latest (required to get pre-compiled OpenCV binaries)
RUN python3 -m pip install --upgrade pip

# Test requirements
RUN python3 -m pip install --upgrade \
  coverage \
  cython \
  nose \
  nose-pathmunge \
  pipenv \
  pytest-cov \
  pytest \
  setuptools

# dlib is only available from source (no wheels), so we include it here to save build time
# https://pypi.org/project/dlib/#files
RUN python3 -m pip install --upgrade -vvv \
  dlib
