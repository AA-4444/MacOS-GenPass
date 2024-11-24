//
//  GenPassApp.swift
//  GenPass
//
//  Created by Алексей Зарицький on 11/24/24.
//
import SwiftUI
import Cocoa

@main
struct SafePassApp: App {
    @State private var passwordLength: Int = 16
    @State private var includeUppercase: Bool = true
    @State private var includeNumbers: Bool = true
    @State private var includeSpecialChars: Bool = true
    @State private var lastGeneratedPassword: String = ""

    var body: some Scene {
        MenuBarExtra("Password Generator", systemImage: "key.fill") {
            VStack {
                //-- Generate password button
                Button("Generate Password") {
                    generatePassword()
                }
                .keyboardShortcut("G")

                //-- Copy password button
                Button("Copy Password: \(lastGeneratedPassword.isEmpty ? "None" : lastGeneratedPassword)") {
                    copyPasswordToClipboard()
                }
                .disabled(lastGeneratedPassword.isEmpty)
                .keyboardShortcut("C")

                Divider()

                //-- Settings section
                Text("Settings").font(.headline)

                //MARK:  Password length menu
                Menu("Password Length: \(passwordLength)") {
                    Button("10") { changePasswordLength(to: 20) }
                    Button("16") { changePasswordLength(to: 16) }
                    Button("20") { changePasswordLength(to: 20) }
                    Button("25") { changePasswordLength(to: 20) }
                }

               
                Toggle("Include Uppercase", isOn: $includeUppercase)
                Toggle("Include Numbers", isOn: $includeNumbers)
                Toggle("Include Special Characters", isOn: $includeSpecialChars)

                Divider()

               
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding()
        }
    }

    //MARK: Gen random pass
    func generatePassword() {
        lastGeneratedPassword = generateRandomPassword()
    }

    //MARK: Gen pass based on user selection
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

    //--  pass length
    func changePasswordLength(to newLength: Int) {
        passwordLength = newLength
    }

    // Cp pass
    func copyPasswordToClipboard() {
        if !lastGeneratedPassword.isEmpty {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(lastGeneratedPassword, forType: .string)
            print("Password copied to clipboard: \(lastGeneratedPassword)")
        } else {
            print("No password to copy")
        }
    }
}
