//
//  UserIDClass.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 29/04/24.
//

import Foundation

final class UserID: ObservableObject {
    @Published var userID: String
    
    init() {
        self.userID = UserDefaults.standard.string(forKey: "User_id") ?? UUID().uuidString
        UserDefaults.standard.set(self.userID, forKey: "User_id")
    }
}
