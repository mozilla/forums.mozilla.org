#!/usr/bin/env bash

BUILD_DIR=`dirname $0`
cd $BUILD_DIR/..

./build/release.sh --define="rpm_jenkins_job jenkins.1234."

mkdir -p rpms/SRPMS
mkdir -p rpms/RPMS/noarch

mv *.src.rpm rpms/SRPMS/
mv *.rpm rpms/RPMS/noarch/

createrepo --revision=$BUILD_NUMBER --update rpms

gpg --export -a jenkins@mozilla.org > rpms/RPM-KEY

cat << EOF > rpms/$JOB_NAME.repo
[$JOB_NAME]
name=$JOB_NAME
baseurl=${JOB_URL}lastSuccessfulBuild/artifact/rpms/
gpgcheck=0
gpgkey=${JOB_URL}lastSuccessfulBuild/artifact/rpms/RPM-KEY
enabled=1
EOF
