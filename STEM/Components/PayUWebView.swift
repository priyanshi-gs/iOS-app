import SwiftUI
import WebKit

public struct PayUWebView: UIViewRepresentable {
    public let htmlString: String
    public let onSuccess: () -> Void
    public let onFailure: (String) -> Void

    public init(
        htmlString: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        self.htmlString = htmlString
        self.onSuccess = onSuccess
        self.onFailure = onFailure
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.loadHTMLString(htmlString, baseURL: URL(string: AppConfig.payUBaseURL))
        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {}

    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: PayUWebView

        init(_ parent: PayUWebView) {
            self.parent = parent
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url?.absoluteString.lowercased() {
                // Failure patterns
                let isFailure = url.contains("failure") || url.contains("failed") || url.contains("status=failed") || url.contains("status=failure") || url.contains("cancelled")

                // Success callback pattern (from surl or website redirect post-payment)
                let isSuccess = url.contains("success") || url.contains("status=success") || url.contains("payment-success") || (url.contains("carawintech.com") && !url.contains("payu") && !isFailure)

                if isFailure {
                    decisionHandler(.cancel)
                    parent.onFailure("Payment was cancelled or failed.")
                    return
                } else if isSuccess {
                    decisionHandler(.cancel)
                    parent.onSuccess()
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}
