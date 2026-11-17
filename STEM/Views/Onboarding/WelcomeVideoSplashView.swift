import SwiftUI
import AVKit

public struct WelcomeVideoSplashView: View {
    public var onFinished: () -> Void

    @State private var player: AVPlayer?
    @State private var hasCompleted: Bool = false

    public init(onFinished: @escaping () -> Void) {
        self.onFinished = onFinished
    }

    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            if let player = player {
                CustomVideoPlayerView(player: player)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }

    private func setupPlayer() {
        if let url = Bundle.main.url(forResource: "welcome_video", withExtension: "mp4") {
            startPlayback(with: url)
            return
        }
        let fallbackPath = "/Users/ratnamsmac/Documents/Projects/LabLearn/STEM/welcome_video.mp4"
        if FileManager.default.fileExists(atPath: fallbackPath) {
            let localUrl = URL(fileURLWithPath: fallbackPath)
            startPlayback(with: localUrl)
        } else {
            finishOnce()
        }
    }

    private func startPlayback(with url: URL) {
        let playerItem = AVPlayerItem(url: url)
        let avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer.actionAtItemEnd = .none
        self.player = avPlayer
        avPlayer.play()

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            finishOnce()
        }

        // Safety fallback timer matching the video duration (~4.0s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.1) {
            finishOnce()
        }
    }

    private func finishOnce() {
        guard !hasCompleted else { return }
        hasCompleted = true
        player?.pause()
        onFinished()
    }
}

// Native AVPlayerLayer wrapper with .resizeAspectFill for borderless cinematic playback
struct CustomVideoPlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        view.playerLayer.player = player
        view.playerLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        uiView.playerLayer.player = player
    }
}

class PlayerUIView: UIView {
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
