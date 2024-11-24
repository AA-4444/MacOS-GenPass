//
//  GenPassApp.swift
//  GenPass
//
//  Created by Алексей Зарицький on 11/24/24.
//

import SwiftUI

@main
struct SafePassApp: App {
    // Link AppDelegate to the app lifecycle
    @StateObject private var appDelegate = AppDelegate()

    var body: some Scene {
        WindowGroup {
            ContentView()  // Your main app UI
                .onAppear {
                    // Set up the menu bar when the app starts
                    appDelegate.setupMenuBar()
                }
        }
    }
}


