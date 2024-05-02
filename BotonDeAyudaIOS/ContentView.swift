//
//  ContentView.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/04/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView{
            VStack{
                Button{
                    
                }label:{
                    Text("In case of emergencies")
                    
                }
                
            }
        }
    }
}

struct BluetoothView: View{
    
    var devices: [String] = ["VW Phone", "Button", "Headphones", "Sony"]
    
    var body: some View{
        List{
            ForEach(devices, id:\.self){ device in
                Text("\(device)")
                
            }
        }
    }
}

#Preview {
    ContentView()
}
