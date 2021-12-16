#!/bin/sh

# Script for inserting into Info.plist the UUIDs
# required for Mail Plugins compatibility check

INFO="${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/../Info.plist"

defaults write "$INFO" Supported10.12PluginCompatibilityUUIDs -array-add '21560BD9-A3CC-482E-9B99-95B7BF61EDC1'
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
defaults write "$INFO" Supported12.0PluginCompatibilityUUIDs -array-add '25288CEF-7D9B-49A8-BE6B-E41DA6277CF3'
defaults write "$INFO" Supported12.1PluginCompatibilityUUIDs -array-add '6FF8B077-81FA-45A4-BD57-17CDE79F13A5'
