# GitHub's own runner image, plus the one thing it lacks that jobs here use:
# the Compose plugin. Its Docker CLI and buildx are already in the base.
FROM ghcr.io/actions/actions-runner:2.338.1

COPY --from=docker/compose-bin:v5.6.1 /docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

# Outside /home/runner, which is a volume: an edit here reaches the container
# on the next build instead of being shadowed by the volume's first copy.
COPY --chmod=755 entrypoint.sh job-started.sh /usr/local/lib/ci-runner/

ENTRYPOINT ["/usr/local/lib/ci-runner/entrypoint.sh"]
