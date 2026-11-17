import SwiftUI

public enum NotificationCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case assignments = "Assignments"
    case achievements = "Badges"
    case updates = "Updates"

    public var id: String { rawValue }

    public var icon: String {
        switch self {
        case .all: return "bell.fill"
        case .assignments: return "flask.fill"
        case .achievements: return "rosette"
        case .updates: return "sparkles"
        }
    }
}

public struct NotificationItem: Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let message: String
    public let timeAgo: String
    public let category: NotificationCategory
    public let icon: String
    public let iconColorHex: String
    public let iconBgHex: String
    public var isUnread: Bool
    public let labId: String?

    public init(
        id: UUID = UUID(),
        title: String,
        message: String,
        timeAgo: String,
        category: NotificationCategory,
        icon: String,
        iconColorHex: String,
        iconBgHex: String,
        isUnread: Bool = true,
        labId: String? = nil
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.timeAgo = timeAgo
        self.category = category
        self.icon = icon
        self.iconColorHex = iconColorHex
        self.iconBgHex = iconBgHex
        self.isUnread = isUnread
        self.labId = labId
    }
}

public struct NotificationsScreen: View {
    public var onBack: (() -> Void)?
    public var onSelectLabId: ((String) -> Void)?

    @State private var selectedCategory: NotificationCategory = .all
    @State private var notifications: [NotificationItem] = [
        NotificationItem(
            title: "New Assignment: Acid Base & Salts",
            message: "Class 10 Chemistry experiment assigned by teacher. Complete pre-reading and simulation before Friday.",
            timeAgo: "15m ago",
            category: .assignments,
            icon: "flask.fill",
            iconColorHex: "DC143C",
            iconBgHex: "FFEBEF",
            isUnread: true,
            labId: "bfd19034-7fbd-463a-816b-0cbd326e059f"
        ),
        NotificationItem(
            title: "Verified LABS Badge Awarded!",
            message: "Congratulations! You scored 100% on Ohm's Law and earned the Electric Circuit Master certification.",
            timeAgo: "2h ago",
            category: .achievements,
            icon: "trophy.fill",
            iconColorHex: "D97706",
            iconBgHex: "FEF3C7",
            isUnread: true
        ),
        NotificationItem(
            title: "New Experiment Added",
            message: "Total Internal Reflection & Snell's Law is now live in Physics. Explore ray refraction interactively.",
            timeAgo: "Yesterday",
            category: .updates,
            icon: "sparkles",
            iconColorHex: "002147",
            iconBgHex: "EFF6FF",
            isUnread: false
        ),
        NotificationItem(
            title: "School Connected Successfully",
            message: "Your account is enrolled in Springfield High School. All 25+ curriculum labs are now unlocked.",
            timeAgo: "2d ago",
            category: .updates,
            icon: "building.columns.fill",
            iconColorHex: "16A34A",
            iconBgHex: "DCFCE7",
            isUnread: false
        ),
        NotificationItem(
            title: "Weekly Practice Reminder",
            message: "You are 1 lab away from hitting your weekly 3-hour learning milestone. Keep up the momentum!",
            timeAgo: "3d ago",
            category: .assignments,
            icon: "flame.fill",
            iconColorHex: "EA580C",
            iconBgHex: "FFEDD5",
            isUnread: false
        )
    ]

    public init(
        onBack: (() -> Void)? = nil,
        onSelectLabId: ((String) -> Void)? = nil
    ) {
        self.onBack = onBack
        self.onSelectLabId = onSelectLabId
    }

    private var filteredNotifications: [NotificationItem] {
        if selectedCategory == .all {
            return notifications
        }
        return notifications.filter { $0.category == selectedCategory }
    }

    private var unreadCount: Int {
        notifications.filter { $0.isUnread }.count
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Wave Header with Title & Back Button
            WaveHeader(
                title: "Notifications",
                showBackButton: true,
                onBack: onBack
            )

            VStack(spacing: 12) {
                // MARK: - Category Filter Chips (Dedicated Full-Width Edge-to-Edge Scroll)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(NotificationCategory.allCases) { cat in
                            categoryPill(category: cat)
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 4)
                }
                .padding(.top, 10)

