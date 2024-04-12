//
//  Profile.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 09/04/24.
//

import SwiftUI

struct Profile: View {
    
    @State private var selection = 0

    public var priorityList = ["Priority 1", "Priority 2", "Priority 3"]
    
    var body: some View {
        
        //Creat un view del perfíl
        NavigationView{
            Form{
                //Crear la sección para la información de usuario
                Section("User Information"){
                    List{
                        Text("Name: ")
                        Text("Date of Birth: ")
                        Text("Gender: ")
                        Text("Phone Number: ")
                        Text("Medical Record: ")
                    }
                }
                //Crear la sección para la información del contacto de emergencia
                Picker("Select your contact priority", selection: $selection){
                    ForEach(0..<3, id:\.self){ index in
                        Text("Priority \(index + 1)")
                    }
                }.pickerStyle(.menu)
                
                
                switch selection {
                case 0:
                    PLists(sectionTitle: priorityList[selection])
                case 1:
                    PLists(sectionTitle: priorityList[selection])
                case 2:
                    PLists(sectionTitle: priorityList[selection])
                default:
                    Text("Not available")
                }
                
            }
            }
            
        }
        
    }

#Preview {
    Profile()
}

struct PLists : View{
    
    @State var sectionTitle: String
    
    @State var emergencyName = ""
    @State var emergencyDoB = ""
    @State var emergencyGender = ""
    @State var emergencyPhoneNum = ""
    @State var emergencyMD = ""
    
    var body: some View{
        
        Section(header: Text(sectionTitle).font(.headline).fontWeight(.bold)){
            List{
                TextField("Name", text: $emergencyName)
                TextField("Date of Birth:", text: $emergencyDoB)
                TextField("Gender: ", text: $emergencyGender)
                TextField("Phone Number: ", text: $emergencyPhoneNum)
                TextField("Medical Record: ", text: $emergencyMD)
                Button{
                    
                } label:{
                    Text("Enter information")
                        .foregroundStyle(Color.blue)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        
        
    }
}
