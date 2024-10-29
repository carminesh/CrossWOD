//
//  LaunchScreen.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 28/10/24.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @Binding var isPresented: Bool
    @State private var showText: Bool = false
    @State private var viewOpacity = 1.0 // New state for view opacity
    var riveLaunchAnimation = RiveAnimationManager(fileName: "launch_screen_animation", stateMachineName: "splash_animation")
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            riveLaunchAnimation.riveViewModel.view()
            
            if showText {
                Text("CrossWOD")
                    .font(Font.custom("ethnocentric", size: 22))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.top, 220)
                    .opacity(showText ? 1 : 0)
                    .transition(.opacity)
                    .animation(.easeIn(duration: 0.7), value: showText)
            }
        }
        .opacity(viewOpacity)
        .onAppear {
            riveLaunchAnimation.startRiveAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showText.toggle()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isPresented.toggle()
            }
        }
    }
}

#Preview {
    LaunchScreenView(isPresented: .constant(true))
}
