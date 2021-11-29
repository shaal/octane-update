#!/usr/bin/env bash
# Generate a new project from Octane
# Usage: npx github:phase2/octane-update [tag]
#   tag: optional tag or commit hash of generator.
echo "Hello world"
octaneFolder=".octane-ci"
tmpFolder="_octane"
rm -rf "$tmpFolder"
git clone git@github.com:phase2/octane-ci.git "$tmpFolder"
rsync --delete -ac "$tmpFolder/.octane-ci/" "$octaneFolder/"
rm -rf "$tmpFolder"
