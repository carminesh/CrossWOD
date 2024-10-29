//
//  ContentView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 12/10/24.
//


import SwiftUI

struct ContentView: View {
    
    @State private var isLaunchScreenPresented: Bool = true
        
    var body: some View {
        ResponsiveView { props in
            if !isLaunchScreenPresented {
                HomeView(props: props)
            } else {
                LaunchScreenView(isPresented: $isLaunchScreenPresented)
            }
        }
    }
}


#Preview {
    ContentView()
}
