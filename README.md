# SnapSim 📱

> A lightweight macOS menu bar app to quickly hide and restore iOS Simulator windows with a keyboard shortcut.

![SnapSim Demo](docs/snapsim-rec.mov)

## ✨ Features

- 🎯 **Quick Toggle** - Hide/show simulator with `⌘]` keyboard shortcut
- 🎨 **Clean UI** - Minimal floating button appears when simulator is hidden
- 🚀 **Fast & Lightweight** - Native macOS app with zero dependencies
- 📐 **Works with Any Size** - Supports all simulator sizes (iPhone, iPad, Apple Watch)
- 🔄 **Auto-Center** - Restores simulator to center of screen
- 🌙 **Menu Bar Integration** - Lives quietly in your menu bar

## 🎬 How It Works

1. **Hide Simulator** - Press `⌘]` to snap simulator to bottom-left corner (mostly hidden)
2. **Floating Button Appears** - A clean white button shows at the bottom-left
3. **Restore Simulator** - Click the button or press `⌘]` again to restore and center

Perfect for recording demos, screenshots, or just decluttering your workspace!

## 📦 Installation

### Option 1: Download Pre-built App (Recommended)

1. Download the latest release from [Releases](https://github.com/emrdgrmnci/SnapSim/releases)
2. Unzip and move `SnapSim.app` to your `/Applications` folder
3. Open `SnapSim` from Applications
4. Grant **Accessibility permissions** when prompted:
   - Go to **System Settings** > **Privacy & Security** > **Accessibility**
   - Enable **SnapSim**

### Option 2: Build from Source

```bash
# Clone the repository
git clone https://github.com/emrdgrmnci/SnapSim.git
cd SnapSim

# Open in Xcode
open SnapSim.xcodeproj

# Build and run (⌘R)
```

**Requirements:**
- macOS 11.0 or later
- Xcode 13.0 or later

## 🚀 Usage

### Keyboard Shortcut

- **`⌘]`** - Toggle simulator visibility

### Menu Bar

Click the iPhone icon (📱) in your menu bar for:
- Hide/Show Simulator
- Check Permissions
- About
- Quit

## ⚙️ Permissions

SnapSim requires **Accessibility permissions** to control the Simulator window.

**To grant permissions:**

1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. Click the **`+`** button
3. Navigate to `/Applications/SnapSim.app`
4. Enable the toggle for SnapSim

> **Note:** If SnapSim is already in the list but not working, try removing and re-adding it.

## 🛠 Tech Stack

- **Swift** - 100% native Swift code
- **AppKit** - Native macOS UI
- **Accessibility API** - Window manipulation
- **No dependencies** - Zero third-party libraries

## 🗺️ Roadmap

- [ ] Customizable keyboard shortcuts
- [ ] Multiple hide positions (corners)
- [ ] Support for multiple simulators
- [ ] Hide animation
- [ ] Configurable button appearance
- [ ] Auto-start on login option

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Emre Değirmenci**

- GitHub: [@emrdgrmnci](https://github.com/emrdgrmnci)

## ⭐️ Show Your Support

If you find SnapSim useful, please consider giving it a star on GitHub!

Made with ❤️ for iOS developers who love a clean workspace

