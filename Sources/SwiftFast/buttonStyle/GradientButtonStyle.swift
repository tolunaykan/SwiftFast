import SwiftUI

public struct GradientButtonStyle: ButtonStyle {
    private var backgroundColor: Color
    let gradientColors = Gradient(colors: [.red, .orange, .yellow, .blue, .purple, .pink])
    @State private var rotationAngle: Double = 0

    public init(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    AngularGradient(
                        gradient: gradientColors,
                        center: .center,
                        angle: .degrees(rotationAngle)
                    ),
                    lineWidth: 17
                )
                .frame(width: 210, height: 30)
                .offset(y: 35)
                .blur(radius: 20)
            
            configuration.label
                .bold()
                .foregroundStyle(.white)
                .frame(width: 280, height: 60)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: 20))
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                AngularGradient(
                                    gradient: gradientColors,
                                    center: .center,
                                    angle: .degrees(rotationAngle)
                                ),
                                lineWidth: 3
                            )
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 4)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [backgroundColor, backgroundColor, .clear]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                }
        }
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .animation(.spring(), value: configuration.isPressed)
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}
