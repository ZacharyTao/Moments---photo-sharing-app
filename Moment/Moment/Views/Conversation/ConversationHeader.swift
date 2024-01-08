//
//  ConversationHeader.swift
//  Moment
//
//  Created by Zachary Tao on 12/16/23.
//

import SwiftUI
import FirebaseAuth

struct ConversationHeader: View {
    @Binding var showCamera: Bool
    @Binding var path: [Int]
    private var profilePicture : Image
    private var userName: Text
    @State var presentingProfileScreen = false
    @EnvironmentObject var viewModel: AuthenticationViewModel
    let user = Auth.auth().currentUser


    
    var body: some View {
        VStack{
            HStack{
                
                Button {
                    presentingProfileScreen.toggle()
                } label: {
//                    if let url = user?.photoURL {
//                                AsyncImage(url: url) { image in
//                                    image
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 36, height: 36)
//                                        .clipShape(Circle())
//                                } placeholder: {
//                                    Image(systemName: "person.circle.fill")
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 36, height: 36)
//                                        .clipShape(Circle())
//                                }
//                            } else {
//                                Image(systemName: "person.circle.fill")
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 36, height: 36)
//                                    .clipShape(Circle())
//                            }
                    if let selectedImage = viewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                            .clipped()
                            .padding(4)
                    }else{
                        Image("Avatar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    }
                }.sheet(isPresented: $presentingProfileScreen) {
                    NavigationView {
                        UserProfileView()
                            .environmentObject(viewModel)
                    }
                }
                Spacer()
                
                VStack(alignment: .leading){
                    Text("Moments")
                        .font(.system(size:30, weight: .bold))
                        .foregroundColor(.black)
                    
                }
                .padding(.leading, 3)
                Spacer()

                NavigationLink(destination: CameraView(path: $path), isActive: $showCamera) {
                    Button{
                        path.append(1)
                        showCamera = true
                    }label: {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    }
                }
                
            }
        }.padding(.horizontal)
    }
}

struct ConversationHeader_Previews: PreviewProvider {
    static var previews: some View {
        // Mock data for preview
        ConversationHeader(
            showCamera: .constant(false),
            path: .constant([])
        )
    }
}

extension ConversationHeader {
    init(showCamera: Binding<Bool>, path: Binding<[Int]>) {
        self._showCamera = showCamera
        self._path = path
        self.profilePicture = Image("Sydney") // Replace "ProfilePicture" with a placeholder or actual image asset name
        self.userName = Text("imsydneylin")
    }
}
