#!/bin/bash

#
# This script is used to build Kedos on top of Ubuntu.
# It is a WIP so do not expect it to product an iso yet.
# Copyright Abraham Masri. 2017
#

logEvent () {

    logText="$1"

    time="$(date +%T)"
    echo "[Important: $time] $logText"

}

# First function to get called
# Checks for permissions and required
# libraries, then builds
startBuild () {

    # Change me based on Ubuntu's build name
    ubuntuBuildName='trusty'
    ubuntuBuildVersion='14.04.5'

    kedosBuildName='summit'
    kedosBuildVersion='1.0'


    # Check if we are root
    if [[ "$(whoami)" != 'root' ]]; then
        logEvent 'You are not root, please run as root.';
        return;
    fi

    # Be nice and log
    echo "Welcome to Kedos Builder"

    # Check if we have kedos files inside
    if [ "$(ls -A $PWD/system/)" == '' ]; then
        logEvent "Kedos system packages are missing. Check $PWD/system/";
        return;
    fi


    # Update all apt packages
    logEvent 'Updating APT packages..'
    apt-get update > /dev/null

    # Clean up before doing anything
    logEvent 'Cleaning up [Directories and Live Build]..'
    rm -rf build_tmp
    lb clean noauto > /dev/null

    # Setup our building directories (We keep all tmp files inside instead of /tmp/)
    logEvent 'Setting up the building directory'
    buildTempDirectory=$(mkdir build_tmp)

    # Download Ubuntu
    logEvent "Downloading Ubuntu $ubuntuBuildName $ubuntuBuildVersion.."
    wget "http://releases.ubuntu.com/$ubuntuBuildName/ubuntu-$ubuntuBuildVersion-desktop-amd64.iso" -q --show-progress --output-document "$ubuntuBuildName".iso

    # Configure Live Build | HOOKS REMOVED <--
    logEvent 'Running configurations..'
    lb config noauto --distribution "$ubuntuBuildName" --architecture amd64 --binary-images iso-hybrid --bootloader syslinux --bootstrap-keyring ubuntu-keyring \
    --build-with-chroot false --iso-application "Kedos" --iso-volume "Kedos-$kedosBuildName-$kedosBuildVersion" \
    --memtest none --mode ubuntu --parent-archive-areas "main restricted universe multiverse" --source false --zsync false

    # Run build
    logEvent 'Building system..'
    lb build

}

startBuild
