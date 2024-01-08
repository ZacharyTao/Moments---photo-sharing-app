//
//  AuthenticationViewModel.swift
//  Moment
//
//  Created by Zachary Tao on 12/21/23.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import UIKit


enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var flow: AuthenticationFlow = .login
    
    @Published var isValid  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var user: User?
    @Published var displayEmail = ""
    @Published var isSignupComplete = false
    @Published var userName = ""
    @Published  var selectedImage: UIImage?

    
    init() {
        registerAuthStateHandler()
        
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayEmail = user?.email ?? ""
                let parts = self.displayEmail.components(separatedBy: "@")
                self.userName = parts.first ?? ""
            }
        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Done")
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
}

// MARK: - Email and Password Authentication

extension AuthenticationViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            return true
        }
        catch  {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do  {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
//    func completeProfileSetup(username: String, photo: UIImage?) async {
//        guard let user = Auth.auth().currentUser else { return }
//
//        // Update the username
//        let changeRequest = user.createProfileChangeRequest()
//        changeRequest.displayName = username
//        do {
//            try await changeRequest.commitChanges()
//        } catch {
//            print("Error updating username: \(error.localizedDescription)")
//            self.errorMessage = "Error updating username"
//            return
//        }
//
//        // Continue with photo upload if provided
//        if let photo = photo, let photoData = photo.jpegData(compressionQuality: 0.8) {
//            let photoRef = Storage.storage().reference().child("userPhotos/\(user.uid)/profile.jpg")
//            do {
//                let _ = try await photoRef.putData(photoData, metadata: nil)
//                let photoURL = try await photoRef.downloadURL()
//                let photoChangeRequest = user.createProfileChangeRequest()
//                photoChangeRequest.photoURL = photoURL
//                try await photoChangeRequest.commitChanges()
//            } catch {
//                print("Failed to upload photo: \(error.localizedDescription)")
//                self.errorMessage = "Failed to upload photo"
//                return
//            }
//        }
//
//        // Update internal state to indicate profile setup is complete
//        self.isSignupComplete = true
//    }
    
    
    
    func updateUserProfile(username: String, photo: UIImage?) async {
        guard let user = Auth.auth().currentUser else { return }

        // Update username
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = username

        // Upload photo and get URL
        if let photo = photo, let photoData = photo.jpegData(compressionQuality: 0.8) {
            let photoRef = Storage.storage().reference().child("userPhotos/\(user.uid)/profile.jpg")
            do {
                let _ = try await photoRef.putData(photoData, metadata: nil)
                let photoURL = try await photoRef.downloadURL()
                changeRequest.photoURL = photoURL
            } catch {
                print("Error uploading photo: \(error.localizedDescription)")
                return
            }
        }

        // Commit changes
        do {
            try await changeRequest.commitChanges()
        } catch {
            print("Error updating profile: \(error.localizedDescription)")
        }
    }
    
    func getUserProfile() async -> URL? {
        guard let user = Auth.auth().currentUser else { return nil }
        return user.photoURL
    }
    

}
