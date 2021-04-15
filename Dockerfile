FROM debian:latest

VOLUME /src

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

RUN pip3 install -U \
  # Test requirements
  coverage \
  cython \
  nose \
  nose-pathmunge \
  pipenv \
  pytest-cov \
  pytest \
  # SDK
  opencv-python


ENV DEBUG=1
ENV RUN_PYTHON_TESTS=1
ENV RUN_WEB_TESTS=0

ENV PYTHON_TESTS_DIR=""
ENV PYTHON_TARGET_DIR=""
ENV PYTHON_COVERAGE_DIR=""
ENV WEB_TESTS_DIR=""

WORKDIR /src


# Add piwheels support (pre-compiled binary Python packages for RPi)
COPY files/pip.conf /etc

COPY scripts/entrypoint.sh /entrypoint
COPY scripts/run_python_tests.sh /run_python_tests
COPY scripts/run_web_tests.sh /run_web_tests
ENTRYPOINT ["/entrypoint"]
