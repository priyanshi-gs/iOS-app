import Foundation

public struct PayUInitiateResponse: Codable {
    public let action: String
    public let fields: [String: String]
}

public final class PayUService {
    public static let shared = PayUService()
    private init() {}

    /// Creates subscription and initiates PayU transaction
    public func startCheckout(planId: String, couponCode: String? = nil) async throws -> PayUInitiateResponse {
        // Step 1: Create subscription
        guard let subUrl = URL(string: "\(AppConfig.baseURL)/api/v1/subscriptions") else {
            throw URLError(.badURL)
        }

        var subRequest = URLRequest(url: subUrl)
        subRequest.httpMethod = "POST"
        subRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = KeychainHelper.shared.readString(key: "auth_jwt_access_token") {
            subRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        var subBody: [String: Any] = ["planId": planId]
        if let coupon = couponCode, !coupon.isEmpty {
            subBody["couponCode"] = coupon
        }

        subRequest.httpBody = try JSONSerialization.data(withJSONObject: subBody)
        let (subData, subResponse) = try await URLSession.shared.data(for: subRequest)

        guard let httpSubResponse = subResponse as? HTTPURLResponse, (200...299).contains(httpSubResponse.statusCode),
              let subJson = try? JSONSerialization.jsonObject(with: subData) as? [String: Any],
              let subscriptionId = (subJson["id"] as? String) ?? ((subJson["data"] as? [String: Any])?["id"] as? String) else {
            throw NSError(domain: "PayUService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to initialize subscription."])
        }

        // Step 2: Initiate PayU payment
        guard let payuUrl = URL(string: "\(AppConfig.baseURL)/api/v1/payments/payu/initiate") else {
            throw URLError(.badURL)
        }

        var payuRequest = URLRequest(url: payuUrl)
        payuRequest.httpMethod = "POST"
        payuRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = KeychainHelper.shared.readString(key: "auth_jwt_access_token") {
            payuRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let payuBody: [String: Any] = ["subscriptionId": subscriptionId]
        payuRequest.httpBody = try JSONSerialization.data(withJSONObject: payuBody)

        let (payuData, payuResponse) = try await URLSession.shared.data(for: payuRequest)
        guard let httpPayuResponse = payuResponse as? HTTPURLResponse, (200...299).contains(httpPayuResponse.statusCode) else {
            throw NSError(domain: "PayUService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to initiate PayU gateway."])
        }

        let decoder = JSONDecoder()
        return try decoder.decode(PayUInitiateResponse.self, from: payuData)
    }

    /// Builds the auto-submitting HTML form for PayU
    public func buildPayUHTML(action: String, fields: [String: String]) -> String {
        var inputs = ""
        for (key, value) in fields {
            let escapedValue = value.replacingOccurrences(of: "\"", with: "&quot;")
            inputs += "<input type=\"hidden\" name=\"\(key)\" value=\"\(escapedValue)\" />\n"
        }

        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                    background-color: #F8FAFC;
                    color: #0E3A6E;
                }
                .loader {
                    text-align: center;
                }
                .spinner {
                    border: 4px solid rgba(14, 58, 110, 0.1);
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    border-left-color: #0E3A6E;
                    animation: spin 1s linear infinite;
                    margin: 0 auto 16px auto;
                }
                @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
            </style>
        </head>
        <body onload="document.forms[0].submit()">
            <div class="loader">
                <div class="spinner"></div>
                <h3>Redirecting to PayU Secure Gateway...</h3>
                <p>Please do not close this window.</p>
            </div>
            <form method="POST" action="\(action)">
                \(inputs)
            </form>
        </body>
        </html>
        """
    }
}
