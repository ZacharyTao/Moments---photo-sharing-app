
//
//  CameraViewModel.swift
//  SwiftCamera
//
//  Created by Zachary Tao on 12/17/23.
//

import Foundation

import Combine
import AVFoundation
import SwiftUI
import CoreLocation

final class CameraModel: ObservableObject {
    private let service = CameraService()
    
    @Published var photo: Photo!
    
    @Published var showAlertError = false
    
    @Published var isFlashOn = false
    
    @Published var willCapturePhoto = false
    
    var alertError: AlertError!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var thumbnailImage: UIImage?
    
    init() {
        self.session = service.session
        
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
        
        
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else {
                self?.thumbnailImage = nil
                return
            }
            self?.photo = pic
            self?.thumbnailImage = pic.image // Update the thumbnail image
        }
        .store(in: &self.subscriptions)
        
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func capturePhoto() {
        service.capturePhoto()
    }
    
    func flipCamera() {
        service.changeCamera()
    }
    
    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }
    
    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
    }
    
    func savePhoto(photo: Photo){
        service.savePhoto(photo: photo)
    }
    
    
}

struct PhotoMetadata: Codable {
    var id: String
    var timestamp: Date?
    var latitude: Double?
    var longitude: Double?
    var caption: String?

    // Custom initializer to create PhotoMetadata from a Photo instance
    init(from photo: Photo) {
        self.id = photo.id
        self.timestamp = photo.timestamp
        self.latitude = photo.location?.coordinate.latitude
        self.longitude = photo.location?.coordinate.longitude
    }
    
    init(id: String, timestamp: Date?, latitude: Double?, longitude: Double?, caption: String?) {
            self.id = id
            self.timestamp = timestamp
            self.latitude = latitude
            self.longitude = longitude
        self.caption = caption
        }
    
    // Computed property to get CLLocation from latitude and longitude
    var location: CLLocation? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocation(latitude: lat, longitude: lon)
    }

    // Implement Decodable manually if needed
    // ...
}
