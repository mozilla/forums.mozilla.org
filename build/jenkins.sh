#!/usr/bin/env bash

set -eu

BUILD_DIR=`dirname $0`
cd $BUILD_DIR/..

BRANCH=`git symbolic-ref --short HEAD`
if [ "$BRANCH" == "master" ]; then
  echo "Can't release from $BRANCH branch"
  exit 1
fi

REPO=rpms/$BRANCH

./build/release.sh --define="rpm_jenkins_job jenkins.$BUILD_NUMBER."

mkdir -p $REPO/SRPMS
mkdir -p $REPO/RPMS/noarch

mv *.src.rpm $REPO/SRPMS/
mv *.rpm $REPO/RPMS/noarch/

createrepo --revision=$BUILD_NUMBER --update $REPO

gpg --export -a jenkins@mozilla.org > $REPO/RPM-KEY

cat << EOF > $REPO/$JOB_NAME.repo
[$BRANCH]
name=$BRANCH
baseurl=${JOB_URL}lastSuccessfulBuild/artifact/$REPO
gpgcheck=0
gpgkey=${JOB_URL}lastSuccessfulBuild/artifact/$REPO/RPM-KEY
enabled=1
EOF
