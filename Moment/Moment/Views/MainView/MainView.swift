//
//  MainView.swift
//  Moment
//
//  Created by Zachary Tao on 12/22/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MainView: View {
    @ObservedObject var viewModel = AuthenticationViewModel()
    @State private var path = NavigationPath()
    
    
    var body: some View {
                NavigationStack(path: $path){
                    VStack{
                        Header().environmentObject(viewModel)
        
        
        
                        NavigationLink("ConversationView") {
        
                            Button{
                                path.append(0)
                            }label: {
                                Text("Go to Conversation")
                            }
                        }
                        Spacer()
        
                    }.navigationTitle("")
        
                }
//        NavigationView {
//            VStack{
//                List(friends, id: \.id) { friend in
//                    NavigationLink(destination: ConversationView(friend: friend)) {
//                        Text(friend.name)
//                    }
//                }
//            }
//            .onAppear {
//                loadFriends()
//            }
//            .navigationBarItems(trailing: Button(action: addFriend) {
//                Image(systemName: "plus")
//            })
//        }
    }
    
//    func loadFriends() {
//        let userId = Auth.auth().currentUser?.uid
//        let db = Firestore.firestore()
//
//        db.collection("users").document(userId).collection("friends").getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    let friendData = document.data()
//                    let friend = Friend(id: document.documentID, username: friendData["username"] as? String ?? "")
//                    self.friends.append(friend)
//                }
//            }
//        }
//    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock instance of AuthenticationViewModel
        let viewModel = AuthenticationViewModel()
        
        MainView()
            .environmentObject(viewModel) // Inject the ViewModel as an EnvironmentObject
            .previewLayout(.sizeThatFits) // Use a layout that fits the content of the view
            .padding() // Add some padding around the view for better visibility in the preview
    }
}



