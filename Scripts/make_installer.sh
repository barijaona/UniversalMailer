#!/bin/sh

# Script for creating installer package

if [[ $CONFIGURATION != "Debug" ]]; then
pkgbuild --root "$BUILT_PRODUCTS_DIR/UniversalMailer.mailbundle/" --scripts "$SRCROOT/Scripts/installation_scripts/" --identifier it.noware.universalmailer.pkg --install-location "/tmp/UM-installation-tmp/UniversalMailer.mailbundle" "$BUILT_PRODUCTS_DIR/UniversalMailer.pkg"
open "$BUILT_PRODUCTS_DIR"
else
echo "warning: installer not generated with Debug configuration"
fi
