#!/bin/bash

set -e

# Clean
echo "Cleaning"
rm -rf target

# Grab version
version=$(mvn -B help:evaluate -Dexpression=project.version 2>/dev/null| grep -v "^\[")
echo "Building scripts version $version"

# Build uberjar and filter resources
echo "Building uberjar"
mvn -B clean package -Dmaven.test.skip=true

# Make tar file of jar and script
echo "Building scripts tar file"
cp target/classes/clojure target
cp target/classes/clj target
cp target/classes/deps.edn target
cp target/classes/example-deps.edn target
chmod +x target/clojure target/clj

# Deploy to s3
if [[ ! -z "$S3_BUCKET" ]]; then
  echo "Deploying https://download.clojure.org/install/brew/clojure-scripts-${version}.tar.gz"
  aws s3 cp --only-show-errors "target/clojure-scripts-${version}.tar.gz" "$S3_BUCKET/install/brew/clojure-scripts.tar.gz"
  aws s3 cp --only-show-errors "target/clojure-scripts-${version}.tar.gz" "$S3_BUCKET/install/brew/clojure-scripts-${version}.tar.gz"
  echo "Deploying https://download.clojure.org/install/brew/clojure-${version}.rb"
  aws s3 cp --only-show-errors "target/clojure.rb" "$S3_BUCKET/install/brew/clojure.rb"
  aws s3 cp --only-show-errors "target/clojure.rb" "$S3_BUCKET/install/brew/clojure-${version}.rb"
fi
