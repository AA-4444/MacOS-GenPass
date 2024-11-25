//
//  Untitled.swift
//  GenPass
//
//  Created by Oleksii Zarytskyi on 11/25/24.
//
import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!

    static let sharedAppState = AppState()

    func applicationDidFinishLaunching(_ notification: Notification) {
      
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = NSImage(systemSymbolName: "key.fill", accessibilityDescription: "Password Generator")
        statusItem.button?.action = #selector(togglePopover)

        
        popover = NSPopover()
        popover.contentViewController = NSHostingController(rootView: GenPassView(appState: AppDelegate.sharedAppState))
        popover.behavior = .transient
    }
  

    


    @objc func togglePopover() {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.close()
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}
