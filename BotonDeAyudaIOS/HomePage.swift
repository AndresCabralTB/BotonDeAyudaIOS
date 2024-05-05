//
//  HomePage.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 09/04/24.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        //Página principal donde se muestran todos los views
        TabView{
            ContentView()
                .tabItem {
                    Text("Home")
                    Image(systemName: "house")
                    
                }
            //Insertar el view del perfil
            Profile()
                .tabItem {
                    Text("Profile")
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    HomePage()
        .environmentObject(UserID())
}
