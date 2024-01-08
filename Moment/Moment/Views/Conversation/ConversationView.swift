//
//  ContentView.swift
//  Moment
//
//  Created by Zachary Tao on 12/15/23.
//

import SwiftUI

struct ConversationView: View {
    @State private var showCamera = false
    @State private var path : [Int] = []
    @StateObject var viewModel = ConversationViewModel()
    
    
    var body: some View {
        NavigationStack(path: $path){
            
            VStack{
                
                ConversationHeader(showCamera: $showCamera, path: $path)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack (spacing: 30){
                        ForEach(viewModel.photoData, id: \.metadata.id) { data in
                            VStack {
                                PostHeader(profilePicture: Image("Avatar"), userName: "zacharytao", data: data)
                                Image(uiImage: data.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 350, height: 450)
                                    .cornerRadius (25)
                                if let caption = data.metadata.caption {
                                    Text(caption)               
                                        .font(.system(size:18, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                                
                            }
                        }
                        
                    }
                }.onAppear{
                    viewModel.refreshPhotos()
                    viewModel.deleteOldPhotos()
                    
                }
                
            }
            .padding()
            
        }.accentColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}

