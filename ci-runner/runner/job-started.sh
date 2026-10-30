#!/usr/bin/env bash
# Runs before every job (ACTIONS_RUNNER_HOOK_JOB_STARTED).
#
# One long-lived runner means one job's leftovers are the next job's starting
# state. This clears dind before each job rather than after, so it also covers
# a job that was killed halfway: every job starts with no containers, volumes,
# networks or images. Only the build cache survives, because it is what makes
# the second build fast — capped, since nothing else would ever delete it.
#
# Assumes this is the only runner on this daemon: it removes every container.
# Never fails the job. A cleanup that didn't finish is a reason to look, not a
# reason to turn a good build red.
docker ps -aq | xargs -r docker rm -f
docker volume prune -af
docker network prune -f
docker image prune -af
docker builder prune -f --max-used-space 10GB
exit 0
