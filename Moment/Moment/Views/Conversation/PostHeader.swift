//
//  PostHeader.swift
//  Moment
//
//  Created by Zachary Tao on 12/15/23.
//

import SwiftUI
import CoreLocation
import FirebaseAuth

struct PostHeader: View {
    private var profilePicture: Image = Image("Avatar") // Default value
    private var userName: String = "zacharywtao" // Default value
    private var data: (image: UIImage, metadata: PhotoMetadata) // No default value
    @EnvironmentObject var model: ConversationViewModel
    
    @State private var locationString: String = ""
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    let user = Auth.auth().currentUser
    
    // Keep only the custom initializer if needed for specific cases
    init(profilePicture: Image, userName: String, data: (image: UIImage, metadata: PhotoMetadata)) {
        self.profilePicture = profilePicture
        self.userName = userName
        self.data = data
    }
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    
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
                }
                HStack{
                    VStack(alignment: .leading){
//                        Text(user?.displayName ?? "User")
                        Text(viewModel.userName)
                            .font(.system(size:13, weight: .bold))
                            .foregroundColor(.black)
                        HStack{
                            if let timestamp = data.metadata.timestamp {
                                Text("\(formatDate(timestamp))")
                                    .font(.system(size:14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            
                            
                            if let location = data.metadata.location {
                                if locationString != ""{
                                    Text("·")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                                
                                locationView(location)
                                    .font(.system(size:14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            
                            
                            
                        }
                    }
                    Spacer()
                    Menu{
                        Button{
                        }label: {
                            Label("Save Photo", systemImage: "square.and.arrow.down")
                        }
                        Button (role: .destructive){
                        } label: {
                            
                            Label("Delete Photo", systemImage: "trash")
                            
                        }
                        
                    }label: {
                        Button{
                        }label: {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                    }
                }
                
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
        .padding(.horizontal, 10)
    }
}

struct PostHeader_Previews: PreviewProvider {
    static var previews: some View {
        let mockImage = UIImage(systemName: "post") ?? UIImage()
        let mockMetadata = PhotoMetadata(id: "1", timestamp: Date(), latitude: 37.7749, longitude: -122.4194, caption: "Sample Caption")
        let data = (image: mockImage, metadata: mockMetadata)
        
        PostHeader(profilePicture: Image("Avatar"), userName: "zacharywtao", data: data)
    }
}

extension PostHeader {
    
    func getPlacemark(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Error in reverseGeocodeLocation: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            completion(placemarks?.first)
        }
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Time" }
        let currentTime = Date()
        
        let calendar = Calendar.current
        let timeDifference = currentTime.timeIntervalSince(date)
        let isJustNow = timeDifference < 2 * 60 // Within 2 minutes
        let isToday = calendar.isDateInToday(date)
        
        if isJustNow {
            // If the photo was taken within the last two minutes
            return "Just now"
        } else if timeDifference < 60 * 60 {
            // If the photo was taken within the last hour but more than two minutes ago
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute]
            formatter.unitsStyle = .full
            formatter.maximumUnitCount = 1
            
            return (formatter.string(from: date, to: currentTime) ?? "") + " ago"
        } else if isToday {
            // If the photo was taken today, but more than an hour ago
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .none
            return formatter.string(from: date)
        } else {
            // If the photo was not taken today
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a EEEE" // e.g., "10:39 PM Sunday"
            return formatter.string(from: date)
        }
    }
    
    
    
    func abbreviatedStreetName(_ street: String, maxLength: Int = 20) -> String {
        if street.count > maxLength {
            let index = street.index(street.startIndex, offsetBy: maxLength)
            return street[..<index] + "..."
        } else {
            return street
        }
    }
    
    @ViewBuilder
    func locationView(_ location: CLLocation?) -> some View {
        if let location = location {
            Text(locationString)
                .onAppear {
                    getPlacemark(for: location) { placemark in
                        if let placemark = placemark, let city = placemark.locality, let district = placemark.subLocality {
                            self.locationString = "\(district), \(city)"
                        } else {
                            self.locationString = ""
                        }
                    }
                }
        } else {
            Text("Location: Unknown")
        }
    }
    
    func formatLocation(_ placemark: CLPlacemark) -> String {
        let neighborhood = placemark.subLocality ?? ""
        let city = placemark.locality ?? ""
        return "\(neighborhood), \(city)"
    }
}

