
import SwiftUI
import AppKit
import Foundation

@main
struct SafePassApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}


class AppState: ObservableObject {
    @Published var passwordLength: Int = 16
    @Published var includeUppercase: Bool = true
    @Published var includeNumbers: Bool = true
    @Published var includeSpecialChars: Bool = true
    @Published var lastGeneratedPassword: String = ""
    @Published var passwordHistory: [String] = []
//--Test Categories
//    @Published var passwordCategories: [String: [String]] = [
//           "Work": [],
//           "Personal": [],
//           "Finance": [],
//           "Games" : []
//       ]
//       @Published var selectedCategory: String = "Work"

    func generatePassword() {
        let password = generateRandomNicePassword()
        lastGeneratedPassword = password

        if !password.isEmpty {
            passwordHistory.insert(password, at: 0)
            print("Generated Password: \(password)")
            print("Password History: \(passwordHistory)")

            if passwordHistory.count > 5 {
                passwordHistory.removeLast()
            }
        }
    }
    

    func generateRandomNicePassword() -> String {
        guard passwordLength > 0 else { return "" }
        
        var availableCharacters = "abcdefghijklmnopqrstuvwxyz"
        var mandatoryCharacters: [Character] = []
        
       
        var rng = SystemRandomNumberGenerator()
        
       
        if includeUppercase {
            let uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            availableCharacters += uppercase
            if let char = randomCharacter(from: uppercase, using: &rng) {
                mandatoryCharacters.append(char)
            }
        }
        
       
        if includeNumbers {
            let numbers = "0123456789"
            availableCharacters += numbers
            if let char = randomCharacter(from: numbers, using: &rng) {
                mandatoryCharacters.append(char)
            }
        }
        
       
        if includeSpecialChars {
            let specialCharacters = "!@#$%^&*()"
            availableCharacters += specialCharacters
            if let char = randomCharacter(from: specialCharacters, using: &rng) {
                mandatoryCharacters.append(char)
            }
        }
        
       
        var password = mandatoryCharacters
        while password.count < passwordLength {
            if let randomChar = randomCharacter(from: availableCharacters, using: &rng) {
                password.append(randomChar)
            }
        }
        
       
        password.shuffle(using: &rng)
        
        return String(password)
    }
    
    
    

   
    func randomCharacter(from string: String, using rng: inout SystemRandomNumberGenerator) -> Character? {
        guard !string.isEmpty else { return nil }
        let index = string.index(string.startIndex, offsetBy: Int.random(in: 0..<string.count, using: &rng))
        return string[index]
    }


    func copyPasswordToMyClipboard() {
        if !lastGeneratedPassword.isEmpty {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(lastGeneratedPassword, forType: .string)
        }
    }

    func copyToMyClipboard(_ password: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(password, forType: .string)
    }

    func removePasswordFromHistory(_ password: String) {
        if let index = passwordHistory.firstIndex(of: password) {
            passwordHistory.remove(at: index)
        }
    }

    func clearAllHistory() {
        passwordHistory.removeAll()
    }
}


struct GenPassView: View {
    @ObservedObject var appState: AppState
    @State private var isPressed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            //-- Gen Password Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Password Generator")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 5) {
                    Button("Generate Password") {
                        appState.generatePassword()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button(action: {
                        appState.copyPasswordToMyClipboard()
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.doc.on.clipboard")
                            Text(appState.lastGeneratedPassword.isEmpty ? "None" : appState.lastGeneratedPassword)
                                .lineLimit(1)
                                .truncationMode(.middle)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(appState.lastGeneratedPassword.isEmpty)
                    .padding(.top, 5)
                }

              
            }

            Divider()
            
            //-- Password History Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Password History")
                    .font(.headline)

                if appState.passwordHistory.isEmpty {
                    Text("No history yet")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                   
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(appState.passwordHistory, id: \.self) { password in
                                HStack {
                                    
                                    Button(action: {
                                        appState.copyToMyClipboard(password)
                                    }) {
                                        HStack {
                                            Image(systemName: "arrow.right.doc.on.clipboard")
                                            Text(password)
                                                .lineLimit(1)
                                                .truncationMode(.middle)
                                                .padding(3)
                                        }
                                    }
                                    .cornerRadius(8)
                                    

                                    Spacer()

                                    Button(action: {
                                        appState.removePasswordFromHistory(password)
                                    }) {
                                        Text("Delete")
                                            .foregroundColor(.red)
                                            .font(.system(size: 13))
                                            .padding(3)
                                            
                                    }
                                }
                                .padding(.vertical, 4)
                              //  .background(Color.gray.opacity(0.1))
                             //   .cornerRadius(8)
                            }

                        }
                    
                    .frame(maxHeight: 150)
                }

                if !appState.passwordHistory.isEmpty {
                    Button("Clear All History") {
                        appState.clearAllHistory()
                    }
                    .foregroundColor(.red)
                    .padding(.top, 4)
                }
            }

            Divider()

            //-- Settings Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Settings")
                    .font(.headline)

                HStack {
                    Text("Password Length:")
                    Menu("\(appState.passwordLength)") {
                        ForEach([10, 16, 20, 25], id: \.self) { length in
                            Button("\(length)") { appState.passwordLength = length }
                        }
                    }
                }
                
                // -- Toggles
                Toggle("Include Uppercase", isOn: $appState.includeUppercase)
                    .tint(.blue)
                Toggle("Include Numbers", isOn: $appState.includeNumbers)
                    .tint(.blue)
                Toggle("Include Special Characters", isOn: $appState.includeSpecialChars)
                    .tint(.blue)
            }

            Divider()


            Button(action: {
                        NSApplication.shared.terminate(nil)
                    }) {
                        Image(systemName: "power.circle")
                            .symbolRenderingMode(.monochrome)
                            .foregroundColor(Color.red)
                            .font(.system(size: 22, weight: .regular))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                isPressed = true
                            }
                            .onEnded { _ in
                                isPressed = false
                            }
                    )
        }
        .padding()
        .frame(width: 300)
    }
}


