#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2014 pre-commit dev team: Anthony Sottile, Ken Struys
# SPDX-License-Identifier: MIT

# File generated by pre-commit: https://pre-commit.com
# Modified by the Capella Docker images maintainers.

STAGE=$1

# Skip pre-commit when running in the pre-commit cache directory.
# Otherwise, it will lead to a deadlock.
# pre-commit locks the cache directory, then clones the required repositories in the cache directory.
# This triggers the post-checkout hook of the repository, which tries to acquire the pre-commit lock.
[[ $PWD != ${WORKSPACE_DIR}/.pre-commit/* ]] || exit 0

# start templated
INSTALL_PYTHON=/opt/.venv/bin/python
ARGS=(hook-impl --config=.pre-commit-config.yaml --hook-type=$STAGE --skip-on-missing-config)
# end templated

HERE="$(cd "$(dirname "$0")" && pwd)"
ARGS+=(--hook-dir "$HERE" -- "${@:2}")

if [ -x "$INSTALL_PYTHON" ]; then
    exec "$INSTALL_PYTHON" -mpre_commit "${ARGS[@]}"
elif command -v pre-commit > /dev/null; then
    exec pre-commit "${ARGS[@]}"
else
    echo '`pre-commit` not found. Please report this error: https://github.com/DSD-DBS/capella-dockerimages/issues' 1>&2
    exit 1
fi
