//
//  Profile.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 09/04/24.
//

import SwiftUI

struct Profile: View {
    @EnvironmentObject var userID: UserID
    @StateObject var userViewModel = ContactViewModel()
    @State private var selection = 1
    
    @State var userData: MainUser = MainUser(userID: "", name: "", dateOfBirth: Date.now, gender: "", phoneNumber: "")
    
    @State var showContacts: Bool = false
    
    public var priorityList = ["Priority 0", "Priority 1", "Priority 2", "Priority 3"]
    @State var isEditingUser: Bool = false
    @State var dateString = ""
    
    var body: some View {
        
        //Crea un view del perfíl
        NavigationView{
            Form{
                //Crear la sección para la información de usuario
                Section("User Information"){
                    List{
                        if isEditingUser {
                            Text("UserID: \(userData.userID)")
                            TextField("Name", text: $userData.name)
                            DatePicker("Choose a date", selection: $userData.dateOfBirth, displayedComponents: .date)
//                            TextField("Date of Birth:", text: $userData.dateOfBirth)
                            TextField("Gender: ", text: $userData.gender)
                            TextField("Phone Number: ", text: $userData.phoneNumber)
                            Button{
                                Task{
                                    do{
                                        try await userViewModel.addUser(user: userData)
                                    }
                                    withAnimation(.easeInOut){
                                        isEditingUser.toggle()
                                    }
                                }
                            } label:{
                                Text("Enter information")
                                    .foregroundStyle(Color.blue)
                                    .frame(maxWidth: .infinity)
                            }
                        } else{
                            
                            Text("UserID: \(userData.userID)")
                            Text("Name: \(userData.name)")
                            Text("Date of Birth: \(dateString)")
                            Text("Gender: \(userData.gender)")
                            Text("Phone Number: \(userData.phoneNumber)")
                            Button{
                                withAnimation(.easeInOut){
                                    isEditingUser.toggle()
                                }
                            } label:{
                                Text("Edit Information")
                                    .foregroundStyle(Color.blue)
                                    .frame(maxWidth: .infinity)
                            }
                            .onAppear{
                                let dateFormatter = DateFormatter()
                                   dateFormatter.dateFormat = "yyyy-MM-dd"
                                dateString = dateFormatter.string(from: userData.dateOfBirth)
                            }
                        }
                    }
                    
                }
                
                UserInformation()
            }
            .navigationTitle("Profile")
            .onAppear{
                Task{
                    do{
                        userData.userID = UserDefaults.standard.string(forKey: "User_id") ?? userID.userID
                        userData = try await userViewModel.getUser(userID: UserDefaults.standard.string(forKey: "User_id") ?? userID.userID)
                        print("User default: \(String(describing: UserDefaults.standard.string(forKey: "User_id")))")
                    }
                }
            }
            
        }
        
    }
    
}

struct UserInformation : View{
    @StateObject var contactViewModel = ContactViewModel()
    @EnvironmentObject var userID: UserID
    @State private var selection = 1
    
    @State var contactInformation = UserData(userID: "", name: "", dateOfBirth: Date.now, gender: "", phoneNumber: "", priority: 1)
    
    @State var isEditingContact: Bool = false
    @State var dateString = ""

    var body: some View{
        
        
        Picker("Select contact priority", selection: $selection){
            ForEach(1..<4, id:\.self){ index in
                Text("Priority \(index)")
            }
        }.pickerStyle(.menu)
        
        Section(header: Text("Contact Information")){
            List{
                if isEditingContact{
                    
                    TextField("Name", text: $contactInformation.name)
                    DatePicker("Choose a date", selection: $contactInformation.dateOfBirth, displayedComponents: .date)
                    TextField("Gender: ", text: $contactInformation.gender)
                    TextField("Phone Number: ", text: $contactInformation.phoneNumber)
                    
                    Button {
                        Task {
                            do {
                                contactInformation.priority = selection
                                contactInformation.userID = userID.userID
                                try await contactViewModel.addPriorityContact(user: contactInformation)
                            } catch {
                                print("Error adding priority contact: \(error)")
                            }
                            withAnimation(.easeInOut){
                                isEditingContact.toggle()
                            }
                        }
                    } label: {
                        Text("Enter information")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: .infinity)
                    }
                } else{
                    Text("Name: \(contactInformation.name)")
                    Text("Gender: \(contactInformation.gender)")
                    Text("Date of Birth: \(dateString)")
                    Text("Phone Number: \(contactInformation.phoneNumber)")
                    Button{
                        withAnimation(.easeInOut){
                            isEditingContact.toggle()
                        }
                    } label:{
                        Text("Edit Information")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: .infinity)
                    }
                    .onAppear{
                        let dateFormatter = DateFormatter()
                           dateFormatter.dateFormat = "yyyy-MM-dd"
                        dateString = dateFormatter.string(from: contactInformation.dateOfBirth)
                    }
                }
            }
        }
        
        
        .onChange(of: selection, { oldValue, newValue in
            loadContact()
        })
        .task {
            loadContact()
        }
        
    }
    
    func loadContact(){
        Task{
            do{
                contactInformation.userID = UserDefaults.standard.string(forKey: "User_id") ?? userID.userID
                contactInformation = try await contactViewModel.getPriorityContact(userID: userID.userID, priority: selection)
            }
        }
    }
}

#Preview {
    Profile()
        .environmentObject(UserID())
}
