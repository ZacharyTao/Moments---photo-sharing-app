//
//  UserProfileView.swift
//  Moment
//
//  Created by Zachary Tao on 12/21/23.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct UserProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var username: String = "DefaultUser"
    //@State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State var presentingConfirmationDialog = false
    
    private func submitProfile() {
            Task {
//                await viewModel.updateUserProfile(username: username, photo: selectedImage)
                dismiss()
            }
        }
    
    private func deleteAccount() {
        Task {
            if await viewModel.deleteAccount() == true {
                dismiss()
            }
        }
    }
    
    private func signOut() {
        viewModel.signOut()
    }
    
    var body: some View {
        Form {
            Section {
                VStack {
                    HStack {
                        Spacer()
                        
                        if let selectedImage = viewModel.selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .clipped()
                                .padding(4)
                        }else{
                            Image("Avatar")
                                .resizable()
                                .frame(width: 100 , height: 100)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .clipped()
                                .padding(4)
                                .overlay(Circle().stroke(Color.black, lineWidth: 4))
                        }
                        Spacer()
                    }
                    Button("Upload Photo") {
                        isImagePickerPresented = true
                    }
                    .padding(6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $viewModel.selectedImage)
                }
            }
            .listRowBackground(Color(UIColor.systemGroupedBackground))
            
            Section("User Name"){
                TextField("User name", text: $viewModel.userName)
            }
            
            Section("Email") {
                Text(viewModel.displayEmail)
            }
            
            Section {
                Button(role: .cancel, action: signOut) {
                    HStack {
                        Spacer()
                        Text("Sign out")
                            .foregroundStyle(.blue)
                        Spacer()
                    }
                }
            }
            Section {
                Button(role: .destructive, action: { presentingConfirmationDialog.toggle() }) {
                    HStack {
                        Spacer()
                        Text("Delete Account")
                            .foregroundStyle(.red)
                        Spacer()
                    }
                }
            }
            Section {
                Button{
                    submitProfile()
                } label: {
                    HStack{
                        Spacer()
                        Text("Confirm changes")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?",
                            isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
            Button("Delete Account", role: .destructive, action: deleteAccount)
            Button("Cancel", role: .cancel, action: { })
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileView()
                .environmentObject(AuthenticationViewModel())
        }
    }
}
