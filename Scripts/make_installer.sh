#!/bin/sh

# Script for creating installer package

# Fail if not deployment
if [ ! "${CONFIGURATION}" = "Release" ]; then
    echo "error: This should only be run as Release ; use 'Build For Profiling' in Xcode" >&2
    exit 1
fi

CODE_SIGN_IDENTITY="Developer ID Application: Barijaona Ramaholimihaso"
PKG_SIGN_IDENTITY="Developer ID Installer: Barijaona Ramaholimihaso"
frameworks_path="$BUILT_PRODUCTS_DIR/UniversalMailer.mailbundle/Contents/Frameworks"

# cf. https://furbo.org/2019/08/16/catalina-app-notarization-and-sparkle/
codesign --verbose --force --deep -o runtime --sign "${CODE_SIGN_IDENTITY}" "$frameworks_path/Sparkle.framework/Versions/A/Resources/AutoUpdate.app"
codesign --verbose --force -o runtime --sign "${CODE_SIGN_IDENTITY}" "$frameworks_path/Sparkle.framework/Versions/A"
codesign --verbose --force -o runtime --sign "${CODE_SIGN_IDENTITY}" "$BUILT_PRODUCTS_DIR/UniversalMailer.mailbundle"

pkgbuild --root "$BUILT_PRODUCTS_DIR/UniversalMailer.mailbundle/" --scripts "$SRCROOT/Scripts/installation_scripts/" \
         --identifier it.noware.universalmailer.pkg --install-location "/tmp/UM-installation-tmp/UniversalMailer.mailbundle" \
         --sign "${PKG_SIGN_IDENTITY}" \
         "$BUILT_PRODUCTS_DIR/UniversalMailer.pkg"

open "$BUILT_PRODUCTS_DIR"
