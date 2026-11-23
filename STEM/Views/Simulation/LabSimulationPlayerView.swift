import SwiftUI
import WebKit

public struct LabSimulationPlayerView: View {
    public let lab: Lab
    public var onBack: (() -> Void)?
    public var onCompleteExperiment: (() -> Void)?

    @State private var simulationURL: URL? = nil
    @State private var isLoading: Bool = true
    @State private var reloadKey: Int = 0
    @State private var isFullscreen: Bool = false

    public init(
        lab: Lab,
        onBack: (() -> Void)? = nil,
        onCompleteExperiment: (() -> Void)? = nil
    ) {
        self.lab = lab
        self.onBack = onBack
        self.onCompleteExperiment = onCompleteExperiment
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Wave Header (Hidden when in Fullscreen)
            if !isFullscreen {
                WaveHeader(
                    title: lab.code,
                    showBackButton: true,
                    onBack: onBack
                )

                // Step Tracker Bar (✓ Study -> ● Experiment -> ○ Test -> ○ Result)
                SimulationStepTracker(currentStep: .experiment)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
            }

            // MARK: - Experiment Studio Shell
            VStack(spacing: 10) {
                // Top Studio Control Bar
                HStack(alignment: .center) {
                    HStack(spacing: 8) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(hex: "0B2036"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(Color(hex: "22D3EE"), lineWidth: 1)
                                )
                                .frame(width: 32, height: 32)

                            Image(systemName: "flask.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "22D3EE"))
                        }

                        VStack(alignment: .leading, spacing: 1) {
                            Text("Virtual Experiment Studio")
                                .font(.system(size: 14, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            Text(lab.title)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(Color(hex: "94A3B8"))
                                .lineLimit(1)
                        }
                    }

                    Spacer()

                    // Action buttons
                    HStack(spacing: 8) {
                        // Reload
                        Button(action: { reloadKey += 1 }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(hex: "DBE4F7"))
                                .padding(8)
                                .background(Color(hex: "101A33"), in: RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "243255"), lineWidth: 1)
                                )
                        }

                        // Fullscreen
                        Button(action: { isFullscreen.toggle() }) {
                            Image(systemName: isFullscreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(hex: "DBE4F7"))
                                .padding(8)
                                .background(Color(hex: "101A33"), in: RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "243255"), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.top, isFullscreen ? 12 : 4)

                // Simulation Interactive Viewport
                ZStack(alignment: .topTrailing) {
                    if let url = simulationURL {
                        SimulationWebView(url: url)
                            .id(reloadKey)
                            .clipShape(RoundedRectangle(cornerRadius: isFullscreen ? 0 : 14, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: isFullscreen ? 0 : 14, style: .continuous)
                                    .stroke(Color(hex: "17264A"), lineWidth: isFullscreen ? 0 : 1)
                            )

                        // Floating exit fullscreen button when expanded
                        if isFullscreen {
                            Button(action: { isFullscreen = false }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                                        .font(.system(size: 11, weight: .bold))
                                    Text("Exit Fullscreen")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.75), in: Capsule())
                                .overlay(Capsule().stroke(Color(hex: "22D3EE"), lineWidth: 1))
                                .shadow(color: Color.black.opacity(0.5), radius: 6)
                            }
                            .padding(.trailing, 14)
                            .padding(.top, 14)
                        }
                    } else if isLoading {
                        VStack(spacing: 14) {
                            ProgressView()
                                .tint(Color(hex: "22D3EE"))
                                .scaleEffect(1.2)
                            Text("Loading Simulation Canvas...")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(hex: "8A96B3"))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(hex: "030817"))
                    } else {
                        // Clean virtual experiment studio canvas (matches webapp ExperimentStep.tsx)
                        experimentStudioCanvas
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "030817"), in: RoundedRectangle(cornerRadius: isFullscreen ? 0 : 16, style: .continuous))
                .padding(.horizontal, isFullscreen ? 0 : 12)

                // Bottom Complete Experiment Bar (Hidden in Fullscreen)
                if !isFullscreen {
                    Button(action: {
                        DataService.shared.recordLabActivity(seconds: 600)
                        onCompleteExperiment?()
                    }) {
                        HStack(spacing: 8) {
                            Text("Complete Experiment")
                                .font(.system(size: 15, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 13, weight: .heavy))
                        }
                        .foregroundColor(Color(hex: "00131F"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "0EA5E9"), Color(hex: "22D3EE")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color(hex: "22D3EE").opacity(0.35), radius: 10, y: 3)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
            }
            .background(Color(hex: "030817"))
        }
        .background(Color(hex: "030817").ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .statusBarHidden(isFullscreen)
        .task {
            await fetchSimulationConfig()
        }
        .onAppear {
            DataService.shared.startLabSession(labId: lab.id)
        }
        .onDisappear {
            DataService.shared.endLabSession()
        }
    }



    // MARK: - Dedicated Virtual Lab Studio Canvas (No duplicate headers)
    private var experimentStudioCanvas: some View {
        VStack(spacing: 20) {
            Spacer()

            // Glowing Lab Icon
            ZStack {
                Circle()
                    .fill(Color(hex: "0B2036"))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle().stroke(Color(hex: "22D3EE").opacity(0.5), lineWidth: 2)
                    )
                    .shadow(color: Color(hex: "22D3EE").opacity(0.3), radius: 16)

                Image(systemName: lab.thumbnailSymbol.isEmpty ? "flask.fill" : lab.thumbnailSymbol)
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(Color(hex: "22D3EE"))
            }

            VStack(spacing: 8) {
                Text(lab.title)
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                HStack(spacing: 8) {
                    Text(lab.subject.rawValue.uppercased())
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "22D3EE"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(hex: "0E294B"), in: Capsule())

                    Text(lab.code)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(hex: "8A96B3"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "101A33"), in: Capsule())
                }
            }

            // Studio Guidance Card
            VStack(spacing: 10) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Theme.successGreen)
                        .frame(width: 8, height: 8)
                    Text("Interactive Experiment Studio Ready")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "DBE4F7"))
                }

                Text("Conduct your virtual experiment steps, observe chemical reactions and lab equipment behaviors, then proceed to the Assessment test.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "8A96B3"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 14)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 14)
            .background(Color(hex: "0B162C"), in: RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "17264A"), lineWidth: 1)
            )
            .padding(.horizontal, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "030817"))
    }

    private func fetchSimulationConfig() async {
        // 1. Check if lab already carries simulationPath from /api/v1/labs
        if let simPath = lab.simulationPath, !simPath.isEmpty {
            let fullUrl = simPath.hasPrefix("http") ? simPath : "\(AppConfig.baseURL)\(simPath.hasPrefix("/") ? simPath : "/\(simPath)")"
            if let simURL = URL(string: fullUrl) {
                await MainActor.run {
                    self.simulationURL = simURL
                    self.isLoading = false
                }
                return
            }
        }

        // 2. Fetch specific experiment config: GET /api/v1/labs/:id/experiment
        guard let url = URL(string: "\(AppConfig.baseURL)/api/v1/labs/\(lab.id)/experiment") else {
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = KeychainHelper.shared.readString(key: "auth_jwt_access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {

                let config = json["config"] as? [String: Any]
                let rawUrl = (config?["playUrl"] as? String) ??
                             (config?["path"] as? String) ??
                             (json["simulationPath"] as? String) ??
                             (json["playUrl"] as? String)

                if let raw = rawUrl, !raw.isEmpty {
                    let fullUrlString = raw.hasPrefix("http") ? raw : "\(AppConfig.baseURL)\(raw.hasPrefix("/") ? raw : "/\(raw)")"
                    if let simURL = URL(string: fullUrlString) {
                        await MainActor.run {
                            self.simulationURL = simURL
                            self.isLoading = false
                        }
                        return
                    }
                }
            }
        } catch {
            print("Simulation fetch error: \(error.localizedDescription)")
        }

        await MainActor.run {
            self.isLoading = false
        }
    }
}

