#!/bin/bash -ex

testsDirectory="${TESTS_DIR:-.}"
targetDirectory="$TARGET_DIR"
coverageDirectory="${COVERAGE_DIR:-$targetDirectory}"
echo "Running tests from ${testsDirectory}"
echo "Target directory is ${targetDirectory}"
echo "Coverage directory is ${coverageDirectory}"

if [[ -f "${testsDirectory}/requirements.txt" ]]; then
	echo "Tests dependencies found, installing..."
	pip3 install --upgrade -r "${testsDirectory}/requirements.txt"
fi

if [[ -f "${targetDirectory}/Pipfile" ]]; then
	echo "Pipfile found, installing..."
	cd "${targetDirectory}"
	if [[ ! -f "Pipfile.lock" ]]; then
		pipenv install
	fi
	pipenv sync
	pipenv sync --dev
	cd -
fi

if grep -q -R pytest --include *.py "${targetDirectory}"; then
	echo "Running tests using pytest..."
	cd "${targetDirectory}"
	PYTHONPATH="${coverageDirectory}" pipenv run pytest \
		-v \
		--cov-report term-missing \
		--cov="${coverageDirectory}" \
		--junitxml=tests.xml
	pipenv run coverage xml
	cd -
else
	echo "Running tests using nosetests..."
	nosetests -v \
		--with-xunit \
		--xunit-file=tests.xml \
		--with-path="${targetDirectory}" \
		--with-coverage \
		--cover-erase \
		--cover-xml \
		--cover-package="${coverageDirectory}" \
		"${testsDirectory}"
fi
