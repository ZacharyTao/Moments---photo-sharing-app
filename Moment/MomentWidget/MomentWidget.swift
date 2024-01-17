//
//  MomentWidget.swift
//  MomentWidget
//
//  Created by Zachary Tao on 12/23/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: UIImage(), caption: "String")
        
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let (image, caption) = fetchFirstImageAndCaption()
        let entry = SimpleEntry(date: Date(), image: image, caption: caption)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let (image, caption) = fetchFirstImageAndCaption()
            let entry = SimpleEntry(date: Date(), image: image, caption: caption)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: UIImage
    let caption: String
}
struct MomentWidgetEntryView : View {

    var entry: Provider.Entry
    
    var body: some View {
        ZStack(alignment: .bottomLeading){
            Image(uiImage: entry.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .cornerRadius(10)
              
            Text(entry.caption)
                .font(.system(size:20, weight: .bold))
                .foregroundColor(.white) // Choose a suitable text color
                .padding(.bottom, 10)
                .padding(.leading, 10)
        }
        
    }
}

func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
    guard let cgImage = image.cgImage,
          let croppedCgImage = cgImage.cropping(to: rect) else {
        return nil
    }
    return UIImage(cgImage: croppedCgImage)
}

struct MomentWidget: Widget {
    let kind: String = "MomentWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MomentWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MomentWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

func fetchFirstImageAndCaption() -> (UIImage, String) {
    guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.edu.vanderbilt.zachtao.Moment") else { return (UIImage(), "") }
    let sharedImageURL = containerURL.appendingPathComponent("sharedImage.jpg")
    let sharedCaptionURL = containerURL.appendingPathComponent("sharedCaption.txt")

    var image = UIImage()
    var caption = ""
    if let imageData = try? Data(contentsOf: sharedImageURL),
       let originalImage = UIImage(data: imageData) {
        // Resize the image to a suitable width for the widget
        let resizedWidth: CGFloat = 600 // Set this value to what suits your widget's layout
        image = originalImage.resized(toWidth: resizedWidth) ?? UIImage()
    }

    if let loadedCaption = try? String(contentsOf: sharedCaptionURL, encoding: .utf8) {
        caption = loadedCaption
    }

    return (image, caption)
}


func resizeImage(_ image: UIImage, toMaxWidth width: CGFloat, maxHeight height: CGFloat) -> UIImage {
    let size = image.size
    let widthRatio  = width  / size.width
    let heightRatio = height / size.height
    let ratio = min(widthRatio, heightRatio)
    let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage ?? image
}

extension UIImage {
  func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
    let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
    let format = imageRendererFormat
    format.opaque = isOpaque
    return UIGraphicsImageRenderer(size: canvas, format: format).image {
      _ in draw(in: CGRect(origin: .zero, size: canvas))
    }
  }
}
