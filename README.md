# owners-yaml website

Landing page for [owners-yaml](https://github.com/PostHog/posthog/tree/master/packages/owners-yaml), served at https://owners-yaml.posthog.dev.

The package, its spec, and its docs live in the PostHog monorepo under `packages/owners-yaml`.
This repo holds only the page.

## Edit

`index.html` is the whole site: one static file, no build step.
Preview it with any static server:

```sh
python3 -m http.server 8000
```

Every command on the page runs against the owners-yaml version the CI example pins.
When a release changes a command, an output, or a resolution rule, update the page and the pin together.

## Deploy

GitHub Pages serves the `main` branch root; `.nojekyll` turns off the Jekyll build.
Until DNS exists, the page is at https://posthog.github.io/owners-yaml-website/.

To move to the custom domain:

1. Add the `owners-yaml.posthog.dev` CNAME to `posthog.github.io.` in the `posthog.dev` Route53 zone (posthog-cloud-infra).
2. Set the custom domain in the repo's Pages settings. GitHub commits a `CNAME` file for it.
3. Turn on "Enforce HTTPS" once the certificate is issued.

The social tags in `index.html` already use absolute `https://owners-yaml.posthog.dev/` URLs, so link previews work only after step 1.
