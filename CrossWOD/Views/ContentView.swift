//
//  ContentView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 12/10/24.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        ResponsiveView { props in
            HomeView(props: props)
        }
    }
}


#Preview {
    ContentView()
}
