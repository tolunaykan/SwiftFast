import SwiftUI

public struct Carousel<Content: View>: View {
    private var images: [String]
    private let content: (String) -> Content
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    public init(
        images: [String],
        @ViewBuilder content: @escaping (String) -> Content
    ) {
        self.images = images
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let imageWidth = geometry.size.width / 3
            let spacing: CGFloat = 10
            
            HStack(spacing: spacing) {
                ForEach(0..<images.count, id: \.self) { index in
                    content(images[index])
                        .frame(width: imageWidth - spacing, height: geometry.size.height)
                        .clipped()
                }
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(currentIndex) * (imageWidth + spacing))
            .animation(.easeInOut(duration: 1), value: currentIndex)
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % images.count
                }
            }
        }
    }
}

#Preview {
    Carousel(
        images: ["1", "2", "3", "4", "5"]
    ) { imageName in
        Image(uiImage: UIImage(systemName: "star")!)
            .resizable()
            .background(Color.blue)
    }.frame(height: 300)
}

