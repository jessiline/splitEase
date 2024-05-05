import SwiftUI
import VisionKit
import Vision
import AVFoundation

struct MainPageView: View {
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isShowingCamera = false
    @State private var recognizedText: String?
    
    // Variabel-variabel untuk inputBillView
    @State private var subtotal: String = ""
    @State private var serviceCharge: String = ""
    @State private var tax: String = ""
    @State private var discountBawah: String = ""
    @State private var totalAmount: String = ""
    @State private var itemInputs: [ItemInput] = [ItemInput()]

    
    var body: some View {
        NavigationView{
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 213, height: 143)
                    .foregroundStyle(.tint)
                Image("logoText")
                    .padding()
                VStack(spacing: 0.5) {
                    Button(action: {
                        isShowingCamera = true
                    }) {
                        ZStack(alignment : .leading){
                            UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20)
                                .fill(Color(red: 206/255, green: 222/255, blue: 204/255))
                            HStack() {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "camera")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.black)
                                }
                                .padding(.leading)
                                VStack(alignment : .leading){
                                    Text("Scan")
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                    Text("Scan your bill here")
                                        .font(.system(size: 12))
                                        .foregroundColor(.black)
                                    
                                }
                                .padding(.leading, 5)
                                
                            }
                        }
                        .frame(width: 286, height: 63)
                    }
                    .sheet(isPresented: $isShowingCamera) {
                        CameraViewController(isShowingCamera: $isShowingCamera, recognizedText: $recognizedText)
                    }
                    
                    Button(action: {
                        isShowingImagePicker = true
                    }) {
                        ZStack(alignment : .leading){
                            UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
                                .fill(Color(red: 206/255, green: 222/255, blue: 204/255))
                                .frame(width: 286, height: 63)
                            
                            HStack() {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "photo.on.rectangle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20) // Adjust the size of the camera icon as needed
                                        .foregroundColor(.black) // Change the color of the camera icon as needed
                                }
                                .padding(.leading)
                                VStack(alignment : .leading){
                                    Text("Photo Library")
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                    Text("Scan text from your photo")
                                        .font(.system(size: 12))
                                        .foregroundColor(.black)
                                    
                                }
                                .padding(.leading, 5)
                                
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingImagePicker, onDismiss: processImage) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                }
                
                // manual bill
                ZStack(alignment : .leading){
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous)
                        .fill(Color(red: 206/255, green: 222/255, blue: 204/255, opacity: 1.0))
                        .frame(width: 286, height: 63)
                    HStack() {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                        .padding(.leading)
                        NavigationLink(destination: InputBillView(itemInputs: $itemInputs, subtotal: $subtotal, serviceCharge: $serviceCharge, tax: $tax, discountBawah: $discountBawah, totalAmount: $totalAmount).navigationBarTitle("Input Bill Details")) {
                            VStack(alignment : .leading){
                                Text("Input Bills")
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                                Text("Input your bill manually")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                                
                            }

                            .padding(.leading, 5)
                        }
                        
                    }
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 255/255, green: 253/255, blue: 231/255))
        }
        .navigationBarBackButtonHidden(true)
    }
    func processImage() {
        guard let selectedImage = selectedImage else {
            print("Selected image is nil.")
            return
        }
        
        guard let ciImage = CIImage(image: selectedImage) else {
            print("Failed to create CIImage from selected image.")
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            let recognizedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            print(recognizedText)
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            print("Error performing text recognition: \(error)")
        }
        
    }
}

struct CameraViewController: UIViewControllerRepresentable {
    @Binding var isShowingCamera: Bool
    @Binding var recognizedText: String?
    func makeUIViewController(context: Context) -> UIViewController {
        let cameraViewController = UIImagePickerController()
        cameraViewController.delegate = context.coordinator
        cameraViewController.sourceType = .camera
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraViewController
        
        init(parent: CameraViewController) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                processImage(image)
            }
            parent.isShowingCamera = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShowingCamera = false
        }
        
        func processImage(_ image: UIImage) {
            guard let ciImage = CIImage(image: image) else {
                print("Failed to create CIImage from captured image.")
                return
            }
            
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    print("Text recognition failed.")
                    return
                }
                
                let recognizedText = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: "\n")
                
                print("Recognized Text:")
                print(recognizedText)
                self.parent.recognizedText = recognizedText
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([request])
            } catch {
                print("Error performing text recognition: \(error)")
            }
        }
    }
}
    

#if DEBUG
struct mainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}
#endif
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
