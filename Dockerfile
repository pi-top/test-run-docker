FROM debian:latest

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

# Test suite build dependencies
RUN apt-get install --no-install-recommends -y \
  build-essential \
  cmake \
  pkg-config \
  python3-dev \
  yarnpkg

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
  python3.7 \
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
