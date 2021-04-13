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
  libv4l-dev \
  yarnpkg

RUN pip3 install \
  coverage \
  cython \
  nose \
  nose-pathmunge \
  pipenv \
  pytest-cov \
  pytest \
  # Additional deps for SDK
  # (ideally this would be done with apt to track package version in pi-topOS)
  cv2 \
  imutils \
  numpy \
  gpiozero \
  pitopcommon


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
