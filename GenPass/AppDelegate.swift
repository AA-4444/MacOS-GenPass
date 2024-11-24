//
//  AppDelegate.swift
//  GenPass
//
//  Created by Алексей Зарицький on 11/24/24.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var statusBarItem: NSStatusItem!
    var lastGeneratedPassword: String = ""
    var copyPasswordItem: NSMenuItem!

//MARK: Setup menu bar ...
    func setupMenuBar() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusBarItem.button {
            // Icon that show up in menu bar
            button.image = NSImage(systemSymbolName: "key.fill", accessibilityDescription: "Password Generator")
        }
        
        let menu = NSMenu()

        // Gen pass
        let generateItem = NSMenuItem(title: "Generate Password", action: #selector(generatePassword), keyEquivalent: "G")
        generateItem.target = self
        menu.addItem(generateItem)

        // Method of copy generated pass
        copyPasswordItem = NSMenuItem(title: "Copy Password", action: #selector(copyPasswordToClipboard), keyEquivalent: "C")
        copyPasswordItem.isEnabled = false  // enable,whe pass is empty
        copyPasswordItem.target = self
        menu.addItem(copyPasswordItem)

        // Quit app button
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        
        statusBarItem.menu = menu
    }

    // Gen Pass function
    @objc func generatePassword() {
        lastGeneratedPassword = generateRandomPassword(length: 16)  // Генерируем пароль
        print("Generated password: \(lastGeneratedPassword)")  // Выводим пароль в консоль

        // update point
        copyPasswordItem.title = "Copy Password: \(lastGeneratedPassword)"
        copyPasswordItem.isEnabled = true
    }

    // function for copying paas
    @objc func copyPasswordToClipboard() {
        if !lastGeneratedPassword.isEmpty {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(lastGeneratedPassword, forType: .string)
            print("Password copied to clipboard: \(lastGeneratedPassword)")  // Выводим сообщение в консоль
        }
    }

    // quit function
    @objc func quitApp() {
        // quit app and removing icon form menu bar
        NSApplication.shared.terminate(nil)
    }

    // help function for generating random pass
    func generateRandomPassword(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
        var password = ""
        
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<characters.count)
            let char = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            password.append(char)
        }
        
        return password
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        
        NSApp.setActivationPolicy(.regular)

       
        setupMenuBar()

        
     //   let window = NSWindow(contentViewController: NSHostingController(rootView: ContentView()))
    //    window.makeKeyAndOrderFront(nil)
    }

    
    func applicationWillTerminate(_ notification: Notification) {
        statusBarItem = nil
    }
}
