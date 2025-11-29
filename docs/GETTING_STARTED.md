# Getting Started with SnapSim

## For Users

### Installation

1. Download `SnapSim.zip` from the [latest release](https://github.com/emrdgrmnci/SnapSim/releases)
2. Unzip and move `SnapSim.app` to your `/Applications` folder
3. Double-click to open SnapSim
4. Grant Accessibility permissions when prompted
5. Look for the iPhone icon (📱) in your menu bar

### First Use

1. Open iOS Simulator (from Xcode or directly)
2. Press `⌘]` to hide the simulator
3. A floating button appears at the bottom-left
4. Click the button or press `⌘]` again to restore

### Troubleshooting

#### App doesn't appear in menu bar
- Make sure you granted Accessibility permissions
- Try restarting SnapSim

#### Simulator doesn't hide
- Go to **System Settings** > **Privacy & Security** > **Accessibility**
- Remove SnapSim from the list
- Add it again by clicking the '+' button
- Restart SnapSim

#### Keyboard shortcut doesn't work
- Make sure SnapSim is running (check menu bar)
- Verify Accessibility permissions are granted
- Try clicking the simulator window first, then press `⌘]`

## For Developers

### Project Structure

```
SnapSim/
├── SnapSim/
│   ├── AppDelegate.swift          # Main app logic
│   ├── main.swift                 # App entry point
│   ├── SimulatorWindow.swift      # Simulator window model
│   ├── RestoreButtonWindow.swift  # Floating button window
│   └── RestoreButtonView.swift    # Button view with chevron
├── docs/                          # Documentation
├── README.md                      # Main documentation
├── LICENSE                        # MIT License
└── CHANGELOG.md                   # Version history
```

### Key Components

- **AppDelegate** - Manages app lifecycle, hotkeys, window manipulation
- **RestoreButtonWindow** - Floating borderless window
- **RestoreButtonView** - Custom NSView with chevron drawing
- **SimulatorWindow** - Model representing simulator window data

### Building

```bash
# Clone
git clone https://github.com/emrdgrmnci/SnapSim.git
cd SnapSim

# Open in Xcode
open SnapSim.xcodeproj

# Build (⌘B) and Run (⌘R)
```

### Testing

1. Run the app in Xcode
2. Open iOS Simulator
3. Test hide/show with `⌘]`
4. Test with different simulator sizes
5. Test button click to restore

### Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## FAQ

**Q: Does it work with multiple simulators?**  
A: Currently, it works with one simulator at a time. Multi-simulator support is planned.

**Q: Can I change the keyboard shortcut?**  
A: Not yet, but this is a planned feature.

**Q: Does it work with physical iOS devices?**  
A: No, it only works with the iOS Simulator app.

**Q: Is my data safe?**  
A: SnapSim only moves the simulator window. It doesn't access or modify any simulator data.

**Q: Does it work on Apple Silicon (M1/M2/M3)?**  
A: Yes! It's a universal binary that works on both Intel and Apple Silicon.

