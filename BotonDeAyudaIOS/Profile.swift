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
            ScrollView{
                
                VStack(alignment: .leading){
                    
                    
                    
                    //Crear la sección para la información de usuario
                    
                    
                    
                    Section(header:
                        Text("Your Information")
                            .fontWeight(.bold)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                    ){
                        VStack(alignment: .leading){
                            
                            if !isEditingUser{
                                Text("Name: \(userData.name)")
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                                
                                Text("Phone Number: \(userData.phoneNumber)")
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                                
                                Text("Date of Birth: \(dateString)")
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                                
                                Text("Gender: \(userData.gender)")
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                            }else{
                                TextField("Name", text: $userData.name)
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                                
                                DatePicker("Choose a date", selection: $userData.dateOfBirth, displayedComponents: .date)
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                                
                                TextField("Phone Number: ", text: $userData.phoneNumber)
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                                
                                TextField("Gender: ", text: $userData.gender)
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                                
                            }
                            
                            Button{
                                
                                if isEditingUser{
                                    
                                    Task{
                                        do{
                                            try await userViewModel.addUser(user: userData)
                                        }
                                    }
                                }
                                withAnimation(.spring(response: 1, dampingFraction: 0.5, blendDuration: 0.5)){
                                    isEditingUser.toggle()
                                }
                            } label:{
                                
                                if isEditingUser{
                                    Text("Enter")
                                        .fontWeight(.bold)
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                                }else{
                                    Text("Edit Information")
                                        .fontWeight(.bold)
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.gray).shadow(radius: 10))
                    }
                    
                    
                    Divider()
                    
                    UserInformation()
                    
                    Spacer()
                    
                }
                .padding()
                
                .onAppear{
                    loadUserData()
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem{
                    HStack{
                        Spacer()
                        Text("Profile")
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "heart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .padding(10)
                            .foregroundStyle(Color.red)
                            .background(Circle().foregroundStyle(Color(UIColor.secondarySystemBackground)))
                    }
                }
            }
        }
        
    }
    func loadUserData(){
        Task{
            do{
                userData.userID = UserDefaults.standard.string(forKey: "User_id") ?? userID.userID
                userData = try await userViewModel.getUser(userID: UserDefaults.standard.string(forKey: "User_id") ?? userID.userID)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateString = dateFormatter.string(from: userData.dateOfBirth)
                
                print("User default: \(String(describing: UserDefaults.standard.string(forKey: "User_id")))")
            }
        }
    }
    
}

struct UserInformation : View{
    @StateObject var contactViewModel = ContactViewModel()
    @EnvironmentObject var userID: UserID
    @State private var selection = 0
    
    @State var contactInformation = UserData(userID: "", name: "", dateOfBirth: Date.now, gender: "", phoneNumber: "", priority: 1)
    
    @State var isEditingContact: Bool = false
    @State var showContact: Bool = false
    @State var dateString = ""
    
    @State var scaleFactor: Bool = false
    
    var body: some View{
        
        VStack{
            
            
            
            if showContact {
                VStack(alignment: .leading){
                    
                    HStack{
                        
                        Text("Contact Priority \(selection)")
                            .fontWeight(.bold)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                            .scaleEffect(scaleFactor ? 1.3 : 1)
                            .animation(.bouncy, value: scaleFactor)
                        
                        
                        Spacer()
                        Button{
                            withAnimation(.bouncy(duration: 0.5, extraBounce: 0.25)){
                                showContact = false
                                selection = 0
                            }
                        }label:{
                            Image(systemName: "arrow.up.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .fontWeight(.bold)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    if !isEditingContact{
                        Text("Name: \(contactInformation.name)")
                            .fontWeight(.bold)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                        
                        
                        Text("Phone Number: \(contactInformation.phoneNumber)")
                            .fontWeight(.bold)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                        
                        Text("Date of Birth: \(dateString)")
                            .fontWeight(.bold)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                        
                        
                        Text("Gender: \(contactInformation.gender)")
                            .fontWeight(.bold)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                    }else{
                        TextField("Name", text: $contactInformation.name)
                            .fontWeight(.bold)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                        
                        TextField("Phone Number: ", text: $contactInformation.phoneNumber)
                            .fontWeight(.bold)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                        
                        DatePicker("Choose a date", selection: $contactInformation.dateOfBirth, displayedComponents: .date)
                            .fontWeight(.bold)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                        
                        TextField("Gender: ", text: $contactInformation.gender)
                            .fontWeight(.bold)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                        
                        
                    }
                    
                    Button{
                        if isEditingContact{
                            Task{
                                do{
                                    try await contactViewModel.addPriorityContact(user: contactInformation)
                                }
                            }
                        }
                        
                        withAnimation(.spring(duration: 1, bounce: 0.6)){
                            isEditingContact.toggle()
                        }
                    }label:{
                        Text("Edit Contact")
                            .fontWeight(.bold)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.gray).shadow(radius: 10))
            }
            
            Menu {
                Picker("Select contact priority", selection: $selection){
                    ForEach(1..<4, id:\.self){ index in
                        Text("Priority \(index)")
                    }
                }
            } label: {
                HStack{
                    Text("Priority Contacts")
                    Image(systemName: showContact ? "arrow.up.circle" : "arrow.down.circle")
                }
                .foregroundStyle(Color.black)
                .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.gray))
            .onChange(of: selection, { oldValue, newValue in
                if newValue != 0{
                    withAnimation(.bouncy(duration: 0.5, extraBounce: 0.25)){
                        showContact = true
                    }
                }
                
                if oldValue != 0 {
                    withAnimation(.bouncy()){
                        scaleFactor.toggle()
                    }completion: {
                        scaleFactor.toggle()
                    }
                }
                loadContact()
            })
        }
        .frame(maxWidth: .infinity)
        .task {
            loadContact()
        }
        
    }
    
    
    func loadContact(){
        Task{
            do{
                contactInformation.userID = UserDefaults.standard.string(forKey: "User_id") ?? userID.userID
                contactInformation = try await contactViewModel.getPriorityContact(userID: userID.userID, priority: selection)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateString = dateFormatter.string(from: contactInformation.dateOfBirth)
                
            }
        }
    }
}

#Preview {
    Profile()
        .environmentObject(UserID())
}
