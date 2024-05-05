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
    
    @State var userData: MainUser = MainUser(userID: "", name: "", dateOfBirth: Date.now, gender: "", phoneNumber: "", heartRate: 0)
    
    @State var showContacts: Bool = false
    
    public var priorityList = ["Priority 0", "Priority 1", "Priority 2", "Priority 3"]
    @State var isEditingUser: Bool = false
    @State var dateString = ""
    
    var body: some View {
        
        //Crea un view del perfíl
        NavigationView{
            ScrollView{
                
                VStack(alignment: .leading, spacing: 10){
                    
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 150)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.gray).shadow(radius: 10))
                    
                    VStack(alignment: .leading){
                        
                        if !isEditingUser{
                            Text("Name: \(userData.name)")
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
                            
                            TextField("Heart Rate", value: $userData.heartRate, format: .number)
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
                    //                    }
                    
                    
                    Divider()
                    
                    UserInformation()
                    
                    Spacer()
                    
                }
                .padding()
                
                .onAppear{
                    loadUserData()
                    
                }
            }
            .navigationTitle("Your information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem{
                    HStack{
                        
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

#Preview {
    Profile()
        .environmentObject(UserID())
}
