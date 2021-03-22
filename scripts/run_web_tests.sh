#!/bin/bash
###############################################################
#                Unofficial 'Bash strict mode'                #
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  #
###############################################################
set -euo pipefail
IFS=$'\n\t'
###############################################################

testsDirectory="${WEB_TESTS_DIR:-.}"
cd "${testsDirectory}"
yarnpkg install
yarnpkg test:coverage
