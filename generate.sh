#!/usr/bin/env bash
set -x
# Generate a new project from Octane
# Usage: npx github:phase2/octane-update [-g] [tag]
#  -g : optional force generator to run. Normally only runs
#       generator on first install
#  tag: optional tag, branch or commit hash of generator.

octaneRoot=".octane-ci"
tmpFolder="_octane"

doGenerate=0
if [ "$1" == "-g" ]; then
  doGenerate=1
  shift
fi
gitRef="$1"

if [ -e "$octaneRoot" ]; then
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
rsync --delete -ac "$tmpFolder/.octane-ci/" "$octaneRoot/"
rm -rf "$tmpFolder"

if [ $doGenerate -eq 1 ]; then
  ${octaneRoot}/scripts/generate.sh
elif [ -e ".env" ]; then
  # Update the .bin folder
  source ${octaneRoot}/scripts/makebin.sh
  # Update the GitHub actions
  ${octaneRoot}/scripts/build-actions.sh ${octaneRoot}/consumers/${OCTANE_CONSUMER}/actions
fi
