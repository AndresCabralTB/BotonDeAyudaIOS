//
//  Priority.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/05/24.
//

import SwiftUI

struct Priority : View{
    @StateObject var contactViewModel = ContactViewModel()
    @EnvironmentObject var userID: UserID
    @State var selection: Int
    
    @Binding var contact: UserData
    
    @State var isEditingContact: Bool = false
    @State var showContact: Bool = false
    @State var dateString = ""
    
    
    @State var scaleFactor: Bool = false
    
    @State var contactsArray: [UserData] = []
    
    var body: some View{
        
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "\(contact.priority).square")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.bold)
                    .frame(width: 35)
                    .scaleEffect(scaleFactor ? 1.3 : 1)
//                    .symbolEffect(.scale.up, isActive: isEditingContact) //Scale the object only when editing
                    .animation(.bouncy, value: scaleFactor)
                
                if !isEditingContact{
                    Text("Name: \(contact.name)")
                        .fontWeight(.bold)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                }
                Spacer()
                Button{
                    withAnimation(.spring(response: 1, dampingFraction: 0.5, blendDuration: 0.5)){
                        isEditingContact.toggle()
                    }
                    
                    withAnimation(.bouncy()){
                        scaleFactor.toggle()
                    }completion: {
                        scaleFactor.toggle()
                    }
                }label:{
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .fontWeight(.bold)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if isEditingContact{
                TextField("Name", text: $contact.name)
                    .fontWeight(.bold)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                
                TextField("Phone Number: ", text: $contact.phoneNumber)
                    .fontWeight(.bold)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                
                DatePicker("Choose a date", selection: $contact.dateOfBirth, displayedComponents: .date)
                    .fontWeight(.bold)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                
                TextField("Gender: ", text: $contact.gender)
                    .fontWeight(.bold)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                
                Button{
                    Task{
                        do{
                            try await contactViewModel.addPriorityContact(user: contact)
                        }
                    }
                    withAnimation(.spring(response: 1, dampingFraction: 0.5, blendDuration: 0.5)){
                        isEditingContact.toggle()
                    }
                    
                }label:{
                    Text("Enter")
                        .fontWeight(.bold)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(UIColor.secondarySystemBackground)).shadow(radius: 10))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(getColor(selection: contact.priority)).shadow(radius: 10))
        .animation(.easeInOut, value: selection)
    }
    
    func getColor(selection: Int) ->Color{
        
        switch(selection){
        case 1:
            return Color.red
        case 2:
            return Color.green
        case 3:
            return Color.yellow
            
        default:
            return Color.gray
        }
    }
    
}

#Preview {
    HomePage()
        .environmentObject(UserID())
}
