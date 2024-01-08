//
//  ContentView.swift
//  Moment
//
//  Created by Zachary Tao on 12/22/23.
//

import SwiftUI

//@AppStorage(hasCurrentSessionKey) var hasCurrentSession = false
struct ContentView : View{
    var body: some View {
        
        NavigationView {
            AuthenticatedView {
                
            } content: {
                //MainView()
                ConversationView()
            }
        }
    }
}
