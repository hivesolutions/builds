#!/bin/bash
# -*- coding: utf-8 -*-

set -e +h

rm -rf build
mkdir build
cd build

source ../base.sh

../include.sh
../pcre.sh
../libxml2.sh
../curl.sh
