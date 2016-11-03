#!/bin/bash
# repo sync
export JENKINS_HOME=/root/
if [ "$sync" = "yes" ];
then
repo sync -c -f --force-sync --no-clone-bundle --no-tags -j69
fi
# java
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
# ccache
export USE_CCACHE=1
export CCACHE_DIR=~/ccache/
prebuilts/misc/linux-x86/ccache/ccache -M 50G
export KBUILD_BUILD_USER=ishubhamsingh
export KBUILD_BUILD_HOST=HybridX
# build
. build/envsetup.sh
lunch aosp_$device-userdebug
# Check number of threads to be used
jobs=$(cat /proc/cpuinfo | grep ^processor | wc -l)
if [ "$type" = "re" ];
then
echo "cleaning old build files........"
rm -f $OUT/*.zip $OUT/*Changelog* $OUT/*.md5sum $OUT/system/build.prop $OUT/obj/KERNEL_OBJ/.version >/dev/null
else
make -j$jobs $type
fi
make -j$jobs  bacon
if [ $? -eq 0 ];
then
cp -v $OUT/*.zip ~/web/
cp -v $OUT/*Changelog* ~/web/
if [ "$clean" = "yes" ];
then
rm -rf $(ls | grep -v script_build.sh)
fi
fi

