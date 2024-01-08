//
//  SwiftUIView.swift
//  Moment
//
//  Created by Zachary Tao on 12/18/23.
//

import SwiftUI
import CoreLocation

struct SendPageView: View {
    
    @EnvironmentObject var model : CameraModel
    @State private var caption: String = ""
    @Binding var path : [Int]
    @State private var locationString: String = "Location: Loading..."
    @Environment(\.presentationMode) var presentationMode
    @State var showCameraAgain:Bool = false


    
    
    var capturedPhotoThumbnail: some View {
        Group {
            
            if let image = model.thumbnailImage {
                VStack{
                    HStack{
                        Spacer()
                        Text("\(formatDate(model.photo.timestamp))")
                            .font (.system(size: 18, weight: .bold))
                            
                        Spacer()
                        locationView(model.photo.location)
                            .font (.system(size: 18, weight: .bold))
                        Spacer()
                        
                    }
                    .padding()
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 350, height: 450)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                }
            } else {
                ProgressView()
            }
        }
    }
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            ScrollView{
                HStack{
                    Spacer()
                    
//                    
//                    NavigationLink(destination: CameraView(path: $path), isActive: $showCameraAgain) {
//                        Button{
//                            path.append(3)
//                            showCameraAgain = true
//                        }label: {
//                            Image(systemName: "chevron.backward")
//                        }.navigationTitle("")
//                            
//                    }
                    
                    
                    Button{
                        path = []
                    }label:{
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .font(Font.system(size: 5, weight:.bold))
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            
                    }
                    
                    Button{
                        model.photo.caption = caption
                        model.savePhoto(photo: model.photo)
                        path = []
                    }label: {
                        HStack{
                            Spacer()
                            Text("Send")
                                .foregroundColor(.black)
                                .font (.system(size: 30, weight: .heavy))
                            Image(systemName: "chevron.forward")
                                .resizable()
                                .scaledToFit()
                                .font(Font.system(size: 20, weight: .bold))
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                    }
                }.padding()
                
                
                capturedPhotoThumbnail
                
                TextField("Add a caption...", text: $caption)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 22))
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                
                Spacer()
                
                
            }.navigationBarHidden(true)
//                .gesture(DragGesture().onEnded { value in
//                    // Detect swipe left
//                    if value.translation.width > 0 {
//                        // Activate link
//                        self.showCameraAgain = true
//                    }
//                })
        }
    }
}

struct SendPageView_Previews: PreviewProvider {
    @State static var dummyPath = [Int]()

       static var previews: some View {
           // Create a dummy UIImage with a gray color
           let grayImage = UIImage(color: .gray, size: CGSize(width: 100, height: 100))!
           let imageData = grayImage.jpegData(compressionQuality: 1.0)!

           // Create a dummy photo with the gray image
           let dummyPhoto = Photo(
               id: "dummyID",
               originalData: imageData,
               timestamp: Date(),
               location: CLLocation(latitude: 37.7749, longitude: -122.4194)
           )

           // Create and configure the dummy CameraModel
           let dummyModel = CameraModel()
           dummyModel.photo = dummyPhoto
           dummyModel.thumbnailImage = grayImage

           return SendPageView(path: $dummyPath)
               .environmentObject(dummyModel)
       }
}
// Extension to create a UIImage from a UIColor
extension UIImage {
    convenience init?(color: UIColor, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
extension SendPageView {
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
}

extension SendPageView {
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Time" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
    
    @ViewBuilder
    func locationView(_ location: CLLocation?) -> some View {
            if let location = location {
                Text(locationString)
                    .onAppear {
                        getPlacemark(for: location) { placemark in
                            if let placemark = placemark, let city = placemark.locality, let district = placemark.subLocality {
                                self.locationString = "\(city), \(district)"
                            } else {
                                self.locationString = "Location: Unknown"
                            }
                        }
                    }
            } else {
                Text("Location: Unknown")
            }
        }
}


