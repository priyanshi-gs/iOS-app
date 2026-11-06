import SwiftUI

public struct PeriodicLabView: View {
    @StateObject private var viewModel = PeriodicLabViewModel()
    @State private var showingDetailSheet: Bool = false
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            WaveHeader(
                title: "PeriodicLab",
                subtitle: "Interactive Periodic Table & Mnemonics",
                height: 120
            )
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Top Controls: Theory Mode, Voice, Search
                    HStack(spacing: 8) {
                        TogglePill(
                            title: "Theory & Learn",
                            icon: "book.fill",
                            isOn: $viewModel.isTheoryMode
                        )
                        
                        TogglePill(
                            title: "Voice On",
                            icon: "speaker.wave.2.fill",
                            isOn: $viewModel.isVoiceOn
                        ) {
                            viewModel.toggleVoice()
                        }
                        
                        TogglePill(
                            title: "Search",
                            icon: "magnifyingglass",
                            isOn: $viewModel.isSearchOn
                        )
                    }
                    .padding(.top, 10)
                    
                    // Search Bar if search is toggled
                    if viewModel.isSearchOn {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Theme.textMuted)
                            TextField("Search by name, symbol or atomic number", text: $viewModel.searchText)
                                .font(.system(size: 13))
                        }
                        .padding(10)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.borderLight, lineWidth: 1))
                    }
                    
                    // Category Header: Group 2: Alkaline Earth Metals
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Group 2: Alkaline Earth Metals")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Theme.primaryRed)
                                .textCase(.uppercase)
                            
                            Spacer()
                            
                            Text("Interactive Table")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(Theme.textMuted)
                        }
                        
                        // Elements Horizontal Grid
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(viewModel.elements) { element in
                                    ElementGridPill(
                                        element: element,
                                        isSelected: viewModel.selectedElement.id == element.id
                                    ) {
                                        viewModel.selectElement(element)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    // Main simulation view for the selected element (Calcium Ca default)
                    ElementDetailView(
                        element: viewModel.selectedElement,
                        rotationAngle: viewModel.electronRotationAngle,
                        isSpeaking: viewModel.isSpeaking,
                        onListenMnemonic: {
                            viewModel.speakMnemonic()
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 90)
            }
        }
        .background(Theme.screenBackground.ignoresSafeArea())
    }
}

public struct TogglePill: View {
    public let title: String
    public let icon: String
    @Binding public var isOn: Bool
    public var onToggle: (() -> Void)? = nil
    
    public var body: some View {
        Button(action: {
            isOn.toggle()
            onToggle?()
        }) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 11))
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isOn ? Theme.navyBackground : Color.white)
            .foregroundColor(isOn ? .white : Theme.textDark)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(isOn ? Color.clear : Theme.borderLight, lineWidth: 1)
            )
        }
    }
}

public struct ElementGridPill: View {
    public let element: PeriodicElement
    public let isSelected: Bool
    public let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(element.atomicNumber)")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : Theme.textMuted)
                
                Text(element.symbol)
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(isSelected ? .white : Theme.textDark)
                
                Text(element.name)
                    .font(.system(size: 9))
                    .foregroundColor(isSelected ? .white.opacity(0.9) : Theme.textMuted)
                    .lineLimit(1)
            }
            .frame(width: 58, height: 64)
            .background(isSelected ? Theme.primaryRed : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Theme.primaryRed : Theme.borderLight, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? Theme.primaryRed.opacity(0.3) : Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
