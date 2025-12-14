# Release Checklist for v1.1.0

## ✅ Completed

- [x] Version updated to 1.1.0
- [x] Build number incremented to 2
- [x] CHANGELOG.md updated
- [x] Release notes created

## 📋 Next Steps

### 1. Commit Changes

```bash
# Stage all changes
git add SnapSim.xcodeproj/project.pbxproj
git add CHANGELOG.md
git add RELEASE_NOTES_v1.1.0.md
git add TESTING.md
git add SnapSim/AppDelegate.swift

# Commit
git commit -m "Release v1.1.0: Add auto-open and launch at login features"
```

### 2. Create Git Tag

```bash
# Create annotated tag
git tag -a v1.1.0 -m "Release v1.1.0: Auto-open when Simulator launches and Launch at Login"

# Push tag to GitHub
git push origin v1.1.0
```

### 3. Build Release Version

In Xcode:
1. Select **Product > Scheme > SnapSim**
2. Select **Product > Destination > Any Mac**
3. **Product > Archive** (⌘B, then Archive)
4. Wait for archive to complete

Or via command line:
```bash
xcodebuild clean archive \
  -project SnapSim.xcodeproj \
  -scheme SnapSim \
  -archivePath ./build/SnapSim-v1.1.0.xcarchive \
  -configuration Release
```

### 4. Export the App

1. Open **Xcode Organizer** (Window > Organizer)
2. Select the **SnapSim** archive
3. Click **Distribute App**
4. Choose **Copy App**
5. Click **Next**
6. Select **Export**
7. Choose destination folder (e.g., `./release/`)

### 5. Create ZIP for Distribution

```bash
# Navigate to exported app location
cd /path/to/exported/SnapSim.app/..

# Create ZIP
zip -r SnapSim-v1.1.0.zip SnapSim.app

# Verify
ls -lh SnapSim-v1.1.0.zip
```

### 6. Create GitHub Release

1. Go to: https://github.com/emrdgrmnci/SnapSim/releases/new
2. **Tag version:** Select `v1.1.0` (or create new tag)
3. **Release title:** `SnapSim v1.1.0 - Auto-Open & Launch at Login`
4. **Description:** Copy from `RELEASE_NOTES_v1.1.0.md`
5. **Attach binary:** Upload `SnapSim-v1.1.0.zip`
6. Check **"Set as the latest release"**
7. Click **"Publish release"**

### 7. Push Changes to GitHub

```bash
# Push commits
git push origin main

# Push tag (if not done in step 2)
git push origin v1.1.0
```

## 📝 Release Notes Template

```markdown
# SnapSim v1.1.0

## 🎉 What's New

### ✨ Auto-Open When Simulator Launches
SnapSim can now automatically activate when you launch Xcode Simulator!

**How to enable:**
1. Click the SnapSim menu bar icon (📱)
2. Check "Open SnapSim when Simulator opens"
3. Launch Simulator - SnapSim will automatically activate!

### 🚀 Launch at Login
Start SnapSim automatically when you log in to your Mac.

**How to enable:**
1. Click the SnapSim menu bar icon (📱)
2. Check "Launch at Login"
3. Log out and log back in - SnapSim will start automatically!

## 🐛 Bug Fixes

- Fixed crash when enabling Launch at Login with empty login items list
- Improved compatibility with macOS login items management
- Fixed type conversion issues with CoreServices APIs

## 📦 Installation

1. Download `SnapSim-v1.1.0.zip`
2. Unzip and move `SnapSim.app` to `/Applications`
3. Open SnapSim and grant Accessibility permissions

## 🔄 Upgrading

Simply replace the old app with the new version. Your settings will be preserved.

---

**Full Changelog:** [CHANGELOG.md](https://github.com/emrdgrmnci/SnapSim/blob/main/CHANGELOG.md)
```

## 🧪 Testing Before Release

- [ ] Test "Open SnapSim when Simulator opens" feature
- [ ] Test "Launch at Login" feature
- [ ] Verify app launches correctly
- [ ] Test hide/show simulator functionality
- [ ] Verify menu items work correctly
- [ ] Test on clean macOS installation (if possible)

## 📌 Notes

- Remember to code sign the app for distribution
- Consider notarization for macOS 10.15+ compatibility
- Update README.md if needed with new features
