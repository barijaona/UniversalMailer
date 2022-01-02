#!/bin/sh

# Script for creating installer package

# Fail if not deployment
if [ ! "${CONFIGURATION}" = "Release" ]; then
    echo "error: This should only be run as Release ; use 'Build For Profiling' in Xcode" >&2
    exit 1
fi

# Check if we are on a clean version control tag
if [ ! "$(git describe --dirty )" = "$(git describe --tags --abbrev=0)" ]; then
    echo "error: This should be run on a version identified with a tag ; check your Git status." >&2
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

xcrun notarytool submit "$BUILT_PRODUCTS_DIR/UniversalMailer.pkg" --keychain-profile "AC_PASSWORD" --wait
xcrun stapler staple -v "$BUILT_PRODUCTS_DIR/UniversalMailer.mailbundle"
xcrun stapler staple -v "$BUILT_PRODUCTS_DIR/UniversalMailer.pkg"
if ! spctl --verbose=4 --assess --type install "$BUILT_PRODUCTS_DIR/UniversalMailer.pkg"; then
    echo "Error: Installer will not be accepted by Gatekeeper!" 1>&2
    exit 1
fi

BUILD_VERSION="$(git rev-list --count HEAD)"
VERSION="$(git describe HEAD |  sed -e 's:^v/::' | sed -e 's:_beta: Beta :' -e 's:_rc: RC :')"
pubDate="$(git show -s --pretty=format:%cD HEAD)"

GITHUB_REPO="https://github.com/barijaona/UniversalMailer"
SUBDIR="$(git describe --tags --abbrev=0 HEAD |  sed -e 's:^v/:v%2F:')"
GITHUB_RELEASE_URL="${GITHUB_REPO}/releases/tag/${SUBDIR}"
GITHUB_DOWNLOAD_URL="${GITHUB_REPO}/releases/download/${SUBDIR}/UniversalMailer.pkg"

SPARKLE_BIN="${BUILT_PRODUCTS_DIR}/../../../SourcePackages/artifacts/Sparkle/bin"

if [ ! -d "$SPARKLE_BIN" ]; then
	printf 'Unable to locate Sparkle binaries in the binary Swift Package. ' 1>&2
	printf 'Resolve the Swift Packages in Xcode first.\n' 1>&2
	exit 1
fi

export PATH="$SPARKLE_BIN:$PATH"

ED_SIGNATURE_AND_LENGTH="$(sign_update "$BUILT_PRODUCTS_DIR/UniversalMailer.pkg")"

cat > "$BUILT_PRODUCTS_DIR/appcast.xml" << EOF
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">
	<channel>
		<title>UniversalMailer's Changelog</title>
		<link>${GITHUB_REPO}/releases</link>
		<description>Most recent changes with links to updates</description>
		<language>en-us</language>
		<copyright>Copyright 2017 noware.it, plus contributors</copyright>
		<item>
			<title>UniversalMailer ${VERSION} (build ${BUILD_VERSION})</title>
			<pubDate>${pubDate}</pubDate>
			<link>${GITHUB_RELEASE_URL}</link>
			<sparkle:version>${BUILD_VERSION}</sparkle:version>
			<sparkle:shortVersionString>${VERSION} (build ${BUILD_VERSION})</sparkle:shortVersionString>
			<sparkle:minimumSystemVersion>${MACOSX_DEPLOYMENT_TARGET}.0</sparkle:minimumSystemVersion>
			<enclosure url="${GITHUB_DOWNLOAD_URL}" $ED_SIGNATURE_AND_LENGTH type="application/octet-stream" />
		</item>
	</channel>
</rss>

EOF

open "$BUILT_PRODUCTS_DIR"
