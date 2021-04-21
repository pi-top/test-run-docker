#!/bin/bash
###############################################################
#                Unofficial 'Bash strict mode'                #
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  #
###############################################################
set -euo pipefail
IFS=$'\n\t'
###############################################################

VERBOSE=""
if [[ "${DEBUG}" -eq 1 ]]; then
  VERBOSE="--verbose"
fi

workingDirectory=$(pwd)
testsDirectory="${PYTHON_TESTS_DIR:-.}"
targetDirectory="$PYTHON_TARGET_DIR"
coverageDirectory="${PYTHON_COVERAGE_DIR:-$targetDirectory}"
echo "Running tests from ${testsDirectory}"
echo "Target directory is ${targetDirectory}"
echo "Coverage directory is ${coverageDirectory}"

if [[ -f "${testsDirectory}/requirements.txt" ]]; then
  echo "Tests dependencies found, installing..."
  python3 -m pip install "${VERBOSE}" --upgrade -r "${testsDirectory}/requirements.txt"
fi

if [[ -f "${targetDirectory}/Pipfile" ]]; then
  echo "Pipfile found, installing..."
  cd "${targetDirectory}"
  if [[ ! -f "Pipfile.lock" ]]; then
    pipenv install "${VERBOSE}"
  fi
  pipenv sync --dev $VERBOSE
  cd "$workingDirectory"
fi

if grep -q -R pytest --include '*.py' "${targetDirectory}"; then
  echo "Running tests using pytest..."
  cd "${targetDirectory}"
  PYTHONPATH="${coverageDirectory}" pipenv run pytest \
    "${VERBOSE}" \
    --cov-report term-missing \
    --cov="${coverageDirectory}" \
    --junitxml=tests.xml
  pipenv run coverage xml
  cd "$workingDirectory"
else
  echo "Running tests using nosetests..."
  nosetests --verbose \
    --with-xunit \
    --xunit-file=tests.xml \
    --with-path="${targetDirectory}" \
    --with-coverage \
    --cover-erase \
    --cover-xml \
    --cover-package="${coverageDirectory}" \
    "${testsDirectory}"
fi

echo "Cleaning up..."
find . | grep -E '(__pycache__|\\.pyc|\\.pyo\$)' | xargs rm -rf || true
find . | grep '.coverage$' | xargs rm -rf || true
find . | grep '.pytest_cache' | xargs rm -rf || true
