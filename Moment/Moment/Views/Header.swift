//
//  Header.swift
//  Moment
//
//  Created by Zachary Tao on 12/15/23.
//

import SwiftUI

struct Header: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var presentingProfileScreen = false

    var body: some View {
        
        VStack(spacing: 30){
            HStack{
                Button {
                    presentingProfileScreen.toggle()
                } label: {
                    Image ("Avatar")
                        .resizable ()
                        .scaledToFill()
                        .frame (width: 26, height: 26)
                        .clipShape(Circle())
                }.sheet(isPresented: $presentingProfileScreen) {
                    NavigationView {
                        UserProfileView()
                            .environmentObject(viewModel)
                    }
                }
                Spacer()
                Text("Moment")
                    .font (.system(size: 26, weight: .bold))
                Spacer()
                Button {
                } label: {
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                }
            }
            .foregroundColor(.black)
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}

