#!/usr/bin/env bash
# Generate a new project from Octane
# Usage: npx github:phase2/octane-update [-g] [tag]
#  -g : optional force generator to run. Normally only runs
#       generator on first install
#  tag: optional tag, branch or commit hash of generator.

gitRef="$1"
octaneFolder=".octane-ci"
tmpFolder="_octane"

doGenerate=0
if [ "$1" == "-g" ]; then
  doGenerate=1
  shift
fi

if [ -e "$octaneFolder" ]; then
  echo "Updating octane-ci..."
else
  echo "Downloading octane-ci..."
  doGenerate=1
fi

rm -rf "$tmpFolder"
git clone --quiet git@github.com:phase2/octane-ci.git "$tmpFolder"
if [ ! -z "$gitRef" ]; then
  cd "$tmpFolder"
  echo "Switching to version $gitRef..."
  git checkout --quiet "$gitRef"
  cd - >/dev/null
fi
rsync --delete -ac "$tmpFolder/.octane-ci/" "$octaneFolder/"
rm -rf "$tmpFolder"

if [ $doGenerate -eq 1 ]; then
  ${octaneFolder}/scripts/generate.sh
fi
