FROM debian:latest

VOLUME /src

RUN apt-get update

RUN apt-get install -y git \
	libsystemd-dev \
	pkg-config \
	python3.7 \
	python3-pip \
	python-pytest \
	libv4l-dev

RUN pip3 install pytest \
	pytest-cov \
	pipenv \
	nose \
	coverage \
	nose-pathmunge \
	cython

ENV TESTS_DIR=""
ENV TARGET_DIR=""
ENV COVERAGE_DIR=""

WORKDIR /src

COPY scripts/run_tests.sh /run_tests
ENTRYPOINT ["/run_tests"]
