# SnapSim v1.1.0 Release Notes

## 🎉 What's New

### ✨ Auto-Open When Simulator Launches
SnapSim can now automatically activate and bring itself to the front when you launch Xcode Simulator. Perfect for seamless workflow integration!

**How to enable:**
1. Click the SnapSim menu bar icon (📱)
2. Check "Open SnapSim when Simulator opens"
3. Launch Simulator - SnapSim will automatically activate!

### 🚀 Launch at Login
Start SnapSim automatically when you log in to your Mac. No need to remember to launch it manually!

**How to enable:**
1. Click the SnapSim menu bar icon (📱)
2. Check "Launch at Login"
3. Log out and log back in - SnapSim will start automatically!

## 🐛 Bug Fixes

- Fixed crash when enabling Launch at Login with an empty login items list
- Improved compatibility with macOS login items management
- Fixed type conversion issues with CoreServices APIs

## 📋 Technical Details

- Updated to use proper LSSharedFileList API handling
- Added NSWorkspace notification monitoring for Simulator app launches
- Improved error handling and user feedback

## 🔄 Upgrading from v1.0.0

Simply download the new version and replace the old app. Your settings will be preserved.

## 📝 Full Changelog

See [CHANGELOG.md](CHANGELOG.md) for complete details.

---

**Download:** [GitHub Releases](https://github.com/emrdgrmnci/SnapSim/releases/tag/v1.1.0)
