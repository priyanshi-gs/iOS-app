import SwiftUI

public struct PrimaryButton: View {
    public let title: String
    public var iconName: String = "arrow.right"
    public var isEnabled: Bool = true
    public var isLoading: Bool = false
    public let action: () -> Void
    
    public init(
        _ title: String,
        iconName: String = "arrow.right",
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                    
                    if !iconName.isEmpty {
                        Image(systemName: iconName)
                            .font(.system(size: 14, weight: .bold))
                    }
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(isEnabled ? Theme.redButtonGradient : LinearGradient(colors: [Color.gray.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
            .clipShape(Capsule())
            .shadow(color: isEnabled ? Theme.primaryRed.opacity(0.35) : Color.clear, radius: 8, x: 0, y: 4)
        }
        .disabled(!isEnabled || isLoading)
    }
}

public struct SecondaryOutlineButton: View {
    public let title: String
    public var iconName: String? = nil
    public let action: () -> Void
    
    public init(_ title: String, iconName: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.iconName = iconName
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .font(.system(size: 15, weight: .medium))
                }
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(Theme.textDark)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Theme.borderLight, lineWidth: 1.5)
            )
            .clipShape(Capsule())
        }
    }
}

public struct CardContainer<Content: View>: View {
    public var padding: CGFloat = 16
    public var cornerRadius: CGFloat = 18
    public let content: Content
    
    public init(padding: CGFloat = 16, cornerRadius: CGFloat = 18, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(padding)
            .background(Theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Theme.borderLight, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

public struct EntitlementCheckRow: View {
    public let text: String
    public var isChecked: Bool = true
    
    public init(_ text: String, isChecked: Bool = true) {
        self.text = text
        self.isChecked = isChecked
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isChecked ? Theme.accentGreen : Theme.textMuted)
                .font(.system(size: 18))
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.textDark)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

public struct SubjectChip: View {
    public let subject: Subject
    public var isSelected: Bool = false
    public var action: (() -> Void)? = nil
    
    public var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 6) {
                Image(systemName: subject.iconName)
                    .font(.system(size: 12))
                Text(subject.rawValue)
                    .font(.system(size: 13, weight: .semibold))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Theme.primaryRed : Color.white)
            .foregroundColor(isSelected ? .white : Theme.textDark)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(isSelected ? Color.clear : Theme.borderLight, lineWidth: 1)
            )
            .shadow(color: isSelected ? Theme.primaryRed.opacity(0.25) : Color.clear, radius: 4, x: 0, y: 2)
        }
    }
}

