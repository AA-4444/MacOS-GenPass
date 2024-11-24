//
//  ContentView.swift
//  GenPass
//
//  Created by Алексей Зарицький on 11/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // Здесь можно поместить иконку или другую информацию
            Image(systemName: "key.horizontal.fill")
                .imageScale(.large)
                .foregroundColor(.blue)
                .padding()
            
            // Текст, который будет отображаться
            Text("Password Generator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.black)

            Text("Click on the menu bar icon to generate a password.")
                .font(.body)
                .padding()
                .foregroundColor(.black)

            Spacer()  // Чтобы элементы не прижимались к верхней части экрана
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.)  // Белый фон
        .cornerRadius(20)  // Сглаженные углы
        .padding()  // Отступы
        .font(.title)
    }
}

#Preview {
    ContentView()
}
