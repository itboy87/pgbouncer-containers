# itboy87 PgBouncer images for CloudNativePG

This public fork of `cloudnative-pg/pgbouncer-containers` builds **PgBouncer 1.26.1**
from its official release source. It is independently built and maintained by
`itboy87`; it is not an official CloudNativePG-published image.

- Image: `ghcr.io/itboy87/pgbouncer:1.26.1` (linux/amd64 and linux/arm64).
- Source SHA-256: `00886a2994b4844cd37110970df777772cfc42a74c400522c82fba509a3f42d9`.
- Debian Trixie base is pinned by digest in `docker-bake.hcl`.
- The build runs the upstream C HBA tests and the targeted second-startup,
  startup-options and ignored-tracked-parameter regression tests as non-root.
- Non-root CNPG layout, UID 998, GID 996, and `/usr/bin/pgbouncer` are preserved.
- GitHub Actions publishes only when manually dispatched, emits SBOM/provenance,
  verifies both architecture binaries, and signs the immutable index with Sigstore.
- Prefer the verified immutable digest for deployment, rather than a mutable tag.
- `1.26.1` tags are write-once: the workflow refuses to overwrite an existing release.
  Publish a new version/rebuild tag for future base/dependency refreshes.

See [BUILD.md](BUILD.md) and [the release](https://github.com/pgbouncer/pgbouncer/releases/tag/pgbouncer_1_26_1).

Original upstream README follows. Its references to official images refer to
CloudNativePG's registry, not the independently published package above.

---

[![CloudNativePG](./logo/cloudnativepg.png)](https://cloudnative-pg.io/)

---

# CNPG PgBouncer Container Images

This repository contains the scripts and definitions required to build
**immutable application container images** for the latest version of
[PgBouncer](https://www.pgbouncer.org/), a popular connection pooler for PostgreSQL.
These images are designed to be used as operands with the
[CloudNativePG Operator](https://cloudnative-pg.io) for Kubernetes.

The images are based on the latest `stable`
[Debian `slim` official image](https://hub.docker.com/_/debian/),
ensuring a minimal and secure runtime environment.

PgBouncer is distributed under the
[ISC License](https://github.com/pgbouncer/pgbouncer/blob/master/COPYRIGHT).

Pre-built images are available from the
[GitHub Container Registry](https://github.com/cloudnative-pg/pgbouncer-containers/pkgs/container/pgbouncer).

## License and copyright

This software is available under [Apache License 2.0](LICENSE).

Copyright © contributors to CloudNativePG, established as CloudNativePG a Series of LF Projects, LLC.

Licensing information of all the software included in the container images is
in the `/usr/share/doc/*/copyright*` files.

---

<p align="center">
We are a <a href="https://www.cncf.io/sandbox-projects/">Cloud Native Computing Foundation Sandbox project</a>.
</p>

<p style="text-align:center;" align="center">
      <picture align="center">
         <source media="(prefers-color-scheme: dark)" srcset="https://github.com/cncf/artwork/blob/main/other/cncf/horizontal/white/cncf-white.svg?raw=true">
         <source media="(prefers-color-scheme: light)" srcset="https://github.com/cncf/artwork/blob/main/other/cncf/horizontal/color/cncf-color.svg?raw=true">
         <img align="center" src="https://github.com/cncf/artwork/blob/main/other/cncf/horizontal/color/cncf-color.svg?raw=true" alt="CNCF logo" width="50%"/>
      </picture>
</p>

---

<p align="center">
CloudNativePG was originally built and sponsored by <a href="https://www.enterprisedb.com">EDB</a>.
</p>

<p style="text-align:center;" align="center">
      <picture align="center">
         <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/cloudnative-pg/.github/main/logo/edb_landscape_color_white.svg">
         <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/cloudnative-pg/.github/main/logo/edb_landscape_color_grey.svg">
         <img align="center" src="https://raw.githubusercontent.com/cloudnative-pg/.github/main/logo/edb_landscape_color_grey.svg" alt="EDB logo" width="25%"/>
      </picture>
</p>

---

<p align="center">
<a href="https://www.postgresql.org/about/policies/trademarks/">Postgres, PostgreSQL, and the Slonik Logo</a>
are trademarks or registered trademarks of the PostgreSQL Community Association
of Canada, and used with their permission.
</p>
