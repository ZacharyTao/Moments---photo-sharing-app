////
////  MainViewModel.swift
////  Moment
////
////  Created by Zachary Tao on 12/23/23.
////
//
//import Foundation
//import SwiftUI
//import Combine
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//
//@MainActor
//class MainViewModel: ObservableObject {
//  @Published var friends : [Friend] = []
//  @Published private var user: User?
//  private var db = Firestore.firestore()
//  private var cancellables = Set<AnyCancellable>()
//
//  init() {
//    registerAuthStateHandler()
//
//    $user
//      .compactMap { $0 }
//      .sink { user in
//        self.favourite.userId = user.uid
//      }
//      .store(in: &cancellables)
//  }
//
//  private var authStateHandler: AuthStateDidChangeListenerHandle?
//
//  func registerAuthStateHandler() {
//    if authStateHandler == nil {
//      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
//        self.user = user
//        self.fetchFavourite()
//      }
//    }
//  }
//
//  func fetchFriends() {
//    guard let uid = user?.uid else { return }
//    Task {
//      do {
//        self.favourite  = try await db.collection("favourites").document(uid).getDocument(as: Favourite.self)
//      }
//      catch {
//        print(error.localizedDescription)
//      }
//    }
//  }
//
//  func addFriends() {
//    guard let documentId = user?.uid else { return }
//
//    do {
//      try db.collection("favourites").document(documentId).setData(from: favourite)
//    }
//    catch {
//      print(error.localizedDescription)
//    }
//  }
//}
