FROM debian:latest

VOLUME /src

# Add piwheels support (pre-compiled binary Python packages for RPi)
COPY files/pip.conf /etc

ENV DEBUG=1
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

RUN apt-get install -y \
  git \
  libsystemd-dev \
  pkg-config \
  python3-pip \
  python3.7

# External dependencies
RUN apt-get install -y \
  # Web UIs
  yarnpkg \
  # SDK
  libv4l-dev

# Update pip to latest (required to get pre-compiled OpenCV binaries)
RUN python3 -m pip install -U pip

# Test requirements
RUN pip3 install -U \
  coverage \
  cython \
  nose \
  nose-pathmunge \
  pipenv \
  pytest-cov \
  pytest

# SDK
RUN pip3 install -U \
  opencv-python
