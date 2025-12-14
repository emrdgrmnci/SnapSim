# Testing Guide for SnapSim Features

This guide explains how to test the two new features:
1. **Open SnapSim when Simulator opens**
2. **Launch at Login**

## Prerequisites

1. Build and run the SnapSim app
2. Make sure you have Xcode Simulator installed
3. Grant Accessibility permissions to SnapSim (if not already done)

---

## Testing Feature 1: Open SnapSim when Simulator opens

### Step 1: Enable the Feature

1. Click the SnapSim icon in the menu bar (📱)
2. Click on **"Open SnapSim when Simulator opens"**
3. Verify that a checkmark (✓) appears next to the menu item

### Step 2: Test the Feature

1. **Quit the Simulator app** (if it's currently running):
   - Open Simulator
   - Press `⌘Q` or go to Simulator > Quit Simulator

2. **Switch to another app** (e.g., Safari, Finder) so SnapSim is not in the foreground

3. **Launch the Simulator app**:
   - Open Xcode
   - Go to Xcode > Open Developer Tool > Simulator
   - OR use Spotlight (⌘Space) and search for "Simulator"
   - OR run from Terminal: `open -a Simulator`

4. **Verify the result**:
   - SnapSim should automatically activate/bring itself to the front
   - You should see a notification: "Simulator Detected: SnapSim is ready"
   - Check the Console app for log messages: `📱 Simulator app launched - activating SnapSim`

### Step 3: Disable and Test Again

1. Click the SnapSim menu bar icon
2. Click **"Open SnapSim when Simulator opens"** again to disable it
3. Verify the checkmark disappears
4. Launch Simulator again - SnapSim should **NOT** activate automatically

### Troubleshooting

- **SnapSim doesn't activate**: 
  - Check Console.app for error messages
  - Verify the feature is enabled (checkmark visible)
  - Make sure you're launching a fresh instance of Simulator (quit it first)

- **Check logs**: Open Console.app and filter for "SnapSim" to see detailed logs

---

## Testing Feature 2: Launch at Login

### Step 1: Enable the Feature

1. Click the SnapSim icon in the menu bar (📱)
2. Click on **"Launch at Login"**
3. Verify that a checkmark (✓) appears next to the menu item
4. You should see a notification: "Launch at Login Enabled: SnapSim will start automatically"

### Step 2: Verify in System Settings

1. Open **System Settings** (or System Preferences on older macOS)
2. Go to **General** > **Login Items** (or **Users & Groups** > **Login Items** on older macOS)
3. Look for **SnapSim** in the list
4. It should be listed and enabled

### Step 3: Test via Terminal (Quick Check)

Run this command in Terminal to see all login items:

```bash
osascript -e 'tell application "System Events" to get the name of every login item'
```

You should see "SnapSim" in the output.

### Step 4: Test Actual Login (Full Test)

**Option A: Logout/Login (Recommended for full test)**
1. Save all your work
2. Log out of your user account (Apple menu > Log Out)
3. Log back in
4. SnapSim should automatically launch (you'll see the menu bar icon)

**Option B: Restart (Most thorough test)**
1. Save all your work
2. Restart your Mac
3. After login, SnapSim should automatically launch

**Option C: Quick Test without Logging Out**
- Use Activity Monitor to verify SnapSim is set up correctly
- The login item should be registered even if you don't log out

### Step 5: Disable and Verify Removal

1. Click the SnapSim menu bar icon
2. Click **"Launch at Login"** again to disable it
3. Verify the checkmark disappears
4. Check System Settings > Login Items - SnapSim should be **removed** from the list
5. You should see a notification: "Launch at Login Disabled: SnapSim will not start automatically"

### Troubleshooting

- **Feature doesn't work**:
  - Make sure the app is properly code-signed (required for login items)
  - Check Console.app for error messages
  - Try disabling and re-enabling the feature

- **App not in Login Items list**:
  - The app might need to be in `/Applications` folder for login items to work properly
  - Try moving SnapSim.app to `/Applications` and test again

- **Check logs**: Open Console.app and filter for "SnapSim" to see detailed logs about login item operations

---

## Testing Both Features Together

1. Enable both features (both should have checkmarks)
2. Quit SnapSim completely
3. Log out and log back in (or restart)
4. SnapSim should launch automatically (Launch at Login)
5. Launch Simulator app
6. SnapSim should activate/bring to front (Open on Simulator Launch)

---

## Console Logging

For detailed debugging, check the Console app:

1. Open **Console.app** (Applications > Utilities > Console)
2. In the search box, type: `SnapSim`
3. Look for messages like:
   - `✓ Simulator launch monitoring enabled`
   - `📱 Simulator app launched - activating SnapSim`
   - `✓ Launch at Login enabled`
   - `✓ Launch at Login disabled`

---

## Quick Test Checklist

### Open SnapSim when Simulator opens
- [ ] Feature can be enabled (checkmark appears)
- [ ] Feature can be disabled (checkmark disappears)
- [ ] SnapSim activates when Simulator launches (when enabled)
- [ ] SnapSim does NOT activate when feature is disabled
- [ ] Notification appears when feature is toggled

### Launch at Login
- [ ] Feature can be enabled (checkmark appears)
- [ ] Feature can be disabled (checkmark disappears)
- [ ] App appears in System Settings > Login Items (when enabled)
- [ ] App is removed from Login Items (when disabled)
- [ ] App launches automatically after logout/login (when enabled)
- [ ] Notification appears when feature is toggled

---

## Notes

- Both features use UserDefaults to persist settings
- Settings are saved immediately when toggled
- The menu items reflect the current state on app launch
- Launch at Login requires the app to be properly code-signed
- For best results, place SnapSim.app in `/Applications` folder
