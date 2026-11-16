import SwiftUI
import WebKit

public struct StudyMaterialModule: Identifiable, Codable {
    public let id: String
    public let order: Int
    public let title: String
    public let type: String // "TEXT", "VIDEO", "PDF", "IMAGE"
    public let body: String
    public let videoUrl: String?
    public let fileUrl: String?
    public var isCompleted: Bool

    public init(
        id: String = UUID().uuidString,
        order: Int = 1,
        title: String,
        type: String = "TEXT",
        body: String = "",
        videoUrl: String? = nil,
        fileUrl: String? = nil,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.order = order
        self.title = title
        self.type = type
        self.body = body
        self.videoUrl = videoUrl
        self.fileUrl = fileUrl
        self.isCompleted = isCompleted
    }
}

public struct StudyMaterialScreen: View {
    public let lab: Lab
    public var onBack: (() -> Void)?
    public var onProceedToExperiment: (() -> Void)?

    @State private var modules: [StudyMaterialModule] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil
    @State private var isLockedState: Bool = false
    @State private var isShowingUpgradeSheet: Bool = false
    @State private var isShowingConnectSchoolSheet: Bool = false
    @State private var allMarked: Bool = false

    public init(
        lab: Lab,
        onBack: (() -> Void)? = nil,
        onProceedToExperiment: (() -> Void)? = nil
    ) {
        self.lab = lab
        self.onBack = onBack
        self.onProceedToExperiment = onProceedToExperiment
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Wave Header with Steps Tracker
            WaveHeader(
                title: lab.code,
                showBackButton: true,
                onBack: onBack
            )

            // Step Indicator Bar (Study -> Experiment -> Test -> Result)
            SimulationStepTracker(currentStep: .study)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 6)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {

                    // Header Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Study Material")
                            .font(.system(size: 24, weight: .heavy, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue)

                        Text("Read or watch each module, then mark it complete to unlock the experiment.")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.top, 4)

                    // Modules List Content
                    contentBody

                    Spacer().frame(height: 30)
                }
                .padding(.horizontal, 18)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowingUpgradeSheet) {
            CheckoutPaymentView(onBack: { isShowingUpgradeSheet = false })
        }
        .sheet(isPresented: $isShowingConnectSchoolSheet) {
            ConnectSchoolScreen(
                onBack: { isShowingConnectSchoolSheet = false },
                onVerified: {
                    isShowingConnectSchoolSheet = false
                    Task { await fetchModules() }
                }
            )
        }
        .task {
            await fetchModules()
        }
        .onAppear {
            DataService.shared.startLabSession(labId: lab.id)
        }
        .onDisappear {
            DataService.shared.endLabSession()
        }
    }

    @ViewBuilder
    private var contentBody: some View {
        if isLoading {
            loadingView
        } else if isLockedState || lab.isLocked {
            lockedAccessView
        } else if let errorMsg = errorMessage {
            errorView(message: errorMsg)
        } else if modules.isEmpty {
            emptyView
        } else {
            modulesListView
        }
    }

    private var lockedAccessView: some View {
        VStack(spacing: 18) {
            // Gold Shield Badge
            ZStack {
                Circle()
                    .fill(Color(hex: "FEF3C7"))
                    .frame(width: 68, height: 68)

                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(hex: "D97706"))
            }
            .padding(.top, 4)

            // Title & Description
            VStack(spacing: 6) {
                Text("Pro Curriculum Experiment")
                    .font(.system(size: 19, weight: .heavy, design: .rounded))
                    .foregroundColor(Theme.oxfordBlue)

                Text("This lab's study material, interactive simulation, and STEM certification require an active Pro subscription or connected school.")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal, 4)
            }

            // Benefits Checklist
            VStack(alignment: .leading, spacing: 9) {
                proBenefitRow(title: "Complete pre-reading theory & video lessons")
                proBenefitRow(title: "Full virtual laboratory simulation access")
                proBenefitRow(title: "Quizzes, assessments & verified STEM badge")
                proBenefitRow(title: "Unlimited access to all 25+ experiments")
            }
            .padding(14)
            .background(Color(hex: "F8FAFC"), in: RoundedRectangle(cornerRadius: 12))

            // Action Buttons
            VStack(spacing: 10) {
                Button(action: {
                    isShowingUpgradeSheet = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.yellow)
                        Text("Unlock Lab — Upgrade to Pro")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Theme.oxfordBlue)
                    .clipShape(Capsule())
                    .shadow(color: Theme.oxfordBlue.opacity(0.2), radius: 6, y: 3)
                }

                Button(action: {
                    isShowingConnectSchoolSheet = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 12))
                        Text("Have a school code? Connect School")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(Theme.crimson)
                }
            }
            .padding(.top, 4)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(hex: "FDE68A"), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    private func proBenefitRow(title: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(Theme.successGreen)
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.oxfordBlue)
            Spacer()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView().tint(Theme.oxfordBlue)
            Text("Loading study modules from server...")
                .font(Theme.body(13))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 32))
                .foregroundColor(Theme.crimson)

            Text("Unable to Load Material")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Theme.oxfordBlue)

            Text(message)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            Button(action: {
                Task { await fetchModules() }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Theme.oxfordBlue)
                .cornerRadius(10)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.crimson.opacity(0.15), lineWidth: 1)
        )
        .padding(.top, 10)
    }

    private var emptyView: some View {
        VStack(spacing: 14) {
            Image(systemName: "book.closed")
                .font(.system(size: 28))
                .foregroundColor(Color(hex: "A87300"))
            Text("This lab has no study material.")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color(hex: "A87300"))
            Button(action: { onProceedToExperiment?() }) {
                Text("Continue to experiment →")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: "002147"))
                    .cornerRadius(10)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "FFFCF3"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "FFF7E5"), lineWidth: 1)
        )
        .padding(.top, 10)
    }

    @ViewBuilder
    private var modulesListView: some View {
        ForEach($modules) { $module in
            studyModuleCard(module: $module)
        }

        // Unlock Info Banner
        HStack(spacing: 10) {
            Image(systemName: "book.closed")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: "15803D"))
            Text("Once every module is marked, the experiment unlocks.")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(hex: "166534"))
            Spacer()
        }
        .padding(14)
        .background(Color(hex: "DCFCE7"), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

        // Proceed to Experiment Button
        Button(action: { onProceedToExperiment?() }) {
            HStack(spacing: 8) {
                Text("Continue to Experiment")
                    .font(.system(size: 15, weight: .bold))
                Image(systemName: "arrow.right")
                    .font(.system(size: 13, weight: .heavy))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(allMarked ? AnyShapeStyle(Theme.redButtonGradient) : AnyShapeStyle(Color(hex: "94A3B8")))
            .clipShape(Capsule())
            .shadow(color: allMarked ? Theme.crimson.opacity(0.25) : Color.clear, radius: 8, y: 4)
        }
        .disabled(!allMarked)
        .padding(.top, 6)
    }



    // MARK: - Study Module Card
    @ViewBuilder
    private func studyModuleCard(module: Binding<StudyMaterialModule>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Bar
            HStack(spacing: 10) {
                // Number Box
                Text("\(module.wrappedValue.order)")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundColor(Theme.oxfordBlue)
                    .frame(width: 32, height: 32)
                    .background(Color(hex: "F1F5F9"), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                Image(systemName: module.wrappedValue.type == "VIDEO" ? "play.circle.fill" : "doc.text.fill")
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)

                Text(module.wrappedValue.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.oxfordBlue)
                    .lineLimit(1)

                Spacer()

                Text(module.wrappedValue.type)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
            }
            .padding(14)
            .background(Color(hex: "F8FAFC"))
            .overlay(Divider(), alignment: .bottom)

            // Content Body
            VStack(alignment: .leading, spacing: 14) {
                // Video Player if type is VIDEO
                if module.wrappedValue.type.uppercased() == "VIDEO" {
                    if let rawUrl = module.wrappedValue.videoUrl, !rawUrl.isEmpty {
                        VideoPlayerCard(
                            urlString: rawUrl,
                            title: module.wrappedValue.title
                        )
                    } else {
                        // Video placeholder banner
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Theme.crimson.opacity(0.12))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "play.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Theme.crimson)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(module.wrappedValue.title)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Theme.oxfordBlue)
                                Text("Video lecture will play here")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            Spacer()
                        }
                        .padding(12)
                        .background(Color(hex: "F8FAFC"), in: RoundedRectangle(cornerRadius: 12))
                    }
                }

                // Module text content / description
                if !module.wrappedValue.body.isEmpty {
                    Text(module.wrappedValue.body)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Theme.textPrimary)
                        .lineSpacing(5)
                }

                // Mark as read button
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        module.wrappedValue.isCompleted.toggle()
                        if module.wrappedValue.isCompleted {
                            DataService.shared.recordLabActivity(seconds: 300)
                        }
                        checkAllCompleted()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: module.wrappedValue.isCompleted ? "checkmark.circle.fill" : "checkmark")
                            .font(.system(size: 13, weight: .bold))
                        Text(module.wrappedValue.isCompleted ? "Completed" : "Mark as read")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundColor(module.wrappedValue.isCompleted ? Color(hex: "15803D") : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(
                        module.wrappedValue.isCompleted ? Color(hex: "DCFCE7") : Theme.oxfordBlue,
                        in: Capsule()
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(16)
        }
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    private func checkAllCompleted() {
        allMarked = !modules.isEmpty && modules.allSatisfy { $0.isCompleted }
    }

    private func fetchModules() async {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }

        // Pro / Locked Labs immediate detection
        if lab.isLocked {
            await MainActor.run {
                self.modules = []
                self.isLoading = false
                self.isLockedState = true
            }
            return
        }

        guard let url = URL(string: "\(AppConfig.baseURL)/api/v1/labs/\(lab.id)/materials") else {
            await MainActor.run {
                self.modules = []
                self.isLoading = false
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = AuthService.shared.ensureActiveToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let items = (json["modules"] as? [[String: Any]]) ?? (json["data"] as? [[String: Any]]) {

                        let parsed = items.enumerated().map { index, dict in
                            let title = (dict["title"] as? String) ?? "Lesson \(index + 1)"
                            let type = (dict["type"] as? String) ?? "TEXT"
                            let body = (dict["body"] as? String) ?? ""
                            let rawVideo = (dict["videoUrl"] as? String) ?? (dict["url"] as? String) ?? (dict["fileUrl"] as? String)
                            let videoUrl = (rawVideo != nil && !rawVideo!.isEmpty) ? rawVideo : (type.uppercased() == "VIDEO" && body.contains("http") ? body : nil)
                            let fileUrl = dict["fileUrl"] as? String

                            return StudyMaterialModule(
                                order: index + 1,
                                title: title,
                                type: type,
                                body: (videoUrl != nil && body == videoUrl) ? "" : body,
                                videoUrl: videoUrl,
                                fileUrl: fileUrl
                            )
                        }

                        await MainActor.run {
                            self.modules = parsed
                            self.isLoading = false
                            self.errorMessage = nil
                            self.isLockedState = false
                        }
                        return
                    }
                } else if httpResponse.statusCode == 401 {
                    await MainActor.run {
                        self.modules = []
                        self.isLoading = false
                        self.errorMessage = "Session expired or authentication required. Please sign in to access study materials."
                    }
                    return
                } else if httpResponse.statusCode == 403 {
                    await MainActor.run {
                        self.modules = []
                        self.isLoading = false
                        self.isLockedState = true
                    }
                    return
                } else {
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                    let errCode = (json?["error"] as? [String: Any])?["code"] as? String ?? json?["code"] as? String

                    if errCode == "SUBSCRIPTION_REQUIRED" || errCode == "TRIAL_LIMIT_REACHED" || errCode == "SCHOOL_SUBSCRIPTION_INACTIVE" {
                        await MainActor.run {
                            self.modules = []
                            self.isLoading = false
                            self.isLockedState = true
                        }
                        return
                    }

                    let serverMsg = (json?["error"] as? [String: Any])?["message"] as? String ?? json?["message"] as? String
                    await MainActor.run {
                        self.modules = []
                        self.isLoading = false
                        self.errorMessage = serverMsg ?? "Server returned error (HTTP \(httpResponse.statusCode))."
                    }
                    return
                }
            }
        } catch {
            print("Materials fetch error: \(error.localizedDescription)")
            await MainActor.run {
                self.errorMessage = "Network error: \(error.localizedDescription)"
            }
        }

        await MainActor.run {
            self.modules = []
            self.isLoading = false
        }
    }
}

