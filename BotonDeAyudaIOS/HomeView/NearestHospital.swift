//
//  NearestHospital.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/05/24.
//

import SwiftUI
import MapKit

struct Location: Identifiable{
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    
}

struct NearestHospital: View {
    
  

    let newPin = Location(name:"London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275))
    
//    @State var newPin: Location
    @State var position : MapCameraPosition =  MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.773998, longitude: -73.966003),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    ))
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Nearest Hospital")
                .font(.headline)
                .fontWeight(.bold)
            
            Map(initialPosition: position){ //Mostrar el mapa. Darle sus dimensiones
                Marker(newPin.name, coordinate: newPin.coordinate)
            }
            .frame(height: UIScreen.main.bounds.height * 0.20)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
//        .frame(width: UIScreen.main.bounds.width * 0.95)
        
    }
}

#Preview {
    NearestHospital()
        .environmentObject(UserID())
}
