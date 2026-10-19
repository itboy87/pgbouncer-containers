# Building the independently maintained PgBouncer 1.26.1 image

The workflow is manual-only. In GitHub Actions, dispatch `build.yml` on the
reviewed default branch. It builds amd64/arm64, runs upstream regressions and
binary/UID checks, scans fixable high/critical vulnerabilities, and signs the digest.
SBOM and maximum-mode build provenance are attached by Buildx.

The package must be explicitly public in GitHub package settings before deploying
without pull credentials. Verify an anonymous manifest pull; repository visibility
alone does not establish package visibility.

The workflow refuses to replace the `1.26.1` tag. For a reviewed dependency refresh,
choose a new version/rebuild tag, preserving the prior deployment digest for rollback.
Do not rerun a successful publication to move the release tag.

For an unpublished local build:

```sh
environment=production registry=localhost:5000 revision=$(git rev-parse HEAD) docker buildx bake
```

`docker-bake.hcl` pins the Debian base and official source archive checksum. No
production credentials or private repository files are part of this build context.
The output retains the upstream CloudNativePG non-root operand paths and identity.
Licenses and attribution remain in `LICENSE` and the installed source `COPYRIGHT`.
