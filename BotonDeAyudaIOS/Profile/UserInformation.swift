//
//  UserInformation.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/05/24.
//

import SwiftUI

struct UserInformation : View{
    @StateObject var contactViewModel = ContactViewModel()
    @EnvironmentObject var userID: UserID
    @State private var selection = 1
    
    @State var contactInformation = UserData(userID: "", name: "", dateOfBirth: Date.now, gender: "", phoneNumber: "", priority: 1)

    @State var showContact: Bool = false
    
    
    @State var scaleFactor: Bool = false
    @State var contactsArray: [UserData] = []
    @State var dateString = ""
    
    var body: some View{
        
        VStack{
            if showContact{
                ForEach($contactsArray, id: \.priority){$contact in
                    Priority(selection: contact.priority, contact: $contact)
                }
            }
            
            Button{
                withAnimation(.spring(response: 1, dampingFraction: 0.5, blendDuration: 0.5)){
                    showContact.toggle()
                }
            }label: {
                HStack{
                    Text("Open Emergency Contacts")
                    Image(systemName: "arrow.down.circle")
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.black)
                .fontWeight(.bold)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.gray))
            }
        }
        .onAppear {
            loadContact()
        }
        
    }
    
    
    
    func loadContact(){
        contactsArray = []
        Task{
            do{
                for index in 1..<4{
                    var contact: UserData = UserData(userID: "", name: "", dateOfBirth: Date.now, gender: "", phoneNumber: "", priority: index)
                    
                    contact.userID = UserDefaults.standard.string(forKey: "User_id") ?? userID.userID
                    
                    contact = try await contactViewModel.getPriorityContact(userID: contact.userID, priority: index)
                    contactsArray.append(contact)
                }
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateString = dateFormatter.string(from: contactInformation.dateOfBirth)
            }
        }
    }
}
#Preview {
    UserInformation()
        .environmentObject(UserID())
}
