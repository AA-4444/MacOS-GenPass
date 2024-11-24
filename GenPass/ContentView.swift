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
            
            Image(systemName: "key.horizontal.fill")
                .imageScale(.large)
                .foregroundColor(.white)
                .font(.system(size: 25))
                .padding()
            
           
            Text("Password Generator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)

            Text("Navigate to menu bar and click on key icon to generate password")
                .font(.system(size: 14))
                .padding()
                .foregroundColor(.white)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
                   LinearGradient(gradient: Gradient(colors: [.blue, Color("Violet")]), startPoint: .top, endPoint: .bottom)
               )
        .cornerRadius(20)
        .padding()
        .font(.title)
    }
}

#Preview {
    ContentView()
}
