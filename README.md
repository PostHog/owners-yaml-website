# owners-yaml website

Landing page for [owners-yaml](https://github.com/PostHog/posthog/tree/master/packages/owners-yaml), served at https://owners-yaml.posthog.dev.

The package, its spec, and its docs live in the PostHog monorepo under `packages/owners-yaml`.
This repo holds only the page.

## Edit

`index.html` is the whole site: one static file, no build step.
`fonts/` holds Open Runde, PostHog's typeface, under the SIL Open Font License (`fonts/OFL.txt`). Code uses Source Code Pro from Google Fonts.
Preview it with any static server:

```sh
python3 -m http.server 8000
```

Every command on the page runs against the owners-yaml version the CI example pins.
When a release changes a command, an output, or a resolution rule, update the page and the pin together.

A daily workflow (`bump-owners-yaml.yml`) opens a PR when PyPI has a newer owners-yaml. It only bumps the `owners-yaml==X.Y.Z` pins; check the text against the release notes before merging. Run it by hand with `gh workflow run bump-owners-yaml.yml`. `CODEOWNERS` requests a review from team-devex on every PR, the bump PRs included.

## Deploy

GitHub Pages serves the `main` branch root; `.nojekyll` turns off the Jekyll build.
`CNAME` sets the custom domain, `owners-yaml.posthog.dev`.
DNS is a CNAME to `posthog.github.io.` in the `posthog.dev` Route53 zone, managed in posthog-cloud-infra.
Turn on "Enforce HTTPS" in the Pages settings once GitHub issues the certificate.