// MARK: - YouTube Helper
public struct YouTubeHelper {
    public static func videoId(from urlString: String) -> String? {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        // Short link: youtu.be/<id>
        if let range = trimmed.range(of: "youtu.be/") {
            let id = trimmed[range.upperBound...].prefix(while: { $0 != "?" && $0 != "&" && $0 != "/" })
            if !id.isEmpty { return String(id) }
        }

        // Watch link: youtube.com/watch?v=<id>
        if let range = trimmed.range(of: "v=") {
            let id = trimmed[range.upperBound...].prefix(while: { $0 != "&" && $0 != "?" && $0 != "/" })
            if !id.isEmpty { return String(id) }
        }

        // Already embed: youtube.com/embed/<id>
        if let range = trimmed.range(of: "youtube.com/embed/") {
            let id = trimmed[range.upperBound...].prefix(while: { $0 != "?" && $0 != "&" && $0 != "/" })
            if !id.isEmpty { return String(id) }
        }

        return nil
    }

    public static func thumbnailUrl(from urlString: String) -> String? {
        guard let id = videoId(from: urlString) else { return nil }
        return "https://img.youtube.com/vi/\(id)/hqdefault.jpg"
    }

    public static func embedUrl(from urlString: String) -> String? {
        guard let id = videoId(from: urlString) else { return nil }
        return "https://www.youtube.com/embed/\(id)?autoplay=1&playsinline=1&rel=0"
    }
}

