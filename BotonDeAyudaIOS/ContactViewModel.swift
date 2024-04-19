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
    var name: String
    var dateOfBirth: String
    var gender: String
    var phoneNumber: String
}

final class ContactViewModel: ObservableObject{
    
    private var db = Firestore.firestore().collection("userInfo")
    
    func setDocument() -> DocumentReference{
        db.document("Priority")
    }
    
    func addUser(user: UserData) async throws{
        
        let data: [String: Any] = [
            "name": user.name,
            "dateOfBirth": user.dateOfBirth,
            "gender": user.gender,
            "phone_number": user.phoneNumber
        ]
        
        try await setDocument().setData(data)
    }
    
}