// MARK: - Simulation Web View (WKWebView representing the interactive simulation canvas)
public struct SimulationWebView: UIViewRepresentable {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        // Injected JS to guarantee responsive layout scaling and smooth touch scrolling
        let viewportScript = WKUserScript(
            source: """
            var meta = document.querySelector('meta[name="viewport"]');
            if (!meta) {
                meta = document.createElement('meta');
                meta.name = 'viewport';
                meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=yes';
                document.getElementsByTagName('head')[0].appendChild(meta);
            }
            document.documentElement.style.overflow = 'auto';
            document.documentElement.style.webkitOverflowScrolling = 'touch';
            document.body.style.overflow = 'auto';
            document.body.style.webkitOverflowScrolling = 'touch';
            """,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: false
        )
        configuration.userContentController.addUserScript(viewportScript)

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 3/255, green: 8/255, blue: 23/255, alpha: 1.0)
        webView.scrollView.backgroundColor = .clear

        // ENABLE TOUCH SCROLLING & BOUNCING
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.scrollView.showsHorizontalScrollIndicator = true

        var request = URLRequest(url: url)
        if let token = KeychainHelper.shared.readString(key: "auth_jwt_access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        webView.load(request)
        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        // Keeps the existing webview instance intact during SwiftUI state updates
    }
}