// MARK: - Video Player Card with High-Res Thumbnail & Interactive Playback
public struct VideoPlayerCard: View {
    public let urlString: String
    public let title: String
    @State private var isPlaying: Bool = false

    public init(urlString: String, title: String) {
        self.urlString = urlString
        self.title = title
    }

    public var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if isPlaying {
                    VideoWebView(urlString: urlString)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(16/9, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {
                    // High-Res Video Thumbnail with Red YouTube Play Button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPlaying = true
                        }
                    }) {
                        ZStack {
                            if let thumbUrlStr = YouTubeHelper.thumbnailUrl(from: urlString),
                               let thumbUrl = URL(string: thumbUrlStr) {
                                AsyncImage(url: thumbUrl) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    case .failure:
                                        fallbackGradient
                                    case .empty:
                                        ZStack {
                                            fallbackGradient
                                            ProgressView().tint(.white)
                                        }
                                    @unknown default:
                                        fallbackGradient
                                    }
                                }
                            } else {
                                fallbackGradient
                            }

                            // Dark overlay gradient for contrast
                            LinearGradient(
                                colors: [Color.black.opacity(0.1), Color.black.opacity(0.55)],
                                startPoint: .top,
                                endPoint: .bottom
                            )

                            // Prominent YouTube Play Button
                            ZStack {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(hex: "FF0000"))
                                    .frame(width: 58, height: 40)
                                    .shadow(color: Color.black.opacity(0.35), radius: 8, x: 0, y: 3)

