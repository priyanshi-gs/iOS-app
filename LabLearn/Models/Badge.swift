import Foundation

public struct Badge: Identifiable, Codable, Hashable {
    public let id: String
    public let title: String
    public let subject: Subject
    public let description: String
    public let iconName: String
    public var isEarned: Bool
    public var earnedDate: String?
    
    public init(
        id: String,
        title: String,
        subject: Subject,
        description: String,
        iconName: String,
        isEarned: Bool = false,
        earnedDate: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subject = subject
        self.description = description
        self.iconName = iconName
        self.isEarned = isEarned
        self.earnedDate = earnedDate
    }
    
    public static let sampleBadges: [Badge] = [
        Badge(id: "b1", title: "Titration Master", subject: .chemistry, description: "Completed 5 acid-base titration runs with <1% error.", iconName: "drop.triangle.fill", isEarned: true, earnedDate: "02 Nov"),
        Badge(id: "b2", title: "Safety First", subject: .chemistry, description: "Passed the lab safety protocol assessment with 100%.", iconName: "cross.case.fill", isEarned: true, earnedDate: "28 Oct"),
        Badge(id: "b3", title: "Analytical Master", subject: .all, description: "Logged accurate lab observations in 10 consecutive experiments.", iconName: "chart.bar.doc.horizontal.fill", isEarned: true, earnedDate: "25 Oct"),
        Badge(id: "b4", title: "Beer-Lambert Law", subject: .chemistry, description: "Successfully calibrated spectrophotometer absorption curves.", iconName: "waveform.path.ecg", isEarned: true, earnedDate: "22 Oct"),
        Badge(id: "b5", title: "Acid-Base Ace", subject: .chemistry, description: "Correctly identified pH endpoints using methyl orange & phenolphthalein.", iconName: "flask.fill", isEarned: true, earnedDate: "19 Oct"),
        Badge(id: "b6", title: "Pipette Pioneer", subject: .chemistry, description: "Mastered precision volumetric liquid measurements.", iconName: "eyedropper.full", isEarned: true, earnedDate: "15 Oct"),
        Badge(id: "b7", title: "Precision Pundit", subject: .physics, description: "Measured pendulum oscillations with standard error under 0.05s.", iconName: "scope", isEarned: true, earnedDate: "12 Oct"),
        Badge(id: "b8", title: "Reaction Ranger", subject: .chemistry, description: "Synthesized pure esters and documented esterification scent.", iconName: "flame.fill", isEarned: true, earnedDate: "08 Oct"),
        Badge(id: "b9", title: "Sparks Hunter", subject: .physics, description: "Mapped magnetic field lines with compass deflection precision.", iconName: "bolt.fill", isEarned: true, earnedDate: "05 Oct"),
        Badge(id: "b10", title: "Molecular Maestro", subject: .chemistry, description: "Assembled 3D Lewis structures for complex covalent bonds.", iconName: "circle.grid.cross.fill", isEarned: true, earnedDate: "01 Oct"),
        Badge(id: "b11", title: "Electron Envoy", subject: .physics, description: "Calculated Bohr shell radii and energy levels accurately.", iconName: "rays", isEarned: true, earnedDate: "28 Sep"),
        Badge(id: "b12", title: "Lab Veteran", subject: .all, description: "Logged over 15 hours of interactive simulation experiments.", iconName: "rosette", isEarned: true, earnedDate: "24 Sep"),
        Badge(id: "b13", title: "Optics Oracle", subject: .physics, description: "Calculated prism refractive index for white light dispersion.", iconName: "prism", isEarned: false),
        Badge(id: "b14", title: "Genetics Guru", subject: .biology, description: "Extracted and identified DNA strands in virtual onion bulb.", iconName: "dna", isEarned: false),
        Badge(id: "b15", title: "Cell Commander", subject: .biology, description: "Observed and stained stomata on Rheo leaf peel.", iconName: "allergens", isEarned: false),
        Badge(id: "b16", title: "Magnetic Magician", subject: .physics, description: "Verified Fleming's Left Hand Rule across dual solenoids.", iconName: "point.3.filled.connected.trianglepath.dotted", isEarned: false),
        Badge(id: "b17", title: "Stoichiometry Star", subject: .chemistry, description: "Balanced 20 complex redox chemical equations.", iconName: "scale.3d", isEarned: false),
        Badge(id: "b18", title: "Quantum Quest", subject: .physics, description: "Explained the photoelectric threshold frequency cutoff.", iconName: "sparkles", isEarned: false)
    ]
}
