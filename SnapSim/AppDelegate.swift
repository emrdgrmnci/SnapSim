//
//  AppDelegate.swift
//  SnapSim
//
//  Created by Emre Değirmenci on 29.11.2025.
//

import Cocoa
import Carbon
import ServiceManagement
import CoreServices

// Typealias to help with LSSharedFileList API bridging
typealias LSSharedFileListItemRef = Unmanaged<LSSharedFileListItem>

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var globalMonitor: Any?
    var localMonitor: Any?
    var hiddenSimulators: [Int32: CGRect] = [:] // Store original frames by PID
    var restoreButton: RestoreButtonWindow?  // Floating pill button
    var lastSimulatorWidth: CGFloat = 250  // Track simulator width for pill button
    var simulatorLaunchObserver: NSObjectProtocol?  // Observer for Simulator app launches
    var openOnSimulatorLaunchMenuItem: NSMenuItem?  // Menu item for "Open SnapSim when Simulator opens"
    var launchAtLoginMenuItem: NSMenuItem?  // Menu item for "Launch at Login"
    
    // UserDefaults keys
    private let openOnSimulatorLaunchKey = "openOnSimulatorLaunch"
    private let launchAtLoginKey = "launchAtLogin"
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("=== SnapSim Starting ===")
        
        // Create menu bar item
        setupStatusItem()
            
        // Setup menu
        setupMenu()
        
        // Check and request accessibility permissions
        checkAccessibilityPermissions()
        
        // Setup global hotkey monitor - Using Cmd+]
        setupHotkeyMonitor()
        
        // Create the restore button (hidden initially)
        createRestoreButton()
        
        // Setup Simulator launch monitoring
        setupSimulatorLaunchMonitoring()
        
        // Setup Launch at Login
        setupLaunchAtLogin()
        
        NSLog("=== SnapSim launched successfully! ===")
    }
    
    func setupStatusItem() {
        NSLog("Creating status item...")
        
        // Create a status item with variable length to accommodate both icon and potential text
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusItem = statusItem else {
            NSLog("✗ Failed to create status item!")
            return
        }
        
        NSLog("✓ Status item created: %@", String(describing: statusItem))
        
        guard let button = statusItem.button else {
            NSLog("✗ Status item has no button!")
            return
        }
        
        NSLog("✓ Button obtained: %@", String(describing: button))
        
        // Try SF Symbol first (available on macOS 11+)
        if #available(macOS 11.0, *) {
            if let image = NSImage(systemSymbolName: "iphone", accessibilityDescription: "SnapSim") {
                image.isTemplate = true  // Makes it adapt to dark/light menu bar
                button.image = image
                NSLog("✓ Set SF Symbol 'iphone' as icon")
            } else {
                NSLog("⚠ SF Symbol 'iphone' returned nil, using text")
                button.title = "📱"
            }
        } else {
            // Fallback for older macOS
            NSLog("⚠ macOS < 11, using text fallback")
            button.title = "📱"
        }
        
        button.toolTip = "SnapSim - Press ⌘] to hide/show Simulator"
        NSLog("✓ Status bar button configured, title: %@, image: %@", 
              button.title, 
              String(describing: button.image))
    }
    
    func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Accessibility Permission Required",
                    message: """
                    Please grant accessibility permissions:
                    
                    1. Open System Settings > Privacy & Security > Accessibility
                    2. Click the '+' button
                    3. Navigate to and select SnapSim.app
                    4. Enable the toggle for SnapSim
                    5. Restart SnapSim
                    
                    Note: If SnapSim is already in the list, try removing it and adding it again.
                    """
                )
            }
        } else {
            print("✓ Accessibility permissions granted!")
        }
    }
    
    func setupMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Hide/Show Simulator (⌘])",
                               action: #selector(toggleSimulator),
                               keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        // Open SnapSim when Simulator opens
        openOnSimulatorLaunchMenuItem = NSMenuItem(title: "Open SnapSim when Simulator opens",
                                                   action: #selector(toggleOpenOnSimulatorLaunch),
                                                   keyEquivalent: "")
        openOnSimulatorLaunchMenuItem?.target = self
        openOnSimulatorLaunchMenuItem?.state = isOpenOnSimulatorLaunchEnabled() ? .on : .off
        menu.addItem(openOnSimulatorLaunchMenuItem!)
        
        // Launch at Login
        launchAtLoginMenuItem = NSMenuItem(title: "Launch at Login",
                                           action: #selector(toggleLaunchAtLogin),
                                           keyEquivalent: "")
        launchAtLoginMenuItem?.target = self
        launchAtLoginMenuItem?.state = isLaunchAtLoginEnabled() ? .on : .off
        menu.addItem(launchAtLoginMenuItem!)
        
        menu.addItem(NSMenuItem.separator())
        
        let permissionItem = NSMenuItem(title: "Check Permissions",
                                        action: #selector(checkPermissions),
                                        keyEquivalent: "")
        menu.addItem(permissionItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "About SnapSim",
                               action: #selector(showAbout),
                               keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit SnapSim",
                               action: #selector(NSApplication.terminate(_:)),
                               keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    func setupHotkeyMonitor() {
        // Use global monitor for events when app is not focused
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            // Check for Cmd+] (right bracket) - keyCode 30
            if event.modifierFlags.contains(.command) && event.keyCode == 30 {
                DispatchQueue.main.async {
                    self?.toggleSimulator()
                }
            }
        }
        
        // Also add local monitor for when app is focused
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.modifierFlags.contains(.command) && event.keyCode == 30 {
                DispatchQueue.main.async {
                    self?.toggleSimulator()
                }
                return nil // Consume the event
            }
            return event
        }
        
        print("✓ Hotkey monitor setup (⌘])")
    }
    
    func createRestoreButton() {
        // Create the floating pill button (hidden initially)
            restoreButton = RestoreButtonWindow { [weak self] in
            self?.restoreFromButton()
        }
        print("✓ Restore button created")
    }

    func showRestoreButton() {
        guard NSScreen.main != nil else { return }
        
        // Small rounded square button at bottom-left
        let buttonWidth: CGFloat = 55
        let buttonHeight: CGFloat = 75
        let paddingX: CGFloat = 50
        let paddingY: CGFloat = 0
        
        let frame = NSRect(
            x: paddingX,
            y: paddingY,
            width: buttonWidth,
            height: buttonHeight
        )
        
        restoreButton?.setFrame(frame, display: true)
        restoreButton?.orderFront(nil)
        print("📍 Restore button shown")
    }
    
    func hideRestoreButton() {
        restoreButton?.orderOut(nil)
        print("📍 Restore button hidden")
    }
    
    @objc func restoreFromButton() {
        // Find and restore the first hidden simulator
        guard let (pid, originalFrame) = hiddenSimulators.first else {
            print("No hidden simulators to restore")
            return
        }
        
        print("🔄 Restoring simulator PID \(pid) via button click")
        
        // Calculate center position on screen
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.frame
        let centerX = (screenFrame.width - originalFrame.width) / 2
        let centerY = (screenFrame.height - originalFrame.height) / 2
        
        if moveWindowUsingAccessibility(pid: pid, toX: centerX, toY: centerY) {
            hiddenSimulators.removeValue(forKey: pid)
            hideRestoreButton()
            
            // Bring Simulator app to front
            bringSimulatorToFront()
            
            showNotification(title: "Simulator Restored", message: "Restored and brought to front")
        }
    }
    
    func bringSimulatorToFront() {
        // Find and activate the Simulator app
        let runningApps = NSWorkspace.shared.runningApplications
        if let simulatorApp = runningApps.first(where: { $0.localizedName == "Simulator" }) {
            // Use activate() for modern macOS
            simulatorApp.activate()
            print("✓ Simulator app brought to front")
        } else {
            print("⚠ Could not find Simulator app to activate")
        }
    }
    
    @objc func checkPermissions() {
        let isTrusted = AXIsProcessTrusted()
        
        if isTrusted {
            showAlert(title: "Permissions OK ✓", message: "SnapSim has accessibility permissions.")
        } else {
            let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
            _ = AXIsProcessTrustedWithOptions(options)
            
            showAlert(
                title: "Permissions Required",
                message: "Please grant accessibility permissions in System Settings > Privacy & Security > Accessibility"
            )
        }
    }
    
    @objc func toggleSimulator() {
        print("\n========== Toggle simulator called ==========")
        
        // First check if we have permissions
        guard AXIsProcessTrusted() else {
            print("✗ Accessibility not trusted!")
            showNotification(title: "Permission Required", message: "Please grant Accessibility permissions")
            checkAccessibilityPermissions()
            return
        }
        
        print("✓ Accessibility trusted")
        
        guard let simulator = findSimulatorWindow() else {
            print("✗ No Simulator window found")
            showNotification(title: "No Simulator Found", message: "Please open iOS Simulator first")
            return
        }
        
        print("✓ Found simulator: PID \(simulator.pid), Frame: \(simulator.frame)")
        
        let pid = simulator.pid
        
        // Check if already hidden
        if let originalFrame = hiddenSimulators[pid] {
            // Restore to center of screen and bring to front
            print("→ Restoring simulator to center")
            
            guard let screen = NSScreen.main else { return }
            let screenFrame = screen.frame
            let centerX = (screenFrame.width - originalFrame.width) / 2
            let centerY = (screenFrame.height - originalFrame.height) / 2
            
            if moveWindowUsingAccessibility(pid: pid, toX: centerX, toY: centerY) {
                hiddenSimulators.removeValue(forKey: pid)
                hideRestoreButton()  // Hide the floating button
                bringSimulatorToFront()  // Bring to front
                showNotification(title: "Simulator Restored", message: "Simulator centered and brought to front")
            } else {
                showNotification(title: "Error", message: "Failed to restore simulator position")
            }
        } else {
            // Hide to bottom-left corner
            print("→ Hiding to bottom-left corner")
            if hideWindowToCorner(simulator) {
                showNotification(title: "Simulator Hidden", message: "Simulator snapped to bottom-left corner")
            } else {
                showNotification(title: "Error", message: "Failed to hide simulator")
            }
        }
    }
    
    @objc func showAbout() {
        // Bring app to front for the alert
        NSApp.activate(ignoringOtherApps: true)
        
        let alert = NSAlert()
        alert.messageText = "SnapSim"
        alert.informativeText = """
        Hide iOS Simulator to the bottom-left corner with ⌘]
        
        Press ⌘] again to restore the original position.
        
        Make sure Accessibility permissions are granted in:
        System Settings > Privacy & Security > Accessibility
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    func findSimulatorWindow() -> SimulatorWindow? {
        let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        guard let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
            print("✗ Failed to get window list")
            return nil
        }
        
        print("Searching through \(windowList.count) windows...")
        
        // Debug: Print all window owner names to find the simulator
        var foundOwners = Set<String>()
        for window in windowList {
            if let ownerName = window[kCGWindowOwnerName as String] as? String {
                if !foundOwners.contains(ownerName) {
                    foundOwners.insert(ownerName)
                    // Print owners that might be simulator-related
                    let lowerName = ownerName.lowercased()
                    if lowerName.contains("sim") || lowerName.contains("iphone") || lowerName.contains("ipad") || lowerName.contains("device") {
                        print("  📱 Found potential simulator app: '\(ownerName)'")
                    }
                }
            }
        }
        
        // Print all unique app names for debugging
        print("  All running apps with windows: \(foundOwners.sorted().joined(separator: ", "))")
        
        for window in windowList {
            if let ownerName = window[kCGWindowOwnerName as String] as? String,
               let bounds = window[kCGWindowBounds as String] as? [String: Any],
               let pid = window[kCGWindowOwnerPID as String] as? Int32,
               let windowNumber = window[kCGWindowNumber as String] as? Int32 {
                
                // Check for Simulator - try multiple possible names
                let isSimulator = ownerName == "Simulator" || 
                                  ownerName.contains("Simulator") ||
                                  ownerName == "iOS Simulator" ||
                                  ownerName == "Xcode Simulator"
                
                if isSimulator {
                    let layer = window[kCGWindowLayer as String] as? Int ?? 0
                    
                    // Parse bounds
                    let x = (bounds["X"] as? NSNumber)?.doubleValue ?? 0
                    let y = (bounds["Y"] as? NSNumber)?.doubleValue ?? 0
                    let width = (bounds["Width"] as? NSNumber)?.doubleValue ?? 0
                    let height = (bounds["Height"] as? NSNumber)?.doubleValue ?? 0
                    
                    print("  Found '\(ownerName)' window: layer=\(layer), size=\(width)x\(height)")
                    
                    // Simulator windows use layer 0-10 for main windows
                    // Accept very small simulator sizes (Apple Watch, small iPhone sizes)
                    if layer <= 10 && width > 50 && height > 100 {
                        print("✓ Found Simulator window #\(windowNumber): (\(x), \(y)) \(width)x\(height)")
                        
                        return SimulatorWindow(
                            pid: pid,
                            windowNumber: windowNumber,
                            frame: CGRect(x: x, y: y, width: width, height: height)
                        )
                    } else {
                        print("  → Skipped: width=\(width), height=\(height) (too small or wrong layer)")
                    }
                }
            }
        }
        return nil
    }
    
    func hideWindowToCorner(_ simulator: SimulatorWindow) -> Bool {
        // Store original frame (in CGWindow/screen coordinates - origin at top-left)
        hiddenSimulators[simulator.pid] = simulator.frame
        
        // Store simulator width for pill button sizing
        lastSimulatorWidth = simulator.frame.width
        
        // Get screen dimensions
        guard let screen = NSScreen.main else {
            print("✗ Could not get main screen")
            return false
        }
        
        // Move simulator mostly off-screen to bottom-left corner
        // Show just a small portion visible
        let visibleWidth: CGFloat = 50
        let newX = -simulator.frame.width + visibleWidth
        
        let screenHeight = screen.frame.height
        let newY = screenHeight - 80  // Just bottom portion visible
        
        print("Screen: \(screen.frame)")
        print("Hiding simulator to bottom-left: x=\(newX), y=\(newY)")
        
        let success = moveWindowUsingAccessibility(pid: simulator.pid, toX: newX, toY: newY)
        
        if success {
            // Show the floating restore button
            showRestoreButton()
        }
        
        return success
    }
    
    func restoreWindow(pid: Int32, to frame: CGRect) -> Bool {
        print("Restoring window to: \(frame)")
        return moveWindowUsingAccessibility(pid: pid, toX: frame.origin.x, toY: frame.origin.y)
    }
    
    func moveWindowUsingAccessibility(pid: Int32, toX x: CGFloat, toY y: CGFloat) -> Bool {
        print("Moving window for PID \(pid) to x:\(x), y:\(y)")
        
        // Create AXUIElement for the application
        let app = AXUIElementCreateApplication(pid)
        
        // Get the windows attribute
        var windowsRef: CFTypeRef?
        let windowsResult = AXUIElementCopyAttributeValue(app, kAXWindowsAttribute as CFString, &windowsRef)
        
        guard windowsResult == .success else {
            print("✗ Failed to get windows attribute")
            printAXError(windowsResult)
            return false
        }
        
        guard let windows = windowsRef as? [AXUIElement], !windows.isEmpty else {
            print("✗ No windows found or windows is not an array")
            return false
        }
        
        print("✓ Found \(windows.count) AXWindow(s)")
        
        // Find the main window (the one with a title that looks like a device name)
        var targetWindow: AXUIElement?
        
        for window in windows {
            var titleRef: CFTypeRef?
            if AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleRef) == .success,
               let title = titleRef as? String {
                print("  Window title: '\(title)'")
                // Simulator windows have titles like "iPhone 15 Pro" or "iPad Pro"
                if title.contains("iPhone") || title.contains("iPad") || title.contains("Apple") {
                    targetWindow = window
                    break
                }
            }
        }
        
        // If no titled window found, use the first one
        let window = targetWindow ?? windows[0]
        
        // Set the position using Accessibility API
        // AX coordinates: origin at top-left of primary display, y increases downward
        var position = CGPoint(x: x, y: y)
        
        print("Setting AX position to: \(position)")
        
        guard let positionValue = AXValueCreate(.cgPoint, &position) else {
            print("✗ Failed to create AXValue for position")
            return false
        }
        
        let setResult = AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, positionValue)
        
        if setResult == .success {
            print("✓ Window moved successfully!")
            return true
        } else {
            print("✗ Failed to set position")
            printAXError(setResult)
            return false
        }
    }
    
    func printAXError(_ error: AXError) {
        let errorMessages: [AXError: String] = [
            .success: "Success",
            .failure: "General failure",
            .illegalArgument: "Illegal argument",
            .invalidUIElement: "Invalid UI element",
            .invalidUIElementObserver: "Invalid UI element observer",
            .cannotComplete: "Cannot complete (often permission issue or window issue)",
            .attributeUnsupported: "Attribute unsupported",
            .actionUnsupported: "Action unsupported",
            .notificationUnsupported: "Notification unsupported",
            .notImplemented: "Not implemented",
            .notificationAlreadyRegistered: "Notification already registered",
            .notificationNotRegistered: "Notification not registered",
            .apiDisabled: "API disabled - Accessibility not enabled in System Settings",
            .noValue: "No value",
            .parameterizedAttributeUnsupported: "Parameterized attribute unsupported",
            .notEnoughPrecision: "Not enough precision"
        ]
        
        if let message = errorMessages[error] {
            print("  AXError (\(error.rawValue)): \(message)")
        } else {
            print("  Unknown AXError: \(error.rawValue)")
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    func showNotification(title: String, message: String) {
        // Visual feedback through menu bar icon
        DispatchQueue.main.async {
            if let button = self.statusItem?.button {
                // Flash the icon
                let originalImage = button.image
                button.image = NSImage(systemSymbolName: "iphone.circle.fill", accessibilityDescription: title)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    button.image = originalImage
                }
                
                // Update tooltip
                button.toolTip = "\(title): \(message)"
            }
            
            // Print to console
            print("📱 \(title): \(message)")
        }
    }
    
    // MARK: - Simulator Launch Monitoring
    
    func setupSimulatorLaunchMonitoring() {
        // Check if feature is enabled
        guard isOpenOnSimulatorLaunchEnabled() else {
            print("Open on Simulator launch is disabled")
            return
        }
        
        // Observe NSWorkspace notifications for app launches
        let notificationCenter = NSWorkspace.shared.notificationCenter
        simulatorLaunchObserver = notificationCenter.addObserver(
            forName: NSWorkspace.didLaunchApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleApplicationLaunch(notification)
        }
        
        print("✓ Simulator launch monitoring enabled")
    }
    
    func handleApplicationLaunch(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }
        
        // Check if the launched app is Simulator
        let appName = app.localizedName ?? ""
        let bundleIdentifier = app.bundleIdentifier ?? ""
        
        // Simulator can be identified by name or bundle ID
        let isSimulator = appName == "Simulator" ||
                         appName.contains("Simulator") ||
                         bundleIdentifier.contains("com.apple.iphonesimulator") ||
                         bundleIdentifier == "com.apple.iphonesimulator"
        
        if isSimulator {
            print("📱 Simulator app launched - activating SnapSim")
            // Activate SnapSim app
            NSApp.activate(ignoringOtherApps: true)
            showNotification(title: "Simulator Detected", message: "SnapSim is ready")
        }
    }
    
    @objc func toggleOpenOnSimulatorLaunch() {
        let currentState = isOpenOnSimulatorLaunchEnabled()
        let newState = !currentState
        
        UserDefaults.standard.set(newState, forKey: openOnSimulatorLaunchKey)
        openOnSimulatorLaunchMenuItem?.state = newState ? .on : .off
        
        if newState {
            setupSimulatorLaunchMonitoring()
            showNotification(title: "Feature Enabled", message: "SnapSim will open when Simulator launches")
        } else {
            // Remove observer
            if let observer = simulatorLaunchObserver {
                NSWorkspace.shared.notificationCenter.removeObserver(observer)
                simulatorLaunchObserver = nil
            }
            showNotification(title: "Feature Disabled", message: "SnapSim will not auto-open")
        }
    }
    
    func isOpenOnSimulatorLaunchEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: openOnSimulatorLaunchKey)
    }
    
    // MARK: - Launch at Login
    
    func setupLaunchAtLogin() {
        // Update menu item state based on current setting
        let isEnabled = isLaunchAtLoginEnabled()
        launchAtLoginMenuItem?.state = isEnabled ? .on : .off
        
        // Apply the setting (silently, don't show errors on startup)
        _ = setLaunchAtLogin(isEnabled)
    }
    
    @objc func toggleLaunchAtLogin() {
        let currentState = isLaunchAtLoginEnabled()
        let newState = !currentState
        
        UserDefaults.standard.set(newState, forKey: launchAtLoginKey)
        launchAtLoginMenuItem?.state = newState ? .on : .off
        
        let success = setLaunchAtLogin(newState)
        
        if success {
            showNotification(
                title: newState ? "Launch at Login Enabled" : "Launch at Login Disabled",
                message: newState ? "SnapSim will start automatically" : "SnapSim will not start automatically"
            )
        } else {
            showNotification(
                title: "Error",
                message: "Failed to update Launch at Login setting"
            )
        }
    }
    
    func isLaunchAtLoginEnabled() -> Bool {
        // Check UserDefaults first
        if UserDefaults.standard.object(forKey: launchAtLoginKey) != nil {
            return UserDefaults.standard.bool(forKey: launchAtLoginKey)
        }
        
        // If not set in UserDefaults, check actual login items
        guard let appURL = Bundle.main.bundleURL as NSURL? else {
            return false
        }
        
        guard let loginItems = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeUnretainedValue(), nil)?.takeRetainedValue() else {
            return false
        }
        
        var seedValue: UInt32 = 0
        guard let itemsSnapshot = LSSharedFileListCopySnapshot(loginItems, &seedValue)?.takeRetainedValue() else {
            return false
        }
        
        let items = itemsSnapshot as! [LSSharedFileListItem]
        for itemRef in items {
            var error: Unmanaged<CFError>?
            if let itemURL = LSSharedFileListItemCopyResolvedURL(itemRef, 0, &error)?.takeRetainedValue() as NSURL?,
               itemURL.isEqual(appURL) {
                // Found in login items, update UserDefaults
                UserDefaults.standard.set(true, forKey: launchAtLoginKey)
                return true
            }
        }
        
        // Not found in login items, update UserDefaults
        UserDefaults.standard.set(false, forKey: launchAtLoginKey)
        return false
    }
    
    func setLaunchAtLogin(_ enabled: Bool) -> Bool {
        // Get the app's bundle URL
        guard let appURL = Bundle.main.bundleURL as NSURL? else {
            print("✗ Could not get app bundle URL")
            return false
        }
        
        // Use LSSharedFileList API (works with main app, no helper needed)
        // Note: This API is deprecated but still functional and is the simplest approach
        guard let loginItems = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeUnretainedValue(), nil)?.takeRetainedValue() else {
            print("✗ Failed to access login items list")
            return false
        }
        
        if enabled {
            // Check if already in login items to avoid duplicates
            var seedValue: UInt32 = 0
            if let itemsSnapshot = LSSharedFileListCopySnapshot(loginItems, &seedValue)?.takeRetainedValue() {
                let items = itemsSnapshot as! [LSSharedFileListItem]
                for itemRef in items {
                    var error: Unmanaged<CFError>?
                    if let itemURL = LSSharedFileListItemCopyResolvedURL(itemRef, 0, &error)?.takeRetainedValue() as NSURL?,
                       itemURL.isEqual(appURL) {
                        // Already in login items
                        print("✓ Already in login items")
                        return true
                    }
                }
            }
            
            // Add to login items
            // Get the last item from the list to insert after
            var seedValue2: UInt32 = 0
            var afterItem: LSSharedFileListItem? = nil
            
            if let itemsSnapshot = LSSharedFileListCopySnapshot(loginItems, &seedValue2)?.takeRetainedValue() {
                let items = itemsSnapshot as! [LSSharedFileListItem]
                afterItem = items.last
            }
            
            // Insert the item
            // Handle both cases: list with items and empty list
            // For empty list, we'll use a workaround to avoid kLSSharedFileListItemLast crash
            let result: LSSharedFileListItem?
            
            if let lastItem = afterItem {
                // Normal case: insert after the last item
                result = LSSharedFileListInsertItemURL(loginItems,
                                                      lastItem,
                                                      nil,
                                                      nil,
                                                      appURL,
                                                      nil,
                                                      nil)
            } else {
                // Empty list case: kLSSharedFileListItemLast causes EXC_BAD_ACCESS when unwrapped
                // Workaround: LSSharedFileListItem is actually OpaquePointer under the hood
                // We can extract the pointer from the Unmanaged constant and cast it
                let constantUnmanaged = kLSSharedFileListItemLast
                // Get the underlying pointer - this is safe because it's just extracting the pointer
                let constantPointer = constantUnmanaged.toOpaque()
                // LSSharedFileListItem is a typealias for OpaquePointer, so we can cast directly
                // Use unsafeBitCast to convert the pointer to LSSharedFileListItem type
                let constantItem = unsafeBitCast(constantPointer, to: LSSharedFileListItem.self)
                result = LSSharedFileListInsertItemURL(loginItems,
                                                      constantItem,
                                                      nil,
                                                      nil,
                                                      appURL,
                                                      nil,
                                                      nil)
            }
            if result != nil {
                print("✓ Launch at Login enabled")
                return true
            } else {
                print("✗ Failed to add to login items")
                return false
            }
        } else {
            // Remove from login items
            var seedValue: UInt32 = 0
            guard let itemsSnapshot = LSSharedFileListCopySnapshot(loginItems, &seedValue)?.takeRetainedValue() else {
                print("✗ Failed to get login items snapshot")
                return false
            }
            
            let items = itemsSnapshot as! [LSSharedFileListItem]
            for itemRef in items {
                var error: Unmanaged<CFError>?
                if let itemURL = LSSharedFileListItemCopyResolvedURL(itemRef, 0, &error)?.takeRetainedValue() as NSURL?,
                   itemURL.isEqual(appURL) {
                    let removeResult = LSSharedFileListItemRemove(loginItems, itemRef)
                    if removeResult == noErr {
                        print("✓ Launch at Login disabled")
                        return true
                    }
                }
            }
            print("⚠ Launch at Login item not found in list")
            return false
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Clean up event monitors
        if let monitor = globalMonitor {
            NSEvent.removeMonitor(monitor)
        }
        if let monitor = localMonitor {
            NSEvent.removeMonitor(monitor)
        }
        
        // Remove Simulator launch observer
        if let observer = simulatorLaunchObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
        }
        
        // Close restore button window
        restoreButton?.close()
    }
}
