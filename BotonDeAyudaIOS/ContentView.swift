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
                    Button{ //Agregar el botón principal de ayuda
                        
                    }label:{ //Darle la estética y la forma al botón
                        Text("Botón de ayuda")
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.25)
                            .padding(10)
                            .foregroundStyle(Color.white)
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                        .padding()
                }.navigationTitle("Press Help Button")
            }
        
    }
}

#Preview {
    ContentView()
}
