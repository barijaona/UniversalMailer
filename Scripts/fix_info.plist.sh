#!/bin/sh

# Script for inserting into Info.plist the UUIDs
# required for Mail Plugins compatibility check

INFO="${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/../Info.plist"

BUILD_VERSION="$(git rev-list --count HEAD)"
COMMIT_HASH="$(git rev-parse HEAD)"
VERSION="$(git describe HEAD |  sed -e 's:^v/::' | sed -e 's:_beta: Beta :' -e 's:_rc: RC :')"

/usr/libexec/PlistBuddy \
  -c "Set CFBundleVersion '$BUILD_VERSION'" \
  -c "Set CommitHash '$COMMIT_HASH'" \
  -c "Set CFBundleShortVersionString '$VERSION'" \
  "$INFO" || exit 2

defaults write "$INFO" Supported10.12PluginCompatibilityUUIDs -array-add '21560BD9-A3CC-482E-9B99-95B7BF61EDC1'
defaults write "$INFO" Supported10.12PluginCompatibilityUUIDs -array-add '1CD3B36A-0E3B-4A26-8F7E-5BDF96AAC97E'
defaults write "$INFO" Supported10.12PluginCompatibilityUUIDs -array-add '9054AFD9-2607-489E-8E63-8B09A749BC61'
defaults write "$INFO" Supported10.12PluginCompatibilityUUIDs -array-add '36CCB8BB-2207-455E-89BC-B9D6E47ABB5B'
defaults write "$INFO" Supported10.13PluginCompatibilityUUIDs -array-add 'C86CD990-4660-4E36-8CDA-7454DEB2E199'
defaults write "$INFO" Supported10.14PluginCompatibilityUUIDs -array-add 'A4343FAF-AE18-40D0-8A16-DFAE481AF9C1'
defaults write "$INFO" Supported10.15PluginCompatibilityUUIDs -array-add '6EEA38FB-1A0B-469B-BB35-4C2E0EEA9053'
defaults write "$INFO" Supported11.0PluginCompatibilityUUIDs -array-add 'D985F0E4-3BBC-4B95-BBA1-12056AC4A531'
defaults write "$INFO" Supported11.1PluginCompatibilityUUIDs -array-add 'D985F0E4-3BBC-4B95-BBA1-12056AC4A531'
defaults write "$INFO" Supported11.2PluginCompatibilityUUIDs -array-add 'D985F0E4-3BBC-4B95-BBA1-12056AC4A531'
defaults write "$INFO" Supported11.3PluginCompatibilityUUIDs -array-add 'D985F0E4-3BBC-4B95-BBA1-12056AC4A531'
defaults write "$INFO" Supported11.4PluginCompatibilityUUIDs -array-add 'D985F0E4-3BBC-4B95-BBA1-12056AC4A531'
defaults write "$INFO" Supported11.5PluginCompatibilityUUIDs -array-add 'D985F0E4-3BBC-4B95-BBA1-12056AC4A531'
defaults write "$INFO" Supported11.6PluginCompatibilityUUIDs -array-add 'D985F0E4-3BBC-4B95-BBA1-12056AC4A531'
defaults write "$INFO" Supported11.7PluginCompatibilityUUIDs -array-add 'D985F0E4-3BBC-4B95-BBA1-12056AC4A531'
defaults write "$INFO" Supported12.0PluginCompatibilityUUIDs -array-add '25288CEF-7D9B-49A8-BE6B-E41DA6277CF3'
defaults write "$INFO" Supported12.1PluginCompatibilityUUIDs -array-add '6FF8B077-81FA-45A4-BD57-17CDE79F13A5'
defaults write "$INFO" Supported12.2PluginCompatibilityUUIDs -array-add '6FF8B077-81FA-45A4-BD57-17CDE79F13A5'
defaults write "$INFO" Supported12.3PluginCompatibilityUUIDs -array-add 'A4B49485-0377-4FAB-8D8E-E3B8018CFC21'
defaults write "$INFO" Supported12.4PluginCompatibilityUUIDs -array-add 'A4B49485-0377-4FAB-8D8E-E3B8018CFC21'
defaults write "$INFO" Supported12.5PluginCompatibilityUUIDs -array-add 'A4B49485-0377-4FAB-8D8E-E3B8018CFC21'
defaults write "$INFO" Supported12.6PluginCompatibilityUUIDs -array-add 'A4B49485-0377-4FAB-8D8E-E3B8018CFC21'
defaults write "$INFO" Supported12.7PluginCompatibilityUUIDs -array-add 'A4B49485-0377-4FAB-8D8E-E3B8018CFC21'
defaults write "$INFO" Supported13.0PluginCompatibilityUUIDs -array-add '890E3F5B-9490-4828-8F3F-B6561E513FCC'
defaults write "$INFO" Supported13.1PluginCompatibilityUUIDs -array-add '890E3F5B-9490-4828-8F3F-B6561E513FCC'
defaults write "$INFO" Supported13.2PluginCompatibilityUUIDs -array-add '890E3F5B-9490-4828-8F3F-B6561E513FCC'
defaults write "$INFO" Supported13.3PluginCompatibilityUUIDs -array-add '281F8A5C-0AF9-4BE6-8B8A-C0CB9C2068BE'
defaults write "$INFO" Supported13.4PluginCompatibilityUUIDs -array-add '281F8A5C-0AF9-4BE6-8B8A-C0CB9C2068BE'
defaults write "$INFO" Supported13.5PluginCompatibilityUUIDs -array-add '281F8A5C-0AF9-4BE6-8B8A-C0CB9C2068BE'
defaults write "$INFO" Supported13.6PluginCompatibilityUUIDs -array-add '281F8A5C-0AF9-4BE6-8B8A-C0CB9C2068BE'
defaults write "$INFO" Supported13.7PluginCompatibilityUUIDs -array-add '281F8A5C-0AF9-4BE6-8B8A-C0CB9C2068BE'
