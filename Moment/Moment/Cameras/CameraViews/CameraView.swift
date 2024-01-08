//
//  CameraView.swift
//  Moment
//
//  Created by Zachary Tao on 12/18/23.
//


import SwiftUI

struct CameraView: View {
    @StateObject var model = CameraModel()
    @State var currentZoomFactor: CGFloat = 1.0
    @Binding var path: [Int]
    @State var showSend:Bool = false

    
    var captureButton: some View {
        
        Button(action: {
            model.capturePhoto()
            showSend = true
            path.append(2)
        }, label: {
            Circle()
                .stroke(Color.black, lineWidth: 5)
                .foregroundColor(.white)
                .frame(width: 70, height: 70, alignment: .center)
            
        })
    }
    
    
    var flipCameraButton: some View {
        Button(action: {
            model.flipCamera()
        }, label: {
            Image(systemName: "arrow.triangle.2.circlepath.camera")
                .foregroundColor(.black)
                .font(.system(size: 30, weight: .medium, design: .default))
        })
    }
    
    var body: some View {
        
        GeometryReader { reader in
            
            VStack {
                HStack{
                    Button{
                        path = []
                    }label:{
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .font(Font.system(size: 5, weight:.bold))
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                        
                    }
                    Spacer()
                }.padding()
                
                Spacer()
                
                CameraPreview(session: model.session)
                    .gesture(
                        DragGesture().onChanged({ (val) in
                            //  Only accept vertical drag
                            if abs(val.translation.height) > abs(val.translation.width) {
                                //  Get the percentage of vertical screen space covered by drag
                                let percentage: CGFloat = -(val.translation.height / reader.size.height)
                                //  Calculate new zoom factor
                                let calc = currentZoomFactor + percentage
                                //  Limit zoom factor to a maximum of 5x and a minimum of 1x
                                let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                //  Store the newly calculated zoom factor
                                currentZoomFactor = zoomFactor
                                //  Sets the zoom factor to the capture device session
                                model.zoom(with: zoomFactor)
                            }
                        })
                    )
                    .onAppear {
                        model.configure()
                    }
                    .alert(isPresented: $model.showAlertError, content: {
                        Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                            model.alertError.primaryAction?()
                        }))
                    })
                    .frame(width: 350, height: 465)
                    .overlay(
                        Group {
                            if model.willCapturePhoto {
                                Color.black
                            }
                        }
                    )
                    .cornerRadius(25)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        //model.switchFlash()
                    }, label: {
                        Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 29, weight: .medium, design: .default))
                    })
                    .accentColor(model.isFlashOn ? .yellow : .black)
                    
                    
                    Spacer()
                    NavigationLink(destination: SendPageView(path: $path).environmentObject(model), isActive: $showSend) {
                        captureButton
                    }.navigationBarHidden(true)
                    
                    Spacer()
                    
                    flipCameraButton
                    Spacer()
                    
                }
                Spacer()
                

                
            }
            
            
            
        }
        
    }
    
}


struct CameraView_Previews: PreviewProvider {
    @State static var dummyPath = [Int]()

        static var previews: some View {
            CameraView(model: CameraModel(), path: $dummyPath)
        }
}
