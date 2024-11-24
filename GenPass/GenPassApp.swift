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
    @State private var passwordHistory: [String] = [] // Store real password history

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

                //-- Password History Section
                Text("Password History").font(.headline)

                if passwordHistory.isEmpty {
                    Text("No history yet").font(.subheadline).foregroundColor(.gray)
                } else {
                    VStack(spacing: 1) {
                        ForEach(passwordHistory, id: \.self) { password in
                            HStack {
                                Text(password)
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                                    .font(.body)
                                Spacer()
                                Button("Copy") {
                                    copyToClipboard(password)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                Button("Remove") {
                                    removePasswordFromHistory(password)
                                }
                                .foregroundColor(.red)
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                }

                // Clear all history
                if !passwordHistory.isEmpty {
                    Button("Clear All History") {
                        clearAllHistory()
                    }
                    .foregroundColor(.red)
                    .padding(.top, 5)
                }

                Divider()

                //-- Settings Section
                Text("Settings").font(.headline)

                Menu("Password Length: \(passwordLength)") {
                    Button("10") { changePasswordLength(to: 10) }
                    Button("16") { changePasswordLength(to: 16) }
                    Button("20") { changePasswordLength(to: 20) }
                    Button("25") { changePasswordLength(to: 25) }
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

    // MARK: Generate Password and add the new pass to history
    func generatePassword() {
        lastGeneratedPassword = generateRandomPassword()

      
        if !lastGeneratedPassword.isEmpty {
            passwordHistory.insert(lastGeneratedPassword, at: 0)
            if passwordHistory.count > 5 {
                passwordHistory.removeLast()
            }
        }
    }

    // MARK: Gen random pass based on user selection
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

    // MARK: Change Pass Length --
    func changePasswordLength(to newLength: Int) {
        passwordLength = newLength
    }

    // MARK: Copy Last Generated Password
    func copyPasswordToClipboard() {
        if !lastGeneratedPassword.isEmpty {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(lastGeneratedPassword, forType: .string)
            print("Password copied to clipboard: \(lastGeneratedPassword)")
        } else {
            print("No password to copy")
        }
    }

    func copyToClipboard(_ password: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(password, forType: .string)
        print("Password copied to clipboard: \(password)")
    }

    // MARK: Remove a Specific Password from History
    func removePasswordFromHistory(_ password: String) {
        if let index = passwordHistory.firstIndex(of: password) {
            passwordHistory.remove(at: index)
        }
    }

    
    func clearAllHistory() {
        passwordHistory.removeAll()
    }
}
