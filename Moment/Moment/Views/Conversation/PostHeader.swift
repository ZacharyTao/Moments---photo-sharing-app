//
//  PostHeader.swift
//  Moment
//
//  Created by Zachary Tao on 12/15/23.
//

import SwiftUI

struct PostHeader: View {
    var body: some View {
        VStack{
            HStack{
                Button{
                    
                } label: {
                    Image("Avatar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading){
                    Text("ZacharyTao")
                        .font(.system(size:13, weight: .bold))
                        .foregroundColor(.black)
                    Text("1:57PM Sunday")
                        .font(.system(size:14, weight: .regular))
                        .foregroundColor(.gray)
                }
                .padding(.leading, 3)
                Spacer()
                
//                Button{
//
//                }label: {
//                     Image(systemName: "ellipsis")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 24, height: 20)
//                        .foregroundColor(.gray)
//                }
            }
            
        }
        .padding(.horizontal, 6)
    }
}

struct PostHeader_Previews: PreviewProvider {
    static var previews: some View {
        PostHeader()
    }
}
