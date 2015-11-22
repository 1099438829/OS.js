#!/bin/bash
#
# OS.js - JavaScript Operating System
#
# Copyright (c) 2011-2015, Anders Evenrud <andersevenrud@gmail.com>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met: 
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer. 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution. 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# @author  Anders Evenrud <andersevenrud@gmail.com>
# @licence Simplified BSD License
#

BUILDIR=".arduino"
OUTDIR=".arduino/build"
TMPDIR=".arduino/tmp"


#
# Init
#

#(cd src/conf; ln -sf ../templates/conf/500-arduino.json 500-arduino.json)

#echo "UPDATING..."
#git pull
#npm install

echo "BUILDING..."

rm -rf $OUTDIR/*
rm -rf $BUILDIR
mkdir -p $OUTDIR
mkdir -p $TMPDIR
rm -rf dist/themes/*
rm -rf dist/packages/*

mkdir -p $OUTDIR/vfs/home
mkdir -p $OUTDIR/vfs/public
mkdir -p $OUTDIR/vfs/tmp
mkdir -p $OUTDIR/dist/cgi-bin
mkdir -p $OUTDIR/lib/osjs/app

#
# Packages and Styles
#

rm -rf src/packages/target
mkdir -p src/packages/target
cp -v -r src/packages/default/CoreWM src/packages/target/
cp -v -r src/packages/default/Textpad src/packages/target/
cp -v -r src/packages/default/FileManager src/packages/target/
cp -v -r src/packages/default/CoreWM src/packages/target/
cp -v -r src/packages/default/Preview src/packages/target/
cp -v -r src/packages/default/Settings src/packages/target/
cp -v -r src/packages/arduino/ArduinoSettings src/packages/target/
cp -v -r src/packages/arduino/ArduinoService src/packages/target/
cp -v -r src/packages/arduino/ArduinoLuci src/packages/target/
cp -v -r src/packages/arduino/ArduinoKernelLog src/packages/target/
cp -v -r src/packages/arduino/ArduinoSysLog src/packages/target/
cp -v -r src/packages/arduino/ArduinoProcessViewer src/packages/target/

grunt all dist-index

APPS=`(cd src/packages/target; find . -maxdepth 1 -type d)`
for AD in $APPS; do
  AD=$(basename $AD)
  AN=$(echo $AD | awk '{print tolower($0)}')
  if [[ "$AD" != "." ]]; then
    mv -v src/packages/target/$AD/server.lua $OUTDIR/lib/osjs/app/$AN.lua 2>/dev/null
  fi
done

rm -rf src/packages/target

#
# Template
#

# Copy needed files
cp -v README.md $OUTDIR/
cp -v AUTHORS $OUTDIR/
cp -v CHANGELOG.md $OUTDIR/
cp -v -r dist $OUTDIR/
cp -v src/server/lua/osjs.lua $OUTDIR/lib/
cp -v src/server/lua/osjs-fs $OUTDIR/dist/cgi-bin/
cp -v src/server/lua/osjs-api $OUTDIR/dist/cgi-bin/
cp -v src/server/settings.json $OUTDIR/settings.json
cp -v src/mime.json $OUTDIR/mime.json

#
# Themes
#

echo "CLEANING UP THEMES..."

rm -rf $TMPDIR
mkdir -p $TMPDIR
mkdir -p $TMPDIR/16x16
mkdir -p $TMPDIR/32x32

FILES=$(find $OUTDIR/dist/themes/icons/default/16x16 -maxdepth 1 -type d)
for d in $FILES; do
  b=$(basename $d)
  mkdir -p $TMPDIR/16x16/$b
  mkdir -p $TMPDIR/32x32/$b
done

GREPPED=$(grep -RHIi "\.png" $OUTDIR/dist/ | egrep -o '\w+\/[_A-Za-z0-9\-]+\.png')
for g in $GREPPED; do
  cp -v -L $OUTDIR/dist/themes/icons/default/16x16/$g $TMPDIR/16x16/$g 2>/dev/null
  cp -v -L $OUTDIR/dist/themes/icons/default/32x32/$g $TMPDIR/32x32/$g 2>/dev/null
done

cp -v $OUTDIR/dist/themes/icons/default/16x16/*.png $TMPDIR/16x16/
cp -v $OUTDIR/dist/themes/icons/default/32x32/*.png $TMPDIR/32x32/

# Copy standing icons
rm -rf $OUTDIR/dist/themes/icons/default/*
mv -v $TMPDIR/* $OUTDIR/dist/themes/icons/default/

rm -rf $OUTDIR/dist/themes/sounds/*
rm -rf $OUTDIR/dist/themes/wallpapers/*
cp -v src/client/themes/wallpapers/arduino.png $OUTDIR/dist/themes/wallpapers/

#
# Cleanup
#

echo "CLEANING UP..."

rm -rf $OUTDIR/dist/vendor/*
rm -rf $OUTDIR/dist/packages/default
rm -rf $OUTDIR/dist/packages/arduino
rm -rf $TMPDIR
rm $OUTDIR/dist/.htaccess
rm $OUTDIR/dist/.gitignore
rm $OUTDIR/dist/vendor/.gitignore
rm $OUTDIR/dist/themes/.gitignore
rm $OUTDIR/dist/packages/.gitignore
rm $OUTDIR/dist/api.php
rm $OUTDIR/dist/packages/*/*/package.json

echo "\n\nDONE :-)"
