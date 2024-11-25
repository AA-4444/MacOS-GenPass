//
//  ContentView.swift
//  GenPass
//
//  Created by Oleksii Zarytskyi on 11/24/24.
//

import SwiftUI

struct ContentView: View {
    @State private var animate = false
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
                          .foregroundColor(.gray)
                          .modifier(ShimmerEffect(animate: animate))

                      Text("Navigate to menu bar and click on key icon to generate password")
                          .font(.system(size: 14))
                          .padding()
                          .foregroundColor(.gray)
                          .modifier(ShimmerEffect(animate: animate))

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(
//                   LinearGradient(gradient: Gradient(colors: [.blue, Color("Violet")]), startPoint: .top, endPoint: .bottom)
//               )
        .background(.black)
        .cornerRadius(20)
        .padding()
        .font(.title)
        .onAppear {
            withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                      animate.toggle()
                  }
              }
    }
}
struct ShimmerEffect: ViewModifier {
    var animate: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.white.opacity(0.3), .white.opacity(0.6), .white.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: animate ? 500 : -500) 
                .mask(content)
            )
            .clipShape(Rectangle())
    }
}
#Preview {
    ContentView()
}
