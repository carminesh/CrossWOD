//
//  HomeView.swift
//  CrossWOD
//
//  Created by Carmine Fabbri on 23/10/24.
//

import SwiftUI

struct HomeView: View {
    var props: Properties
    @State private var selectedMode: String = ""
    @State private var showTimer = false
    @State private var userIsPro: Bool = false
    
    // Computed property to get the workout list based on userIsPro status
    private var workoutList: [(title: String, icon: String, modeDescription: String, destination: AnyView)] {
        Constants.getWorkouts(userIsPro: userIsPro)
    }
    
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Color("backgroundColor").edgesIgnoringSafeArea(.all)
                    
                    
                    
                    VStack {
                        HStack {
                            Text("CrossWOD")
                                .font(Font.custom("ethnocentric", size: 28))
                                .foregroundColor(.white)
                            
                            
                            Spacer()
                            
                            NavigationLink(destination: SettingsView()) {
                                Image("setting_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .padding()
                        .padding(.horizontal)
                        
                        LazyVStack(spacing: 0) {
                            ForEach(workoutList, id: \.title) { workout in
                                NavigationLink(destination: workout.destination) {
                                    CardView(
                                        imageName: workout.icon, title: workout.title, modeDescription: workout.modeDescription
                                    )
                                    .padding(6 )
                                    
                                }
                            }
                        }.padding(.top, UIScreen.main.bounds.width < 376 ? 0 : 30)
                        
                        Spacer()
                    }
                }.navigationBarHidden(true)
            }
            .accentColor(.white)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 16 Pro")
                .previewDisplayName("iPhone 16 Pro")
            
            ContentView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE 3rd Gen")
            
            ContentView()
                .previewDevice("iPad (11-inch)")
                .previewDisplayName("iPad 11-inch")
        }
        .previewLayout(.device)
    }
}
