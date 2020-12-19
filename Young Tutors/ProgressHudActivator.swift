//
//  ProgressHudActivator.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/13/20.
//

import SwiftUI
import Firebase

//I've added the firebase model inheretence because this activator property will onlly be used for classes that contain long tasks (like firebase calls), which need loading and success indicators)
class ProgressHudActivator: FirebaseModel, ObservableObject {
    
    @Published var hudIsActive = false
    @Published var hudType: TTProgressHUDType = .Loading
    
    func activate() {
        
        hudType = .Loading
        hudIsActive = true
        
        
    }
    
    func deactivateHud() {
        hudIsActive = false
    }
    
    func success() {
        hudType = .Success
        hudIsActive = true
        generateHapticNotification(for: .Success)
        
    }
    
    func error() {
        hudType = .Error
        hudIsActive = false
        generateHapticNotification(for: .Error)
        
    }
    
    private func generateHapticNotification(for type: TTProgressHUDType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        
        switch type {
        case .Success:
            generator.notificationOccurred(.success)
        case .Warning:
            generator.notificationOccurred(.warning)
        case .Error:
            generator.notificationOccurred(.error)
        default:
            return
        }
    }
    
}

class FirebaseModel {
    
    var db: Firestore!
    
    init() {
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        
    }
    
}
