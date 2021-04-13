#!/bin/bash
###############################################################
#                Unofficial 'Bash strict mode'                #
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  #
###############################################################
set -euo pipefail
IFS=$'\n\t'
###############################################################

debug_echo() {
  if [[ "${DEBUG}" -eq 1 ]]; then
    echo "$1"
  fi
}

if [[ "${RUN_PYTHON_TESTS}" -eq 1 ]]; then
  debug_echo "[Entrypoint] 'RUN_PYTHON_TESTS' set to 1 - running tests..."
  /run_python_tests
else
  debug_echo "[Entrypoint] 'RUN_PYTHON_TESTS' is not set to 1 - skipping tests..."
fi

# ----

if [[ "${RUN_WEB_TESTS}" -eq 1 ]]; then
  debug_echo "[Entrypoint] 'RUN_WEB_TESTS' set to 1 - running tests..."
  /run_web_tests
else
  debug_echo "[Entrypoint] 'RUN_WEB_TESTS' is not set to 1 - skipping tests..."
fi
