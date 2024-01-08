//
//  ProfileSetUpView.swift
//  Moment
//
//  Created by Zachary Tao on 12/22/23.
//

import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var username: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @Environment(\.dismiss) var dismiss
    private func submitProfile() {
            Task {
                //await viewModel.completeProfileSetup(username: username, photo: selectedImage)
                dismiss() 
            }
        }

    
    private var isFormReady: Bool {
        !username.isEmpty && selectedImage != nil
    }
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
            
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
            }
            
            Button("Upload Photo") {
                isImagePickerPresented = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Submit") {
                submitProfile()
            }
            .disabled(!isFormReady) // Disable the button if form is not ready
            .padding()
            .background(isFormReady ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        .padding()
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView()
            .environmentObject(AuthenticationViewModel())
    }
}
