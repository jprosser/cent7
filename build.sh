#!/bin/bash

maj=7
if [ $# -ne 1 ]; then
  echo "choosing CentOS 7"
fi

maj=${1}

cent=$(buildah from scratch)

osdir=$(buildah mount $cent)

if [ $maj -eq 8 ]; then
  # put the 8 base in place
  c8url="http://centos.s.uw.edu/centos/8/BaseOS/x86_64/os/Packages/"
  c8release="centos-release-8.0-0.1905.0.9.el8.x86_64.rpm"
  curl -O --url "${c8url}${c8release}"
  rpm --root $osdir --initdb
  rpm --root $osdir -ihv ./${c8release}
fi

yum install --installroot $osdir --releasever ${maj} curl bash coreutils -y

buildah config --created-by "UW Med Research IT"  $cent

buildah config --author "rithelp@uw.edu" --label name=uwrit${maj}-basic $cent

buildah unmount $cent

buildah commit $cent uwrit${maj}-basic

buildah rm $cent
