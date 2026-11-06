import SwiftUI

public struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch appState.selectedTab {
                case .home:
                    HomeView()
                case .labs:
                    BrowseLabsView()
                case .simulation:
                    PeriodicLabView()
                case .stats:
                    LearningStatisticsView()
                case .profile:
                    StudentProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Bottom Navigation Bar
            CustomBottomBar(selectedTab: $appState.selectedTab)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

public struct CustomBottomBar: View {
    @Binding public var selectedTab: TabItem
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: tab == selectedTab ? 20 : 18, weight: tab == selectedTab ? .bold : .regular))
                            .foregroundColor(tab == selectedTab ? Theme.primaryRed : Theme.textMuted)
                        
                        Text(tab.rawValue)
                            .font(.system(size: 10, weight: tab == selectedTab ? .bold : .medium))
                            .foregroundColor(tab == selectedTab ? Theme.primaryRed : Theme.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 10)
        .padding(.bottom, 24)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: -4)
        )
    }
}
