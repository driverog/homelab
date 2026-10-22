#!/usr/bin/env bash
# Registers the runner the first time it starts, then runs it.
#
# /home/runner is a volume, so it keeps the runner the way an ordinary machine
# would: the install, the registration config.sh writes beside it, and
# everything the runner rewrites later on its own — it refreshes its config
# files (deleting and recreating them) and updates its own binaries. A
# recreated container picks all of that up without this script having to know
# which files they are.
#
# RUNNER_TOKEN is read only while the volume holds no registration. GitHub
# expires it an hour after issuing it and config.sh spends it either way, so
# it can be deleted from .env once the runner shows up as Idle.
set -euo pipefail
cd /home/runner

# The work volume is mounted inside this one and comes up root-owned.
sudo chown runner:runner _work

if [[ ! -f .runner && ! -f .runner_migrated ]]; then
  : "${RUNNER_REPO_URL:?is empty: set it in .env to the repo this runner takes jobs from}"
  : "${RUNNER_TOKEN:?is empty and runner-home holds no registration: put a fresh registration token in .env}"
  ./config.sh --unattended --replace \
    --url "$RUNNER_REPO_URL" --token "$RUNNER_TOKEN" \
    --name "$RUNNER_NAME" --labels "$RUNNER_LABELS" --work _work
fi

exec ./run.sh
