//
//  ContentView.swift
//  Moment
//
//  Created by Zachary Tao on 12/22/23.
//

import SwiftUI

//@AppStorage(hasCurrentSessionKey) var hasCurrentSession = false

var body: some View {
    //    Group {
    //        if hasCurrentSession {
    //            MainView()
    //        } else {
    //            AuthenticationView()
    //        }
    //    }
    //    .onAppear {
    //        if hasCurrentSession {
    //            SessionManager.shared.loadUser()
    //        }
    //    }
    
    NavigationView {
        AuthenticatedView {
            
        } content: {
            ConversationView()
            Spacer()
        }
    }
}
