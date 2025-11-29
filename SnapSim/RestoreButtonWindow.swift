//
//  RestoreButtonWindow.swift
//  SnapSim
//
//  Created by Emre Değirmenci on 29.11.2025.
//

import Cocoa

class RestoreButtonWindow: NSWindow {
    private var onClickAction: (() -> Void)?
    
    init(onClick: @escaping () -> Void) {
        self.onClickAction = onClick
        
        // Create a rounded square window
        let frame = NSRect(x: 0, y: 0, width: 55, height: 75)
        
        super.init(
            contentRect: frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        // Configure window properties
        self.isOpaque = false
        self.backgroundColor = .clear
        self.level = .floating  // Always on top
        self.collectionBehavior = [.canJoinAllSpaces, .stationary]
        self.hasShadow = true
        self.isMovable = false
        self.ignoresMouseEvents = false
        
        // Create the button view
        let buttonView = RestoreButtonView(frame: frame)
        buttonView.onClick = { [weak self] in
            self?.onClickAction?()
        }
        
        self.contentView = buttonView
    }
}

