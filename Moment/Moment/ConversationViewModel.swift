//
//  ConversationViewModel.swift
//  Moment
//
//  Created by Zachary Tao on 12/20/23.
//
import Foundation
import UIKit

class ConversationViewModel: ObservableObject {
    @Published var photoData: [(image: UIImage, metadata: PhotoMetadata)] = []

    init() {
        loadPhotos()
        
//        let testImage = UIImage(color: .gray, size: CGSize(width: 100, height: 100))! 
//        let testMetadata = PhotoMetadata(id: "test", timestamp: Date(), latitude: 37.7749, longitude: -122.4194)
//        self.photoData = [(image: testImage, metadata: testMetadata)]
    }

    func loadPhotos() {
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let currentTime = Date()

            do {
                // Get all file URLs in the documents directory
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
                
                // Filter out only metadata JSON files
                let jsonURLs = fileURLs.filter { $0.pathExtension == "json" }

                var loadedPhotoData: [(image: UIImage, metadata: PhotoMetadata)] = []

                for jsonURL in jsonURLs {
                    let imageDataURL = jsonURL.deletingPathExtension()
                    
                    
                    if let metadataData = try? Data(contentsOf: jsonURL),
                       let metadata = try? JSONDecoder().decode(PhotoMetadata.self, from: metadataData),
                       let imageData = try? Data(contentsOf: imageDataURL),
                       let image = UIImage(data: imageData) {
                        loadedPhotoData.append((image: image, metadata: metadata))
                    }
                }


                // Sort the loaded photo data by timestamp
                self.photoData = loadedPhotoData.sorted(by: { (data1, data2) -> Bool in
                    let date1 = data1.metadata.timestamp ?? Date.distantPast
                    let date2 = data2.metadata.timestamp ?? Date.distantPast
                    return date1 > date2
                })

            } catch {
                print("Error loading photos: \(error.localizedDescription)")
            }
        }
    
    func refreshPhotos() {
            photoData.removeAll()
            loadPhotos()
        }
    
    func deleteOldPhotos() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let currentTime = Date()

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            let jsonURLs = fileURLs.filter { $0.pathExtension == "json" }

            for jsonURL in jsonURLs {
                if let metadataData = try? Data(contentsOf: jsonURL),
                   let metadata = try? JSONDecoder().decode(PhotoMetadata.self, from: metadataData),
                   let timestamp = metadata.timestamp,
                   currentTime.timeIntervalSince(timestamp) > 24 * 60 * 60 {
                    // Delete the metadata file
                    try fileManager.removeItem(at: jsonURL)
                    // Delete the corresponding image file
                    let imageDataURL = jsonURL.deletingPathExtension().appendingPathExtension("jpeg")
                    try fileManager.removeItem(at: imageDataURL)
                }
            }
        } catch {
            print("Error deleting old photos: \(error.localizedDescription)")
        }
    }
    
    
}