                                Image(systemName: "play.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(16/9, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(hex: "E2E8F0"), lineWidth: 1)
            )

            // Bottom action row: Close Player & Open in YouTube
            HStack {
                if isPlaying {
                    Button(action: {
                        withAnimation { isPlaying = false }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                            Text("Close Player")
                        }
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Theme.textSecondary)
                    }
                }

                Spacer()

                Button(action: {
                    if let url = URL(string: urlString) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 11))
                        Text("Open in YouTube")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(Theme.crimson)
                }
            }
        }
    }

    private var fallbackGradient: some View {
        LinearGradient(
            colors: [Color(hex: "002147"), Color(hex: "1E293B")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Video Web View (Interactive, clickable inline video player with full controls)
public struct VideoWebView: UIViewRepresentable {
    public let urlString: String

    public init(urlString: String) {
        self.urlString = urlString
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.backgroundColor = .black
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false

        loadVideo(into: webView)
        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {}

    private func loadVideo(into webView: WKWebView) {
        if let embedUrl = YouTubeHelper.embedUrl(from: urlString) {
            let html = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
                <style>
                    * { margin: 0; padding: 0; box-sizing: border-box; background: #000; }
                    html, body { width: 100%; height: 100%; overflow: hidden; }
                    iframe { width: 100%; height: 100%; border: 0; }
                </style>
            </head>
            <body>
                <iframe src="\(embedUrl)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
            </body>
            </html>
            """
            webView.loadHTMLString(html, baseURL: URL(string: "https://www.youtube.com"))
        } else if let url = URL(string: urlString) {
            var req = URLRequest(url: url)
            req.setValue("https://www.youtube.com", forHTTPHeaderField: "Referer")
            webView.load(req)
        }
    }

    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: VideoWebView

        init(_ parent: VideoWebView) {
            self.parent = parent
        }

        public func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            // If user clicks "Watch video on YouTube" button or any external link, open in YouTube app or Safari
            if navigationAction.navigationType == .linkActivated ||
               (url.host?.contains("youtube.com") == true && !url.path.contains("/embed/")) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }
    }
}
