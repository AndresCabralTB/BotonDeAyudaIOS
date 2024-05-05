//
//  DataManager.swift
//  BotonDeAyudaIOS
//
//  Created by Andres Cabral on 04/05/24.
//

import Foundation
import SwiftUI

// This class allows a notification to be sent from another View, which in return activates any function from some other view See example in WantToReadView
class DataManager: ObservableObject {
    static let shared = DataManager()
    
    func reloadBarMark() {
        NotificationCenter.default.post(name: NSNotification.Name("reloadBarMark"), object: nil)
    }
}

