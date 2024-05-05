//
//  SplashScreen.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 05/05/24.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack{
            
            Image("AppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            
        }
    }
}

#Preview {
    SplashScreen()
        .environmentObject(UserID())
}
