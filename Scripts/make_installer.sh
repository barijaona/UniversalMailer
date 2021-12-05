#!/bin/sh

# Script for creating installer package

# Fail if not deployment
if [ ! "${CONFIGURATION}" = "Release" ]; then
    echo "error: This should only be run as Release ; use 'Build For Profiling' in Xcode" >&2
    exit 1
fi

pkgbuild --root "$BUILT_PRODUCTS_DIR/UniversalMailer.mailbundle/" --scripts "$SRCROOT/Scripts/installation_scripts/" --identifier it.noware.universalmailer.pkg --install-location "/tmp/UM-installation-tmp/UniversalMailer.mailbundle" "$BUILT_PRODUCTS_DIR/UniversalMailer.pkg"
open "$BUILT_PRODUCTS_DIR"
