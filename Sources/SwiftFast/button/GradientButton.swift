import SwiftUI

public struct GradientButton: View {
    private var title: String
    private var backgroundColor: Color
    private var action: () -> Void
    
    
    public init(
        title: String,
        backgroundColor: Color = Color.black,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        Button(action: {
            self.action()
        }) {
            Text(self.title)
        }
        .buttonStyle(
            GradientButtonStyle(
                backgroundColor: backgroundColor
            )
        )
    }
}

#Preview {
    GradientButton(
        title: "SwiftFast",
        backgroundColor: Color.pink
    ) {
        print("Button tapped")
    }
}
