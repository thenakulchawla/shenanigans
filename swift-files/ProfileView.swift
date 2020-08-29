//
//  ProfileViewController.swift
//  reeal-primitive
//
//  Created by Nakul Chawla on 2/19/20.
//  Copyright © 2020 Nakul Chawla. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var session: FirebaseSession
    @State var username: String = ""
    @State private var photoUrl = ""
    
   
    
    var body: some View {
        
        
       

        VStack {
            NavigationView {
                VStack {
                    ImageWithURL(imageUrl: $photoUrl)
                    HStack {
                        Text(self.username)
                        NavigationLink(destination: FriendsListView()) {
                            Text(String(globalUser.friendsCount))
                        }
                        .navigationBarTitle("Profile")
                        .listStyle(GroupedListStyle())
                    }
                }.onAppear(perform: loadData)
            }
            
            List {
                //TODO: Change this into the count of userReels
                ForEach(0..<4) { _ in
                    
                    HStack(spacing: 0) {
                        // Second loop for number of items in each row
                        ForEach(0..<3) { _ in
                            VideoPlayerContainerProfileView(url: postUrl1)
                                .frame(idealWidth: .infinity, idealHeight: (UIScreen.main.bounds.width/3.0)*1.5)
//                                .frame(width: UIScreen.main.bounds.width/3.0 , height: (UIScreen.main.bounds.width/3.0)*1.5)
                                .border(Color.red, width: 2)
                            
                        }
                    }
                    
                }
            }
        }
        

        
    }
        
    
    //MARK:- Functions
    func loadData() {
        self.username = globalUser.username!
        self.photoUrl = globalUser.photoUrl!
        print($photoUrl)
        globalUser.getFriends() { isSuccess in
            print("friendsLoaded")
        }
    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