                // MARK: - Subheader Row (Category status & Mark all read action)
                HStack(alignment: .center) {
                    HStack(spacing: 6) {
                        Text(selectedCategory == .all ? "All Notifications" : selectedCategory.rawValue)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue)

                        Text("•  \(filteredNotifications.count)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                    }

                    Spacer()

                    if unreadCount > 0 {
                        Button(action: markAllAsRead) {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.double")
                                    .font(.system(size: 11, weight: .bold))
                                Text("Mark all read")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            .foregroundColor(Theme.crimson)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Theme.crimson.opacity(0.08), in: Capsule())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 2)

                // Notifications List or Empty State
                if filteredNotifications.isEmpty {
                    emptyStateView
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredNotifications) { item in
                                notificationCard(item: item)
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Category Pill
    private func categoryPill(category: NotificationCategory) -> some View {
        let isSelected = selectedCategory == category
        return Button(action: {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                selectedCategory = category
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Theme.yellow : Theme.textSecondary)

                Text(category.rawValue)
                    .font(.system(size: 12.5, weight: isSelected ? .bold : .semibold, design: .rounded))

                if category == .all && unreadCount > 0 {
                    Text("\(unreadCount)")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundColor(isSelected ? Theme.oxfordBlue : .white)
                        .frame(minWidth: 16, minHeight: 16)
                        .padding(.horizontal, 4)
                        .background(isSelected ? Theme.yellow : Theme.crimson, in: Capsule())
                }
            }
            .foregroundColor(isSelected ? .white : Theme.oxfordBlue)
            .padding(.horizontal, 13)
            .padding(.vertical, 8)
            .background(
                isSelected ? Theme.oxfordBlue : Color.white,
                in: Capsule()
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : Color(hex: "E2E8F0"), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(isSelected ? 0.12 : 0.03), radius: isSelected ? 6 : 3, x: 0, y: isSelected ? 3 : 1)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Notification Card
    private func notificationCard(item: NotificationItem) -> some View {
        Button(action: {
            markAsRead(item.id)
            if let labId = item.labId {
                onSelectLabId?(labId)
            }
        }) {
            HStack(alignment: .top, spacing: 14) {
                // Category Icon Node
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(hex: item.iconBgHex))
                        .frame(width: 44, height: 44)

                    Image(systemName: item.icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: item.iconColorHex))
                }

                // Text Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        Text(item.title)
                            .font(.system(size: 14, weight: item.isUnread ? .bold : .semibold, design: .rounded))
                            .foregroundColor(Theme.oxfordBlue)
                            .lineLimit(2)

                        Spacer(minLength: 8)

                        Text(item.timeAgo)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(Theme.textMuted)
                    }

                    Text(item.message)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Theme.textSecondary)
                        .lineSpacing(2)
                        .multilineTextAlignment(.leading)

                    if item.labId != nil {
                        HStack(spacing: 4) {
                            Text("Open Experiment")
                                .font(.system(size: 11, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 9, weight: .bold))
                        }
                        .foregroundColor(Theme.crimson)
                        .padding(.top, 4)
                    }
                }

                // Unread Indicator Dot
                if item.isUnread {
                    Circle()
                        .fill(Theme.crimson)
                        .frame(width: 8, height: 8)
                        .padding(.top, 6)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                item.isUnread ? Color(hex: "F8FAFF") : Color.white,
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(item.isUnread ? Theme.oxfordBlue.opacity(0.12) : Color(hex: "F1F5F9"), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 60)

            ZStack {
                Circle()
                    .fill(Color(hex: "EFF6FF"))
                    .frame(width: 80, height: 80)

                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 34))
                    .foregroundColor(Theme.oxfordBlue)
            }

            VStack(spacing: 6) {
                Text("All Caught Up!")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundColor(Theme.oxfordBlue)

                Text("No notifications in this category. We'll alert you when new assignments or badges arrive.")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Actions
    private func markAsRead(_ id: UUID) {
        if let idx = notifications.firstIndex(where: { $0.id == id }) {
            notifications[idx].isUnread = false
        }
    }

    private func markAllAsRead() {
        withAnimation {
            for i in notifications.indices {
                notifications[i].isUnread = false
            }
        }
    }
}

#Preview {
    NotificationsScreen(
        onBack: {
            print("Back button tapped")
        },
        onSelectLabId: { labId in
            print("Selected Lab ID: \(labId)")
        }
    )
}
