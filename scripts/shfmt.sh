#!/usr/bin/env bash
set -eu

################################################################################
# Ensure shell scripts conform to style guide.
################################################################################

readonly DEBUG=${DEBUG:-unset}
if [ "${DEBUG}" != unset ]; then
	set -x
fi

if ! command -v shfmt >/dev/null 2>&1; then
	echo 'This check needs shfmt from https://github.com/mvdan/sh/releases'
	exit 1
fi

version="$(shfmt -version 2>&1)"
if [[ "${version}" =~ v2 ]]; then
	echo 'This check needs shfmt v3 or higher from https://github.com/mvdan/sh/releases'
	exit 1
fi

readonly cmd="shfmt -l -kp -w -ci $*"
echo "[RUN] ${cmd}"
${cmd}
