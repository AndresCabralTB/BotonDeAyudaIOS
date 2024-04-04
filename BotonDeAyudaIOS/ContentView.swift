//
//  ContentView.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/04/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button{
                
            }label:{
                Text("Botón de ayuda")
                    .padding(10)
                    .foregroundStyle(Color.white)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
