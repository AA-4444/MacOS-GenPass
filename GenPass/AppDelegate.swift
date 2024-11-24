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
    @State private var isOn = false
    
    // User settings
    var passwordLength: Int = 16
    var includeUppercase: Bool = true
    var includeNumbers: Bool = true
    var includeSpecialChars: Bool = true

    // MARK: Setup menu bar
    func setupMenuBar() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusBarItem.button {
            // Icon in the menu bar
            button.image = NSImage(systemSymbolName: "key.fill", accessibilityDescription: "Password Generator")
        }
        
        let menu = NSMenu()

        // Generate password item
        let generateItem = NSMenuItem(title: "Generate Password", action: #selector(generatePassword), keyEquivalent: "G")
        generateItem.target = self
        menu.addItem(generateItem)
       

        // Copy password item
        copyPasswordItem = NSMenuItem(title: "Copy Password", action: #selector(copyPasswordToClipboard), keyEquivalent: "C")
        copyPasswordItem.isEnabled = false  // Initially disabled
        copyPasswordItem.target = self
        menu.addItem(copyPasswordItem)

        // Settings section (password length and options)
        let settingsTitle = NSMenuItem(title: "Settings", action: nil, keyEquivalent: "")
        settingsTitle.isEnabled = false // Make header unclickable
        menu.addItem(settingsTitle)

        // Password Length Menu Item
        let lengthItem = NSMenuItem(title: "Password Length: \(passwordLength)", action: #selector(changePasswordLength), keyEquivalent: "")
        lengthItem.target = self
        menu.addItem(lengthItem)
        
        // Add Toggles for options on the right side of the last 3 settings
        let uppercaseItem = createMacOSToggle(title: "Include Uppercase", state: includeUppercase)
        uppercaseItem.target = self
        menu.addItem(uppercaseItem)

        let numbersItem = createMacOSToggle(title: "Include Numbers", state: includeNumbers)
        numbersItem.target = self
        menu.addItem(numbersItem)

        let specialCharsItem = createMacOSToggle(title: "Include Special Characters", state: includeSpecialChars)
        specialCharsItem.target = self
        menu.addItem(specialCharsItem)

        // Quit item
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusBarItem.menu = menu
    }

    // Create macOS-style toggle (iOS-like green switch)
    func createMacOSToggle(title: String, state: Bool) -> NSMenuItem {
        let toggleItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        
        // Create an NSButton (checkbox) for the toggle
        let button = NSButton(checkboxWithTitle: title, target: self, action: #selector(toggleSwitch))
        button.state = state ? .on : .off
        button.isBordered = false
        button.font = .systemFont(ofSize: 13)
        
        // Set the button type to 'switch' for a native toggle appearance
        button.setButtonType(.switch)  // This gives it the standard macOS toggle look
        
        // Remove tintColor customization, as it's not applicable for NSButton
        button.sizeToFit()  // Fit to text size
        
        toggleItem.view = button
        return toggleItem
    }

    // Handle toggling
    @objc func toggleSwitch(sender: NSButton) {
        if sender.title == "Include Uppercase" {
            includeUppercase.toggle()
        } else if sender.title == "Include Numbers" {
            includeNumbers.toggle()
        } else if sender.title == "Include Special Characters" {
            includeSpecialChars.toggle()
        }
        updateMenuItemTitles() // Update titles dynamically
    }

    // Change Password Length
    @objc func changePasswordLength() {
        passwordLength = (passwordLength == 16) ? 20 : 16 // Toggle between 16 and 20 for simplicity
        updateMenuItemTitles() // Update only the password length title
    }

    // Generate Password function
    @objc func generatePassword() {
        lastGeneratedPassword = generateRandomPassword()
        copyPasswordItem.title = "Copy Password: \(lastGeneratedPassword)"
        copyPasswordItem.isEnabled = true
    }

    // Generate random password based on user settings
    func generateRandomPassword() -> String {
        var characters = "abcdefghijklmnopqrstuvwxyz"
        
        if includeUppercase {
            characters += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }
        if includeNumbers {
            characters += "0123456789"
        }
        if includeSpecialChars {
            characters += "!@#$%^&*()"
        }
        
        var password = ""
        for _ in 0..<passwordLength {
            let randomIndex = Int.random(in: 0..<characters.count)
            let char = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            password.append(char)
        }
        
        return password
    }

    // Copy password to clipboard
    @objc func copyPasswordToClipboard() {
        if !lastGeneratedPassword.isEmpty {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(lastGeneratedPassword, forType: .string)
            print("Password copied to clipboard: \(lastGeneratedPassword)")
        }
    }

    // Quit app
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    // Update Menu Item Titles Dynamically (Only updates relevant titles)
    func updateMenuItemTitles() {
        guard let menu = statusBarItem.menu else { return }
        
        // Update the settings dynamically
        for item in menu.items {
            if item.title.contains("Password Length") {
                item.title = "Password Length: \(passwordLength)"
            } else if item.title.contains("Include Uppercase") {
                item.title = "Include Uppercase: \(includeUppercase ? "Yes" : "No")"
            } else if item.title.contains("Include Numbers") {
                item.title = "Include Numbers: \(includeNumbers ? "Yes" : "No")"
            } else if item.title.contains("Include Special Characters") {
                item.title = "Include Special Characters: \(includeSpecialChars ? "Yes" : "No")"
            }
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        setupMenuBar() // Set up the menu bar initially
    }

    func applicationWillTerminate(_ notification: Notification) {
        statusBarItem = nil
    }
}
