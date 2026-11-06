import SwiftUI

public struct ElementDetailView: View {
    public let element: PeriodicElement
    public let rotationAngle: Double
    public let isSpeaking: Bool
    public let onListenMnemonic: () -> Void
    
    @State private var selectedTab: String = "Properties"
    private let tabs = ["Overview", "Properties", "Configuration", "Uses"]
    
    public init(
        element: PeriodicElement,
        rotationAngle: Double,
        isSpeaking: Bool,
        onListenMnemonic: @escaping () -> Void
    ) {
        self.element = element
        self.rotationAngle = rotationAngle
        self.isSpeaking = isSpeaking
        self.onListenMnemonic = onListenMnemonic
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // Element Title Header
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(element.category.accentColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Text(element.symbol)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.textDark)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(element.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textDark)
                    Text(element.category.rawValue)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textMuted)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Group \(element.group)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Theme.primaryRed)
                    Text("Period \(element.period)")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
            }
            .padding(.horizontal, 4)
            
            // Sub-navigation tabs
            HStack(spacing: 6) {
                ForEach(tabs, id: \.self) { tab in
                    Button(action: { selectedTab = tab }) {
                        Text(tab)
                            .font(.system(size: 12, weight: selectedTab == tab ? .bold : .medium))
                            .foregroundColor(selectedTab == tab ? Theme.primaryRed : Theme.textMuted)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(selectedTab == tab ? Theme.primaryRed.opacity(0.1) : Color.clear)
                            .clipShape(Capsule())
                    }
                }
            }
            
            // Animated Bohr Model Simulation
            CardContainer(padding: 8) {
                VStack(spacing: 4) {
                    HStack {
                        Text("Bohr Atomic Shell Simulation")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Theme.textMuted)
                            .textCase(.uppercase)
                        Spacer()
                        Text("Shells: \(element.shellElectrons.map { String($0) }.joined(separator: ", "))")
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundColor(Theme.primaryBlue)
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 4)
                    
                    BohrModelView(element: element, rotationAngle: rotationAngle)
                }
            }
            
            // Properties Table
            CardContainer(padding: 14) {
                VStack(spacing: 8) {
                    PropertyRow(title: "Atomic Number", value: "\(element.atomicNumber)")
                    Divider()
                    PropertyRow(title: "Atomic Mass", value: String(format: "%.2f", element.atomicMass))
                    Divider()
                    PropertyRow(title: "Valency", value: "\(element.valency)")
                    Divider()
                    PropertyRow(title: "Electronegativity", value: String(format: "%.2f", element.electronegativity))
                    Divider()
                    PropertyRow(title: "Electronic Config", value: element.electronConfiguration)
                }
            }
            
            // Hinglish Mnemonic Memory Trick Card
            CardContainer(padding: 14) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(Theme.accentYellow)
                        Text("Hinglish Memory Trick")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        
                        Spacer()
                        
                        Button(action: onListenMnemonic) {
                            HStack(spacing: 4) {
                                Image(systemName: isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2")
                                    .font(.system(size: 11))
                                Text(isSpeaking ? "Playing" : "Listen")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Theme.navyBackground)
                            .clipShape(Capsule())
                        }
                    }
                    
                    Text("\"\(element.hinglishMnemonic)\"")
                        .font(.system(size: 14, weight: .bold, design: .serif))
                        .foregroundColor(Theme.primaryRed)
                    
                    Text(element.mnemonicNote)
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
            }
        }
    }
}

public struct PropertyRow: View {
    public let title: String
    public let value: String
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(Theme.textMuted)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.textDark)
        }
    }
}
