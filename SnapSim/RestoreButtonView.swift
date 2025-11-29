//
//  RestoreButtonView.swift
//  SnapSim
//
//  Created by Emre Değirmenci on 29.11.2025.
//

import Cocoa

class RestoreButtonView: NSView {
    var onClick: (() -> Void)?
    private var isHovered = false
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        // Add tracking area for hover effects
        let trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(trackingArea)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Draw rounded square background
        let rect = bounds.insetBy(dx: 1, dy: 1)
        let cornerRadius: CGFloat = 12  // Rounded corners
        let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
        
        // Background color - clean white, slightly darker on hover
        let bgColor = isHovered ? NSColor(white: 0.90, alpha: 1.0) : NSColor(white: 0.97, alpha: 1.0)
        bgColor.setFill()
        path.fill()
        
        // Subtle border
        NSColor(white: 0.80, alpha: 0.6).setStroke()
        path.lineWidth = 0.5
        path.stroke()
        
        // Draw chevron (up arrow) - centered
        let arrowPath = NSBezierPath()
        let centerX = bounds.midX
        let centerY = bounds.midY
        let arrowWidth: CGFloat = 16   // Width of chevron
        let arrowHeight: CGFloat = 8   // Height of chevron
        
        // Draw chevron pointing up: ∧
        arrowPath.move(to: NSPoint(x: centerX - arrowWidth/2, y: centerY - arrowHeight/2))
        arrowPath.line(to: NSPoint(x: centerX, y: centerY + arrowHeight/2))
        arrowPath.line(to: NSPoint(x: centerX + arrowWidth/2, y: centerY - arrowHeight/2))
        
        // Black stroke for chevron
        NSColor(white: 0.1, alpha: 1.0).setStroke()
        arrowPath.lineWidth = 2.5
        arrowPath.lineCapStyle = .round
        arrowPath.lineJoinStyle = .round
        arrowPath.stroke()
    }
    
    override func mouseEntered(with event: NSEvent) {
        isHovered = true
        NSCursor.pointingHand.set()
        needsDisplay = true
    }
    
    override func mouseExited(with event: NSEvent) {
        isHovered = false
        NSCursor.arrow.set()
        needsDisplay = true
    }
    
    override func mouseDown(with event: NSEvent) {
        // Visual feedback - slight scale down effect
        alphaValue = 0.8
    }
    
    override func mouseUp(with event: NSEvent) {
        alphaValue = 1.0
        
        // Check if mouse is still inside
        let location = convert(event.locationInWindow, from: nil)
        if bounds.contains(location) {
            onClick?()
        }
    }
}

