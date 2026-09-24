#!/usr/bin/env bash
# Bumps every owners-yaml==X.Y.Z pin in index.html to the latest PyPI release and opens a PR.
# LATEST_VERSION overrides the PyPI lookup; DRY_RUN=1 prints the diff instead of pushing.
set -euo pipefail

page=index.html
pin_pattern='owners-yaml==[0-9]+\.[0-9]+\.[0-9]+'

current=$(grep -oE "$pin_pattern" "$page" | head -1 | cut -d= -f3)
latest=${LATEST_VERSION:-$(curl -fsS https://pypi.org/pypi/owners-yaml/json | python3 -c 'import json, sys; print(json.load(sys.stdin)["info"]["version"])')}

if [[ -z "$current" ]]; then
    echo "::error::no owners-yaml==X.Y.Z pin found in $page"
    exit 1
fi
if [[ ! "$latest" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Latest PyPI version '$latest' is not a plain release, skipping."
    exit 0
fi
newer=$(python3 -c 'import sys; a, b = (tuple(map(int, v.split("."))) for v in sys.argv[1:]); print("yes" if b > a else "no")' "$current" "$latest")
if [[ "$newer" != "yes" ]]; then
    echo "Pin $current is current (PyPI has $latest)."
    exit 0
fi

branch="bump/owners-yaml-$latest"
if [[ -z "${DRY_RUN:-}" ]] && git ls-remote --exit-code --heads origin "$branch" >/dev/null; then
    echo "Branch $branch already exists, so a PR is open or was handled."
    exit 0
fi

sed -i.bak -E "s/$pin_pattern/owners-yaml==$latest/g" "$page" && rm "$page.bak"

if [[ -n "${DRY_RUN:-}" ]]; then
    git --no-pager diff --stat
    git --no-pager diff -U0 | grep -E '^[-+][^-+]'
    git checkout -- "$page"
    exit 0
fi

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git checkout -b "$branch"
git commit -am "chore: bump owners-yaml pin to $latest"
git push origin "$branch"
gh pr create --base main --head "$branch" \
    --title "chore: bump owners-yaml pin to $latest" \
    --body "PyPI has owners-yaml $latest; the page pinned $current. This PR only changes the pins.

Before merging, check the page text against the release notes: https://github.com/PostHog/posthog/blob/master/packages/owners-yaml/CHANGELOG.md

- Run each command on the page against $latest and compare its output with the page.
- Check the text that describes resolution rules, flags, and the FAQ."
