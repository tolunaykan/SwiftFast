import SwiftUI
import PhotosUI

public struct ImagePicker: UIViewControllerRepresentable {
    @Binding private var selectedImages: [UIImage]
    private var selectionLimit: Int
    private var onDismiss: (() -> Void)?
    
    public init(
        selectedImages: Binding<[UIImage]>,
        selectionLimit: Int = 20,
        onDismiss: (() -> Void)? = nil
    ) {
        self._selectedImages = selectedImages
        self.selectionLimit = selectionLimit
        self.onDismiss = onDismiss
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = selectionLimit
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    public class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        public init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true) {
                self.parent.onDismiss?()
            }
            
            guard !results.isEmpty else { return }
            
            parent.selectedImages.removeAll()
            
            let dispatchGroup = DispatchGroup()
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    dispatchGroup.enter()
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        defer { dispatchGroup.leave() }
                        if let error = error {
                            print("Photo could not be selected: \(error.localizedDescription)")
                            return
                        }
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(image)
                            }
                        }
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
            }
        }
    }
}

struct ImagePicker_Previews: PreviewProvider {
    struct PreviewContainer: View {
        @State private var showPicker = false
        @State private var selectedImages: [UIImage] = []
        
        var body: some View {
            Button(action: {
                showPicker = true
            }) {
                VStack {
                    Image(systemName: "plus.app")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 70, height: 70)
                    if (selectedImages.count > 0) {
                        Text("\(selectedImages.count) Image Selected")
                            .foregroundStyle(.blue)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                    }
                    
                }
            }
            .sheet(isPresented: $showPicker) {
                ImagePicker(
                    selectedImages: $selectedImages,
                    selectionLimit: 2
                )
            }
        }
    }
    
    static var previews: some View {
        PreviewContainer()
    }
}

