import SwiftUI

public struct CustomTabBar: View {
    @Binding public var selectedTab: AppTab

    public init(selectedTab: Binding<AppTab>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        HStack(spacing: 24) {
            ForEach(AppTab.allCases) { tab in
                let isSelected = selectedTab == tab

                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selectedTab = tab
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 15, weight: .bold))

                        Text(tab.title)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                    }
                    .padding(.horizontal, isSelected ? 20 : 16)
                    .padding(.vertical, 10)
                    .background(isSelected ? Theme.oxfordBlue : Color.clear)
                    .foregroundColor(isSelected ? .white : Theme.oxfordBlue.opacity(0.6))
                    .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 6)
        )
        .padding(.bottom, 8)
    }
}
