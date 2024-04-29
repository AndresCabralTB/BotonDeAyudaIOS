//
//  ContactViewModel.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 18/04/24.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


struct UserData{
    var userID: String
    var name: String
    var dateOfBirth: Date
    var gender: String
    var phoneNumber: String
    var priority: Int
}

struct MainUser{
    var userID: String
    var name: String
    var dateOfBirth: Date
    var gender: String
    var phoneNumber: String
}

final class ContactViewModel: ObservableObject{
    
    private var db = Firestore.firestore().collection("userInfo")
    
    func setDocument(userID: String) -> DocumentReference{
        db.document(userID)
    }
    func addUser(user: MainUser) async throws{
        
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           let dateString = dateFormatter.string(from: user.dateOfBirth)
        
        let data: [String: Any] = [
            "user_id": user.userID,
            "name": user.name,
            "dateOfBirth": dateString,
            "gender": user.gender,
            "phone_number": user.phoneNumber
        ]
        try await setDocument(userID: user.userID).setData(data)
    }
    
    func getUser(userID: String) async throws -> MainUser{
        let snapshot = try await setDocument(userID: userID).getDocument()
        
        
        guard let data = snapshot.data(),
              let name = data["name"] as? String,
              let dateString = data["dateOfBirth"] as? String, // Retrieve the date as a string
              let gender = data["gender"] as? String,
              let phoneNumber = data["phone_number"] as? String
  
        else{
            print("Error getting priority contact")
            return MainUser(userID: userID, name: "", dateOfBirth: Date.now, gender: "", phoneNumber: "")
        }
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let dateOfBirth = dateFormatter.date(from: dateString) else {
                print("Error converting date string to Date object")
                return MainUser(userID: userID, name: "", dateOfBirth: Date(), gender: "", phoneNumber: "")
            }
        
        return MainUser(userID: userID, name: name, dateOfBirth: dateOfBirth, gender: gender, phoneNumber: phoneNumber)
    }
    
}

/**Extension for the contact information backend*/
extension ContactViewModel{
    func setPriority(userID: String, priority: Int) -> DocumentReference{
        db.document(userID).collection("Priorities").document("Priority_\(priority)")
    }
    
    func addPriorityContact(user: UserData) async throws{
        // Print the data to check if it's valid
        print("Adding priority contact with data: \(user)")
        
        // Check if any of the required fields are empty
        guard !user.userID.isEmpty, !user.name.isEmpty, !user.gender.isEmpty, !user.phoneNumber.isEmpty, user.priority != 0 else {
            print("Error: One or more fields are empty.")
            return
        }
        
        let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           let dateString = dateFormatter.string(from: user.dateOfBirth)

        let data: [String: Any] = [
            "user_id": user.userID,
            "name": user.name,
            "dateOfBirth": dateString,
            "gender": user.gender,
            "phone_number": user.phoneNumber,
            "priority": user.priority
        ]

        do {
            try await setPriority(userID: user.userID, priority: user.priority).setData(data)
            print("Priority contact added successfully.")
        } catch {
            print("Error adding priority contact: \(error)")
        }
    }
    
    func getPriorityContact(userID: String, priority: Int) async throws-> UserData{
        let snapshot = try await setPriority(userID: userID, priority: priority).getDocument()
        
        guard let data = snapshot.data(),
              let userID = data["user_id"] as? String,
              let name = data["name"] as? String,
              let dateString = data["dateOfBirth"] as? String,
              let gender = data["gender"] as? String,
              let phoneNumber = data["phone_number"] as? String,
              let priority = data["priority"] as? Int
  
        else{
            print("Error getting priority contact")
            return UserData(userID: userID, name: "", dateOfBirth: Date.now, gender: "", phoneNumber: "", priority: 0)
        }
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let dateOfBirth = dateFormatter.date(from: dateString) else {
                print("Error converting date string to Date object")
                return UserData(userID: userID, name: "", dateOfBirth: Date.now, gender: "", phoneNumber: "", priority: 0)
            }
        
        return UserData(userID: userID, name: name, dateOfBirth: dateOfBirth, gender: gender, phoneNumber: phoneNumber, priority: priority)
    }
}
