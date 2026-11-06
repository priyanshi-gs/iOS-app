import Foundation
import Combine

public final class AuthViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    public init() {}
    
    public func continueWithApple(completion: @escaping () -> Void) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.isLoading = false
            completion()
        }
    }
    
    public func continueWithEmail(completion: @escaping () -> Void) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.isLoading = false
            completion()
        }
    }
}

public final class SchoolConnectViewModel: ObservableObject {
    @Published public var referralCode: String = "EDU-PCM-2026"
    @Published public var isVerifying: Bool = false
    @Published public var isVerified: Bool = true
    @Published public var verifiedSchool: School? = School.sample
    @Published public var errorMessage: String? = nil
    
    public init() {}
    
    public func verifyCode(completion: @escaping (Bool) -> Void) {
        guard !referralCode.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your school referral code."
            return
        }
        
        isVerifying = true
        errorMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.isVerifying = false
            if self.referralCode.uppercased() == "EDU-PCM-2026" || self.referralCode.count >= 4 {
                self.isVerified = true
                self.verifiedSchool = School.sample
                completion(true)
            } else {
                self.isVerified = false
                self.errorMessage = "Invalid code. Please check with your school administrator."
                completion(false)
            }
        }
    }
}

