# Release Instructions

## Building for Distribution

### 1. Update Version Number

In Xcode:
1. Select the **SnapSim** project
2. Select the **SnapSim** target
3. Under **General**, update:
   - **Version** (e.g., 1.0.0)
   - **Build** (e.g., 1)

### 2. Archive the App

```bash
# Clean build folder
Product > Clean Build Folder (⇧⌘K)

# Archive
Product > Archive (⌘B then select Archive scheme)
```

Or via command line:
```bash
xcodebuild clean archive \
  -project SnapSim.xcodeproj \
  -scheme SnapSim \
  -archivePath ./build/SnapSim.xcarchive
```

### 3. Export the App

1. In Xcode Organizer (Window > Organizer)
2. Select the archive
3. Click **Distribute App**
4. Choose **Copy App**
5. Select **Export**
6. Choose destination folder

### 4. Create DMG (Optional)

For a professional installer:

```bash
# Create a temporary folder
mkdir -p dmg/SnapSim
cp -R /path/to/SnapSim.app dmg/SnapSim/

# Create DMG
hdiutil create -volname "SnapSim" \
  -srcfolder dmg/SnapSim \
  -ov -format UDZO \
  SnapSim-v1.0.0.dmg
```

### 5. Create ZIP

```bash
cd /path/to/SnapSim.app/..
zip -r SnapSim-v1.0.0.zip SnapSim.app
```

### 6. Create GitHub Release

1. Go to [GitHub Releases](https://github.com/emrdgrmnci/SnapSim/releases)
2. Click **Draft a new release**
3. Create a tag (e.g., `v1.0.0`)
4. Add release notes
5. Upload the ZIP file
6. Publish release

## Release Checklist

- [ ] Version number updated
- [ ] All features tested
- [ ] README updated
- [ ] Screenshots updated
- [ ] Changelog updated
- [ ] Code signed (for distribution)
- [ ] App archived
- [ ] ZIP created
- [ ] GitHub release created
- [ ] Release notes written

## Code Signing (For Distribution)

For public distribution outside the Mac App Store:

1. Get a **Developer ID Application** certificate from Apple
2. In Xcode:
   - Select project > SnapSim target
   - Signing & Capabilities
   - Select your Developer ID certificate
3. Archive with this certificate

## Notarization (Required for macOS 10.15+)

```bash
# Submit for notarization
xcrun notarytool submit SnapSim-v1.0.0.zip \
  --apple-id "your@email.com" \
  --password "app-specific-password" \
  --team-id "TEAM_ID" \
  --wait

# Staple the notarization ticket
xcrun stapler staple SnapSim.app
```

## Testing the Release

Before publishing:
1. Test on a clean Mac (if possible)
2. Verify Gatekeeper doesn't block it
3. Test all features
4. Verify accessibility permissions prompt works

