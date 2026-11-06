import Foundation
import SwiftUI
import AVFoundation

public final class PeriodicLabViewModel: ObservableObject {
    @Published public var selectedElement: PeriodicElement
    @Published public var elements: [PeriodicElement]
    @Published public var isTheoryMode: Bool = true
    @Published public var isVoiceOn: Bool = true
    @Published public var isSearchOn: Bool = false
    @Published public var searchText: String = ""
    @Published public var selectedCategory: ElementCategory? = .alkalineEarth
    
    // Animation state for Bohr electron shells
    @Published public var electronRotationAngle: Double = 0.0
    @Published public var isSpeaking: Bool = false
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var timer: Timer?
    
    public init() {
        let all = PeriodicElement.sampleElements
        self.elements = all
        // Default to Calcium (Ca) as depicted in the Figma screen
        self.selectedElement = all.first(where: { $0.id == 20 }) ?? all[0]
        startOrbitalAnimation()
    }
    
    public func selectElement(_ element: PeriodicElement) {
        self.selectedElement = element
        if isVoiceOn {
            speakMnemonic()
        }
    }
    
    public func toggleVoice() {
        isVoiceOn.toggle()
        if !isVoiceOn {
            speechSynthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
        }
    }
    
    public func speakMnemonic() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
            return
        }
        
        let text = "\(selectedElement.name), chemical symbol \(selectedElement.symbol). Hinglish memory trick: \(selectedElement.hinglishMnemonic). \(selectedElement.mnemonicNote)"
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.48
        utterance.pitchMultiplier = 1.05
        utterance.voice = AVSpeechSynthesisVoice(language: "en-IN") ?? AVSpeechSynthesisVoice(language: "en-US")
        
        isSpeaking = true
        speechSynthesizer.speak(utterance)
        
        // Reset speaking state when finished
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            self.isSpeaking = false
        }
    }
    
    private func startOrbitalAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.electronRotationAngle = (self.electronRotationAngle + 1.2).truncatingRemainder(dividingBy: 360.0)
        }
    }
    
    deinit {
        timer?.invalidate()
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}

