//
//  AppDelegate.swift
//  GenPass
//
//  Created by Oleksii Zarytskyi on 11/24/24.
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

        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusBarItem.menu = menu
    }

    
    func createMacOSToggle(title: String, state: Bool) -> NSMenuItem {
        let toggleItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        
        
        let button = NSButton(checkboxWithTitle: title, target: self, action: #selector(toggleSwitch))
        button.state = state ? .on : .off
        button.isBordered = false
        button.font = .systemFont(ofSize: 13)
        
        
        button.setButtonType(.switch)
        
      
        button.sizeToFit()
        
        toggleItem.view = button
        return toggleItem
    }

   
    @objc func toggleSwitch(sender: NSButton) {
        if sender.title == "Include Uppercase" {
            includeUppercase.toggle()
        } else if sender.title == "Include Numbers" {
            includeNumbers.toggle()
        } else if sender.title == "Include Special Characters" {
            includeSpecialChars.toggle()
        }
        updateMenuItemTitles()
    }

    
    @objc func changePasswordLength() {
        passwordLength = (passwordLength == 16) ? 20 : 16
        updateMenuItemTitles()
    }

   
    @objc func generatePassword() {
        lastGeneratedPassword = generateRandomPassword()
        copyPasswordItem.title = "Copy Password: \(lastGeneratedPassword)"
        copyPasswordItem.isEnabled = true
    }

    
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

   
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    
    func updateMenuItemTitles() {
        guard let menu = statusBarItem.menu else { return }
        
       
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
        setupMenuBar() 
    }

    func applicationWillTerminate(_ notification: Notification) {
        statusBarItem = nil
    }
}
