//
//  main.swift
//  SnapSim
//
//  Created by Emre Değirmenci on 29.11.2025.
//

import Cocoa

// Create the application
let app = NSApplication.shared

// Create and set the delegate
let delegate = AppDelegate()
app.delegate = delegate

// Run the application
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

