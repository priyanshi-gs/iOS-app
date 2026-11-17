import SwiftUI

public struct InitialLaunchSplashView: View {
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.92

    public init() {}

    public var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack {
                Spacer()

                Image("brand_splash_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 290)
                    .padding(.horizontal, 36)
                    .scaleEffect(scale)
                    .opacity(opacity)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                opacity = 1.0
                scale = 1.0
            }
        }
    }
}

#Preview {
    InitialLaunchSplashView()
}
