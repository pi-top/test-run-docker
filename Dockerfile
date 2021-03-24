FROM debian:latest

# Add a user with userid 1000 and name nonroot
RUN useradd --create-home -u 1000 nonroot
RUN mkdir /src  && chown nonroot /src
VOLUME /src

# Configure sudo for nonroot
COPY  sudoers.txt /etc/sudoers
RUN chmod 440 /etc/sudoers

# Copy scripts
COPY scripts/entrypoint.sh /entrypoint
COPY scripts/run_python_tests.sh /run_python_tests
COPY scripts/run_web_tests.sh /run_web_tests
ENTRYPOINT ["/entrypoint"]

WORKDIR /src

# Debian
ENV DEBIAN_FRONTEND=noninteractive

# Install packages to run tests
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
  pytest

# Environment variables used by scripts
ENV DEBUG=1
ENV RUN_PYTHON_TESTS=1
ENV RUN_WEB_TESTS=0
ENV PYTHON_TESTS_DIR=""
ENV PYTHON_TARGET_DIR=""
ENV PYTHON_COVERAGE_DIR=""
ENV WEB_TESTS_DIR=""

# Run container as nonroot
USER nonroot
