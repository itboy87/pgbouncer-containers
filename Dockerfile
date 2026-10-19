# PgBouncer release source is verified against the official GitHub asset digest.
# Preserve the CloudNativePG operand ABI: non-root pgbouncer, UID 998/GID 996,
# /usr/bin/pgbouncer and writable /etc, /var/run and /var/log/pgbouncer directories.
ARG BASE=debian:trixie-slim
FROM ${BASE} AS build
ARG PGBOUNCER_VERSION
ARG PGBOUNCER_SHA256
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    build-essential pkg-config libevent-dev libssl-dev libc-ares-dev libpq-dev \
    ca-certificates curl python3 python3-pytest python3-pytest-asyncio \
    python3-pytest-timeout python3-pytest-xdist python3-psycopg python3-filelock \
    postgresql postgresql-client openssl && rm -rf /var/lib/apt/lists/*
WORKDIR /src
RUN test -n "$PGBOUNCER_VERSION" && test -n "$PGBOUNCER_SHA256" && \
    curl --fail --location --retry 3 --output source.tar.gz \
      "https://github.com/pgbouncer/pgbouncer/releases/download/pgbouncer_$(echo "$PGBOUNCER_VERSION" | tr . _)/pgbouncer-${PGBOUNCER_VERSION}.tar.gz" && \
    echo "$PGBOUNCER_SHA256  source.tar.gz" | sha256sum -c - && \
    tar -xzf source.tar.gz --strip-components=1 && rm source.tar.gz && \
    ./configure --prefix=/usr --with-openssl --with-cares --without-systemd && \
    make -j2 && make -C test check && make install DESTDIR=/out && \
    install -m 0644 COPYRIGHT /out/usr/share/doc/pgbouncer/COPYRIGHT && \
    useradd --create-home --uid 10001 buildtest && chown -R buildtest:buildtest /src
# Regression tests exercise the source-built executable against disposable local
# PostgreSQL, without root privileges or any production credentials/data.
USER buildtest
RUN python3 -m pytest -q test/test_misc.py \
    -k 'second_startup_message_rejected or options_startup_param or ignore_tracked_startup_parameter'

FROM ${BASE}
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    ca-certificates libevent-2.1-7t64 libssl3t64 libc-ares2 postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/* /var/log/* /tmp/* && \
    groupadd -r --gid 996 pgbouncer && useradd -r --uid 998 --gid 996 pgbouncer && \
    mkdir -p /var/run/pgbouncer /var/log/pgbouncer /etc/pgbouncer && \
    chown -R pgbouncer:pgbouncer /var/run/pgbouncer /var/log/pgbouncer /etc/pgbouncer
COPY --from=build /out/usr/ /usr/
EXPOSE 6432
USER pgbouncer
ENTRYPOINT ["/usr/bin/pgbouncer"]
CMD ["/etc/pgbouncer/pgbouncer.ini"]
