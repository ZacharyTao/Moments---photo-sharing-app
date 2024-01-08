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
        saveFirstImageAndCaptionToSharedContainer()
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
                    if let timestamp = metadata.timestamp, currentTime.timeIntervalSince(timestamp) > 24 * 60 * 60 {
                        // Photo is older than 24 hours, delete it
                        try fileManager.removeItem(at: jsonURL)
                        try fileManager.removeItem(at: imageDataURL)
                    }
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
        saveFirstImageAndCaptionToSharedContainer()
    }
    
    func saveFirstImageAndCaptionToSharedContainer() {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.edu.vanderbilt.zachtao.Moment") else { return }
        let sharedImageURL = containerURL.appendingPathComponent("sharedImage.jpg")
        let sharedCaptionURL = containerURL.appendingPathComponent("sharedCaption.txt")

        if let firstPhoto = photoData.first {
            if let imageData = firstPhoto.image.jpegData(compressionQuality: 1.0) {
                try? imageData.write(to: sharedImageURL)
            }

            if let caption = firstPhoto.metadata.caption {
                try? caption.write(to: sharedCaptionURL, atomically: true, encoding: .utf8)
            }
        }
    }
    
}
