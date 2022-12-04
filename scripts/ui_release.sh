#!/bin/bash

## /!\ This file must be used at the root of the project
## This script provides utils method to help to release and verify the readiness of each libs under the folder ui/

set -e

cd ui/

files=("../LICENSE" "../CHANGELOG.md")
workspaces=$(jq -r '.workspaces[]' < package.json)

function copy() {
  for file in "${files[@]}"; do
    for workspace in ${workspaces}; do
      if [ -f "${file}" ]; then
        cp "${file}" "${workspace}"/"$(basename "${file}")"
      fi
    done
  done
}

function publish() {
  dry_run="${1}"
  cmd="npm publish --access public"
  if [[ "${dry_run}" == "dry-run" ]]; then
    cmd+=" --dry-run"
  fi
  for workspace in ${workspaces}; do
    # package "app" is private so we shouldn't try to publish it.
    if [[ "${workspace}" != "app" ]]; then
      cd "${workspace}"
      eval "${cmd}"
      cd ../
    fi
  done
}

function checkPackage() {
  version=${1}
  if [[ "${version}" == v* ]]; then
    version="${version:1}"
  fi
  for workspace in ${workspaces}; do
    cd "${workspace}"
    package_version=$(npm run env | grep npm_package_version | cut -d= -f2-)
    if [ "${version}" != "${package_version}" ]; then
      echo "version of ${workspace} is not the correct one"
      echo "expected one: ${version}"
      echo "current one: ${package_version}"
      echo "please use ./ui_release --release ${version}"
      exit 1
    fi
    cd ..
  done
}

function clean() {
  for file in "${files[@]}"; do
    for workspace in ${workspaces}; do
      f="${workspace}"/"$(basename "${file}")"
      if [ -f "${f}" ]; then
        rm "${f}"
      fi
    done
  done
}

function bumpVersion() {
  version="${1}"
  if [[ "${version}" == v* ]]; then
    version="${version:1}"
  fi
  # upgrade the @julie-test-changesets/* dependencies on all packages
  for workspace in ${workspaces}; do
    echo "${workspace}"/package.json
    sed -E -i "" "s|(\"@julie-test-changesets/.+\": )\".+\"|\1\"\^${version}\"|" "${workspace}"/package.json
  done

  # increase the version on all packages
  npm version "${version}" --workspaces
}

function snapshotVersion() {
  branch="${1}"
  sha="${2}"
  snapshotName="0.0.0-$(echo "${branch}" | sed -E  's/.*\///')-${sha}"
  echo "Creating snapshot ${snapshotName}"
  echo "${snapshotName}" > ../VERSION
  bumpVersion "${snapshotName}"
  checkPackage "${snapshotName}"
}

function publishSnapshot() {
  branch="${1}"
  tagName="$(echo "${branch}" | sed -E  's/.*\///')"

  if [[ -z "${tagName}" ]]; then 
    echo "Missing tag name for snapshot."
    exit 1
  fi

  echo "Publishing snapshot to tag ${tagName}"
  cmd="npm publish --access public --tag ${tagName}"
  for workspace in ${workspaces}; do
    # package "app" is private so we shouldn't try to publish it.
    if [[ "${workspace}" != "app" ]]; then
      cd "${workspace}"
      eval "${cmd}"
      cd ../
    fi
  done
}

if [[ "$1" == "--copy" ]]; then
  copy
fi

if [[ $1 == "--publish" ]]; then
  publish "${@:2}"
fi

if [[ $1 == "--check-package" ]]; then
  checkPackage "${@:2}"
fi

if [[ $1 == "--bump-version" ]]; then
  bumpVersion "${@:2}"
fi

if [[ $1 == "--clean" ]]; then
  clean
fi

if [[ $1 == "--snapshot-version" ]]; then
  snapshotVersion "${@:2}"  "${@:3}"
fi

if [[ $1 == "--publish-snapshot" ]]; then
  publishSnapshot "${@:2}"
fi


