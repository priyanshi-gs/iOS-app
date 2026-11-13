import Foundation

public final class DataService {
    public static let shared = DataService()

    private init() {}

    // MARK: - User Profile
    public func fetchUserProfile() -> UserProfile {
        UserProfile(
            name: "Ratnam",
            availableLabsCount: 2,
            badgesWonCount: 12,
            labHoursTotal: 18.5,
            activeLabId: "ch-101"
        )
    }

    // MARK: - Labs
    public func fetchLabs() -> [Lab] {
        [
            Lab(
                id: "ch-101",
                title: "Acid-Base Titration",
                subject: .chemistry,
                code: "CH-101",
                duration: "15 min",
                status: .inProgress,
                thumbnailSymbol: "flask.fill",
                gradientStartHex: "8B5CF6",
                gradientEndHex: "DC143C",
                description: "Determine the concentration of an unknown acid solution using standardized sodium hydroxide and phenolphthalein indicator."
            ),
            Lab(
                id: "ph-104",
                title: "Simple Pendulum",
                subject: .physics,
                code: "PH-104",
                duration: "10 min",
                status: .completed,
                thumbnailSymbol: "circle.grid.cross.fill",
                gradientStartHex: "0284C7",
                gradientEndHex: "002147",
                description: "Investigate how length, mass, and amplitude affect the oscillation period of a simple harmonic pendulum."
            ),
            Lab(
                id: "ph-206",
                title: "Dispersion of Light",
                subject: .physics,
                code: "PH-206",
                duration: "12 min",
                status: .completed,
                thumbnailSymbol: "triangle.fill",
                gradientStartHex: "3B82F6",
                gradientEndHex: "F59E0B",
                description: "Observe polychromatic light refraction and dispersion into spectral colors using a triangular glass prism."
            ),
            Lab(
                id: "ph-208",
                title: "Magnetic Field Lines",
                subject: .physics,
                code: "PH-208",
                duration: "14 min",
                status: .notStarted,
                thumbnailSymbol: "bolt.horizontal.fill",
                gradientStartHex: "DC143C",
                gradientEndHex: "002147",
                description: "Plot magnetic field lines around bar magnets, solenoids, and study dipole interactions."
            ),
            Lab(
                id: "ch-205",
                title: "Esters – Preparation & Properties",
                subject: .chemistry,
                code: "CH-205",
                duration: "18 min",
                status: .notStarted,
                thumbnailSymbol: "atom",
                gradientStartHex: "059669",
                gradientEndHex: "0284C7",
                description: "Synthesize pleasant-smelling esters through Fischer esterification of carboxylic acids and alcohols."
            ),
            Lab(
                id: "bio-301",
                title: "DNA Structure",
                subject: .biology,
                code: "BIO-301",
                duration: "20 min",
                status: .inProgress,
                thumbnailSymbol: "waveform.path",
                gradientStartHex: "06B6D4",
                gradientEndHex: "10B981",
                description: "Explore the Watson-Crick double helix, nucleotide base pairing, and antiparallel sugar-phosphate backbones."
            ),
            Lab(
                id: "bio-102",
                title: "Study of Stomata",
                subject: .biology,
                code: "BIO-102",
                duration: "12 min",
                status: .completed,
                thumbnailSymbol: "leaf.fill",
                gradientStartHex: "10B981",
                gradientEndHex: "84CC16",
                description: "Prepare temporary leaf epidermal peels to examine guard cells and stomatal apertures under high magnification."
            )
        ]
    }

    // MARK: - Periodic Table Elements
    public func fetchElements() -> [Element] {
        [
            // Period 1
            Element(
                id: 1, symbol: "H", name: "Hydrogen", atomicMass: 1.008,
                category: .reactiveNonmetal, group: 1, period: 1,
                electronConfig: [1], electronegativity: 2.20, atomicRadius: 53, ionizationEnergy: 1312.0,
                mnemonicTrick: "\"Hai Liena Ki Rubina Se Friendship\"",
                overviewDescription: "The lightest and most abundant chemical element in the universe.",
                propertiesDescription: "Colorless, odorless, tasteless, non-toxic, and highly combustible diatomic gas.",
                electronConfigurationNotation: "1s¹",
                commonUses: ["Rocket propulsion fuel", "Ammonia synthesis via Haber process", "Hydrocracking in petroleum refining"]
            ),
            Element(
                id: 2, symbol: "He", name: "Helium", atomicMass: 4.003,
                category: .nobleGas, group: 18, period: 1,
                electronConfig: [2], electronegativity: nil, atomicRadius: 31, ionizationEnergy: 2372.3,
                mnemonicTrick: "\"He Ne Ar Kr Xe Rn - Hero Never Arrived\"",
                overviewDescription: "A colorless, inert noble gas with the lowest boiling point among all elements.",
                propertiesDescription: "Monatomic, unreactive gas that does not freeze under normal atmospheric pressures.",
                electronConfigurationNotation: "1s²",
                commonUses: ["Cryogenic coolant for superconducting magnets in MRI", "Lifting gas for balloons", "Deep-sea breathing mixtures"]
            ),

            // Period 2
            Element(
                id: 3, symbol: "Li", name: "Lithium", atomicMass: 6.94,
                category: .alkaliMetal, group: 1, period: 2,
                electronConfig: [2, 1], electronegativity: 0.98, atomicRadius: 167, ionizationEnergy: 520.2,
                mnemonicTrick: "\"Li-Na - Light Metal Pioneer\"",
                overviewDescription: "The least dense solid element and lightest alkali metal.",
                propertiesDescription: "Soft, silvery metal that reacts vigorously with water and tarnishes rapidly.",
                electronConfigurationNotation: "[He] 2s¹",
                commonUses: ["Rechargeable lithium-ion batteries", "Mood-stabilizing pharmaceuticals", "Heat-resistant glass and ceramics"]
            ),
            Element(
                id: 4, symbol: "Be", name: "Beryllium", atomicMass: 9.012,
                category: .alkalineEarth, group: 2, period: 2,
                electronConfig: [2, 2], electronegativity: 1.57, atomicRadius: 112, ionizationEnergy: 899.5,
                mnemonicTrick: "\"Beta Mange Car - Beta\"",
                overviewDescription: "A relatively rare metal formed in stellar spallation rather than nucleosynthesis.",
                propertiesDescription: "Steel-gray, strong, lightweight and brittle alkaline earth metal.",
                electronConfigurationNotation: "[He] 2s²",
                commonUses: ["Aerospace structural components", "X-ray tube transmission windows", "Beryllium-copper non-sparking tools"]
            ),
            Element(
                id: 5, symbol: "B", name: "Boron", atomicMass: 10.81,
                category: .metalloid, group: 13, period: 2,
                electronConfig: [2, 3], electronegativity: 2.04, atomicRadius: 87, ionizationEnergy: 800.6,
                mnemonicTrick: "\"B A G I T - Group 13 Trick\"",
                overviewDescription: "A low-abundance metalloid that forms robust covalent networks.",
                propertiesDescription: "Extremely hard, black semiconductor with high melting point.",
                electronConfigurationNotation: "[He] 2s² 2p¹",
                commonUses: ["Borosilicate laboratory glassware (Pyrex)", "Fiberglass insulation", "Semiconductor dopant"]
            ),
            Element(
                id: 6, symbol: "C", name: "Carbon", atomicMass: 12.011,
                category: .reactiveNonmetal, group: 14, period: 2,
                electronConfig: [2, 4], electronegativity: 2.55, atomicRadius: 67, ionizationEnergy: 1086.5,
                mnemonicTrick: "\"Chanda Mama - Carbon Basis of Life\"",
                overviewDescription: "The quintessential chemical element of organic chemistry and life.",
                propertiesDescription: "Forms remarkable allotropes: diamond, graphite, graphene, and carbon nanotubes.",
                electronConfigurationNotation: "[He] 2s² 2p²",
                commonUses: ["Basis of all known organic life", "Carbon fiber composites", "Steel alloy carbon content"]
            ),
            Element(
                id: 7, symbol: "N", name: "Nitrogen", atomicMass: 14.007,
                category: .reactiveNonmetal, group: 15, period: 2,
                electronConfig: [2, 5], electronegativity: 3.04, atomicRadius: 56, ionizationEnergy: 1402.3,
                mnemonicTrick: "\"Nana Patekar - Nitrogen Trick\"",
                overviewDescription: "Constitutes approximately 78% of Earth's atmosphere.",
                propertiesDescription: "Colorless, odorless diatomic gas bound by a very strong triple bond.",
                electronConfigurationNotation: "[He] 2s² 2p³",
                commonUses: ["Industrial nitrogen fertilizers", "Liquid nitrogen cryopreservation", "Inert atmosphere packaging"]
            ),
            Element(
                id: 8, symbol: "O", name: "Oxygen", atomicMass: 15.999,
                category: .reactiveNonmetal, group: 16, period: 2,
                electronConfig: [2, 6], electronegativity: 3.44, atomicRadius: 48, ionizationEnergy: 1313.9,
                mnemonicTrick: "\"Old Style Se Te Po\"",
                overviewDescription: "Highly reactive nonmetal and oxidizing agent supporting combustion and aerobic respiration.",
                propertiesDescription: "Pale blue in liquid form, paramagnetic diatomic gas at standard conditions.",
                electronConfigurationNotation: "[He] 2s² 2p⁴",
                commonUses: ["Cellular respiration", "Medical life support systems", "Oxy-acetylene welding"]
            ),
            Element(
                id: 9, symbol: "F", name: "Fluorine", atomicMass: 18.998,
                category: .reactiveNonmetal, group: 17, period: 2,
                electronConfig: [2, 7], electronegativity: 3.98, atomicRadius: 42, ionizationEnergy: 1681.0,
                mnemonicTrick: "\"Fir Kal Bahar Aayi Aunty\"",
                overviewDescription: "The most electronegative and chemically reactive of all chemical elements.",
                propertiesDescription: "Extremely toxic, pale yellow halogen gas capable of attacking almost all elements.",
                electronConfigurationNotation: "[He] 2s² 2p⁵",
                commonUses: ["Toothpaste cavity prevention (fluoride)", "Teflon PTFE non-stick coatings", "Refrigerants and etching"]
            ),
            Element(
                id: 10, symbol: "Ne", name: "Neon", atomicMass: 20.180,
                category: .nobleGas, group: 18, period: 2,
                electronConfig: [2, 8], electronegativity: nil, atomicRadius: 38, ionizationEnergy: 2080.7,
                mnemonicTrick: "\"New Era of Noble Lights\"",
                overviewDescription: "A noble gas known for glowing with a brilliant reddish-orange discharge.",
                propertiesDescription: "Chemically unreactive gas with the second-lightest noble gas density.",
                electronConfigurationNotation: "[He] 2s² 2p⁶",
                commonUses: ["High-voltage advertising neon signs", "Gas lasers (He-Ne lasers)", "Cryogenic refrigerant"]
            ),

            // Period 3
            Element(
                id: 11, symbol: "Na", name: "Sodium", atomicMass: 22.990,
                category: .alkaliMetal, group: 1, period: 3,
                electronConfig: [2, 8, 1], electronegativity: 0.93, atomicRadius: 190, ionizationEnergy: 495.8,
                mnemonicTrick: "\"Na Jaane Kahan Se Aayi - Natrium\"",
                overviewDescription: "Soft, highly reactive alkali metal essential for biological nerve signaling.",
                propertiesDescription: "Low melting point, cuts easily with a butter knife, tarnishes instantly in air.",
                electronConfigurationNotation: "[Ne] 3s¹",
                commonUses: ["Table salt (NaCl)", "Street lighting sodium-vapor lamps", "Chemical reducing agent"]
            ),
            Element(
                id: 12, symbol: "Mg", name: "Magnesium", atomicMass: 24.305,
                category: .alkalineEarth, group: 2, period: 3,
                electronConfig: [2, 8, 2], electronegativity: 1.31, atomicRadius: 145, ionizationEnergy: 737.7,
                mnemonicTrick: "\"Beta Mange Car - Mange\"",
                overviewDescription: "Crucial element centered in the chlorophyll molecule for photosynthesis.",
                propertiesDescription: "Shiny gray solid with high structural strength-to-weight ratio.",
                electronConfigurationNotation: "[Ne] 3s²",
                commonUses: ["Lightweight structural alloys in automobiles", "Chlorophyll in plants", "Flares and pyrotechnics"]
            ),
            Element(
                id: 13, symbol: "Al", name: "Aluminum", atomicMass: 26.982,
                category: .postTransition, group: 13, period: 3,
                electronConfig: [2, 8, 3], electronegativity: 1.61, atomicRadius: 118, ionizationEnergy: 577.5,
                mnemonicTrick: "\"Alia Bhatt - Aluminum\"",
                overviewDescription: "The most abundant metallic element in the Earth's continental crust.",
                propertiesDescription: "Corrosion-resistant due to self-passivating surface oxide film.",
                electronConfigurationNotation: "[Ne] 3s² 3p¹",
                commonUses: ["Aviation and aerospace frames", "Beverage cans and food packaging foil", "Electrical transmission cabling"]
            ),
            Element(
                id: 14, symbol: "Si", name: "Silicon", atomicMass: 28.085,
                category: .metalloid, group: 14, period: 3,
                electronConfig: [2, 8, 4], electronegativity: 1.90, atomicRadius: 111, ionizationEnergy: 786.5,
                mnemonicTrick: "\"Silicon Valley Semiconductor\"",
                overviewDescription: "The cornerstone element of modern computing and microelectronics.",
                propertiesDescription: "Hard, brittle crystalline solid with a blue-grey metallic sheen.",
                electronConfigurationNotation: "[Ne] 3s² 3p²",
                commonUses: ["Microprocessors and photovoltaic solar cells", "Silicone sealants and polymers", "Silica glass and concrete"]
            ),
            Element(
                id: 15, symbol: "P", name: "Phosphorus", atomicMass: 30.974,
                category: .reactiveNonmetal, group: 15, period: 3,
                electronConfig: [2, 8, 5], electronegativity: 2.19, atomicRadius: 98, ionizationEnergy: 1011.8,
                mnemonicTrick: "\"Phoolon Ka Taaron Ka - Phosphorus\"",
                overviewDescription: "Fundamental component of DNA, RNA, ATP cellular energy, and bone minerals.",
                propertiesDescription: "Exists in several allotropic modifications including white and red phosphorus.",
                electronConfigurationNotation: "[Ne] 3s² 3p³",
                commonUses: ["NPK agricultural fertilizers", "Safety matches and fireworks", "Detergent builders and water treatment"]
            ),
            Element(
                id: 16, symbol: "S", name: "Sulfur", atomicMass: 32.06,
                category: .reactiveNonmetal, group: 16, period: 3,
                electronConfig: [2, 8, 6], electronegativity: 2.58, atomicRadius: 88, ionizationEnergy: 999.6,
                mnemonicTrick: "\"Sultan of Yellow Crystals\"",
                overviewDescription: "Bright yellow crystalline solid found near volcanic vents and hot springs.",
                propertiesDescription: "Forms cyclic S₈ molecules; burns with a blue flame producing pungent SO₂.",
                electronConfigurationNotation: "[Ne] 3s² 3p⁴",
                commonUses: ["Sulfuric acid industrial production", "Rubber vulcanization", "Fungicides and pharmaceuticals"]
            ),
            Element(
                id: 17, symbol: "Cl", name: "Chlorine", atomicMass: 35.45,
                category: .reactiveNonmetal, group: 17, period: 3,
                electronConfig: [2, 8, 7], electronegativity: 3.16, atomicRadius: 79, ionizationEnergy: 1251.2,
                mnemonicTrick: "\"Clean Water Halogen\"",
                overviewDescription: "Powerful disinfectant and widespread industrial halogen.",
                propertiesDescription: "Yellow-green gas with an unmistakable suffocating bleach-like odor.",
                electronConfigurationNotation: "[Ne] 3s² 3p⁵",
                commonUses: ["Municipal drinking water disinfection", "PVC plastic polymer production", "Household bleach sanitizers"]
            ),
            Element(
                id: 18, symbol: "Ar", name: "Argon", atomicMass: 39.948,
                category: .nobleGas, group: 18, period: 3,
                electronConfig: [2, 8, 8], electronegativity: nil, atomicRadius: 71, ionizationEnergy: 1520.6,
                mnemonicTrick: "\"Arjun The Archer - Argon Shield\"",
                overviewDescription: "The third most abundant gas in Earth's atmosphere (0.934%).",
                propertiesDescription: "Colorless, odorless noble gas that creates an inert shield during welding.",
                electronConfigurationNotation: "[Ne] 3s² 3p⁶",
                commonUses: ["Inert shielding gas for TIG and MIG welding", "Double-pane insulated window filling", "Incandescent filament protection"]
            ),

            // Period 4
            Element(
                id: 19, symbol: "K", name: "Potassium", atomicMass: 39.098,
                category: .alkaliMetal, group: 1, period: 4,
                electronConfig: [2, 8, 8, 1], electronegativity: 0.82, atomicRadius: 243, ionizationEnergy: 418.8,
                mnemonicTrick: "\"Kaju Katli - Potassium Kalium\"",
                overviewDescription: "Essential dietary cation for muscular contraction and neural impulses.",
                propertiesDescription: "Silvery alkali metal so soft it can be sliced with ease; reacts violently with water.",
                electronConfigurationNotation: "[Ar] 4s¹",
                commonUses: ["Agricultural potash fertilizer", "Sodium-potassium cellular pump", "Soaps and glass manufacturing"]
            ),

            // CALCIUM (Primary Focus Element)
            Element(
                id: 20, symbol: "Ca", name: "Calcium", atomicMass: 40.08,
                category: .alkalineEarth, group: 2, period: 4,
                electronConfig: [2, 8, 8, 2], electronegativity: 1.00, atomicRadius: 197, ionizationEnergy: 589.8,
                mnemonicTrick: "\"Beta Mange Car Scooter Baap Raazi\" — Car from 'Beta Mange Car Scooter Baap Raazi'",
                overviewDescription: "Calcium is a reactive alkaline earth metal that forms a dark oxide-nitride layer when exposed to air. Its physical and chemical properties are most similar to its heavier homologues strontium and barium. It is the fifth most abundant element in the Earth's crust and the third most abundant metal.",
                propertiesDescription: "Silvery-white metallic luster with high electrical and thermal conductivity. Reacts steadily with water to liberate hydrogen and precipitate calcium hydroxide.",
                electronConfigurationNotation: "[Ar] 4s²",
                commonUses: [
                    "Structural building material in Portland cement & concrete",
                    "Essential mineral for bone density, teeth, and cellular signaling",
                    "Deoxidizer and reducing agent in specialty steel metallurgy",
                    "Calcium carbonate antacids and dietary supplements"
                ]
            ),

            Element(
                id: 21, symbol: "Sc", name: "Scandium", atomicMass: 44.956,
                category: .transitionMetal, group: 3, period: 4,
                electronConfig: [2, 8, 9, 2], electronegativity: 1.36, atomicRadius: 162, ionizationEnergy: 633.1,
                mnemonicTrick: "\"Science Teacher - Sc\"",
                overviewDescription: "First transition metal in the periodic table.",
                propertiesDescription: "Silvery-white metallic transition metal with high melting point.",
                electronConfigurationNotation: "[Ar] 3d¹ 4s²",
                commonUses: ["Scandium-aluminum aerospace alloys", "High-intensity stadium lights", "Baseball bats and bicycle frames"]
            ),
            Element(
                id: 22, symbol: "Ti", name: "Titanium", atomicMass: 47.867,
                category: .transitionMetal, group: 4, period: 4,
                electronConfig: [2, 8, 10, 2], electronegativity: 1.54, atomicRadius: 147, ionizationEnergy: 658.8,
                mnemonicTrick: "\"Titanic Strength - Titanium\"",
                overviewDescription: "Renowned for its ultra-high strength-to-density ratio and corrosion resistance.",
                propertiesDescription: "Lustrous transition metal with a silver color and low density.",
                electronConfigurationNotation: "[Ar] 3d² 4s²",
                commonUses: ["Jet engine turbines and spacecraft", "Biocompatible medical bone implants", "Bright white TiO₂ pigment"]
            ),
            Element(
                id: 23, symbol: "V", name: "Vanadium", atomicMass: 50.942,
                category: .transitionMetal, group: 5, period: 4,
                electronConfig: [2, 8, 11, 2], electronegativity: 1.63, atomicRadius: 134, ionizationEnergy: 650.9,
                mnemonicTrick: "\"Very Strong - Vanadium\"",
                overviewDescription: "Hard, ductile metal used principally in steel reinforcement.",
                propertiesDescription: "Forms four vibrant oxidation states in aqueous solution (+2, +3, +4, +5).",
                electronConfigurationNotation: "[Ar] 3d³ 4s²",
                commonUses: ["High-speed tool steels", "Vanadium redox flow batteries", "Chemical oxidation catalysts"]
            ),
            Element(
                id: 24, symbol: "Cr", name: "Chromium", atomicMass: 51.996,
                category: .transitionMetal, group: 6, period: 4,
                electronConfig: [2, 8, 13, 1], electronegativity: 1.66, atomicRadius: 128, ionizationEnergy: 652.9,
                mnemonicTrick: "\"Chrome Shiny Finish\"",
                overviewDescription: "Hard transition metal that gives stainless steel its corrosion immunity.",
                propertiesDescription: "Remarkable resistance to oxidation, high specular reflectivity.",
                electronConfigurationNotation: "[Ar] 3d⁵ 4s¹",
                commonUses: ["Stainless steel manufacture (>10.5% Cr)", "Decorative chrome electroplating", "Ruby laser crystal doping"]
            ),
            Element(
                id: 25, symbol: "Mn", name: "Manganese", atomicMass: 54.938,
                category: .transitionMetal, group: 7, period: 4,
                electronConfig: [2, 8, 13, 2], electronegativity: 1.55, atomicRadius: 127, ionizationEnergy: 717.3,
                mnemonicTrick: "\"Man ki Baat - Manganese\"",
                overviewDescription: "Essential industrial alloying element in all commercial steels.",
                propertiesDescription: "Brittle, silvery-gray metal resembling iron.",
                electronConfigurationNotation: "[Ar] 3d⁵ 4s²",
                commonUses: ["Steel deoxidizing and strengthening", "Alkaline battery cathodes (MnO₂)", "Aluminum alloy can sheets"]
            ),
            Element(
                id: 26, symbol: "Fe", name: "Iron", atomicMass: 55.845,
                category: .transitionMetal, group: 8, period: 4,
                electronConfig: [2, 8, 14, 2], electronegativity: 1.83, atomicRadius: 126, ionizationEnergy: 762.5,
                mnemonicTrick: "\"Ferrum - Foundation of Industry\"",
                overviewDescription: "The most common element on Earth by mass, forming much of the planet's core.",
                propertiesDescription: "Ferromagnetic at room temperature, easily oxidized in moist air to rust.",
                electronConfigurationNotation: "[Ar] 3d⁶ 4s²",
                commonUses: ["Civil infrastructure and structural steel", "Hemoglobin oxygen transport in blood", "Magnets and electromagnets"]
            ),
            Element(
                id: 27, symbol: "Co", name: "Cobalt", atomicMass: 58.933,
                category: .transitionMetal, group: 9, period: 4,
                electronConfig: [2, 8, 15, 2], electronegativity: 1.88, atomicRadius: 125, ionizationEnergy: 760.4,
                mnemonicTrick: "\"Cobalt Blue Pigment\"",
                overviewDescription: "Ferromagnetic metal used in high-performance superalloys and batteries.",
                propertiesDescription: "Hard, lustrous, silver-gray metal producing deep blue glass compounds.",
                electronConfigurationNotation: "[Ar] 3d⁷ 4s²",
                commonUses: ["Lithium-ion battery cathodes (NMC, LCO)", "High-temperature gas turbine superalloys", "Vitamin B12 central metal"]
            ),
            Element(
                id: 28, symbol: "Ni", name: "Nickel", atomicMass: 58.693,
                category: .transitionMetal, group: 10, period: 4,
                electronConfig: [2, 8, 16, 2], electronegativity: 1.91, atomicRadius: 124, ionizationEnergy: 737.1,
                mnemonicTrick: "\"Nichrome Wire Heating\"",
                overviewDescription: "Corrosion-resistant metal widely used in coinage and stainless steel.",
                propertiesDescription: "Silvery-white with a slight golden tinge, ferromagnetic metal.",
                electronConfigurationNotation: "[Ar] 3d⁸ 4s²",
                commonUses: ["Stainless steel manufacturing", "EV battery high-energy chemistries", "Gas turbine coatings"]
            ),
            Element(
                id: 29, symbol: "Cu", name: "Copper", atomicMass: 63.546,
                category: .transitionMetal, group: 11, period: 4,
                electronConfig: [2, 8, 18, 1], electronegativity: 1.90, atomicRadius: 128, ionizationEnergy: 745.5,
                mnemonicTrick: "\"Current Conductor - Cu\"",
                overviewDescription: "One of the few metallic elements that occurs in nature in directly usable form.",
                propertiesDescription: "Reddish-orange metal with exceptional electrical and thermal conductivity.",
                electronConfigurationNotation: "[Ar] 3d¹⁰ 4s¹",
                commonUses: ["Electrical wiring and motors", "Plumbing pipes and bronze/brass alloys", "Antimicrobial surface coatings"]
            ),
            Element(
                id: 30, symbol: "Zn", name: "Zinc", atomicMass: 65.38,
                category: .transitionMetal, group: 12, period: 4,
                electronConfig: [2, 8, 18, 2], electronegativity: 1.65, atomicRadius: 133, ionizationEnergy: 906.4,
                mnemonicTrick: "\"Zindagi Na Milegi Dobara - Zinc\"",
                overviewDescription: "Indispensable element used to galvanize steel against corrosion.",
                propertiesDescription: "Slightly brittle metal at room temperature with a blue-silvery appearance.",
                electronConfigurationNotation: "[Ar] 3d¹⁰ 4s²",
                commonUses: ["Galvanization of steel structures", "Die-casting alloys", "Human immune enzyme cofactor"]
            ),

            // Additional Group 2 Elements so Group 2 selector `Be -> Mg -> Ca -> Sr -> Ba -> Ra` is 100% complete:
            Element(
                id: 38, symbol: "Sr", name: "Strontium", atomicMass: 87.62,
                category: .alkalineEarth, group: 2, period: 5,
                electronConfig: [2, 8, 18, 8, 2], electronegativity: 0.95, atomicRadius: 215, ionizationEnergy: 549.5,
                mnemonicTrick: "\"Beta Mange Car Scooter - Scooter\"",
                overviewDescription: "Soft, silver-yellow alkaline earth metal with brilliant red flame color.",
                propertiesDescription: "Combusts spontaneously in powdered form, vigorous reaction with water.",
                electronConfigurationNotation: "[Kr] 5s²",
                commonUses: ["Crimson red fireworks and signal flares", "Ferrite ceramic magnets", "Optical atomic clocks"]
            ),
            Element(
                id: 56, symbol: "Ba", name: "Barium", atomicMass: 137.33,
                category: .alkalineEarth, group: 2, period: 6,
                electronConfig: [2, 8, 18, 18, 8, 2], electronegativity: 0.89, atomicRadius: 222, ionizationEnergy: 502.9,
                mnemonicTrick: "\"Beta Mange Car Scooter Baap - Baap\"",
                overviewDescription: "High chemical reactivity; always stored under mineral oil or inert gas.",
                propertiesDescription: "Soft, silvery alkaline earth metal that produces an emerald-green flame.",
                electronConfigurationNotation: "[Xe] 6s²",
                commonUses: ["Barium meal medical gastrointestinal X-rays", "Drilling fluids for oil and gas wells", "Green pyrotechnic formulations"]
            ),
            Element(
                id: 88, symbol: "Ra", name: "Radium", atomicMass: 226.0,
                category: .alkalineEarth, group: 2, period: 7,
                electronConfig: [2, 8, 18, 32, 18, 8, 2], electronegativity: 0.90, atomicRadius: 228, ionizationEnergy: 509.3,
                mnemonicTrick: "\"Beta Mange Car Scooter Baap Raazi - Raazi\"",
                overviewDescription: "Intensely radioactive alkaline earth metal discovered by Marie and Pierre Curie.",
                propertiesDescription: "Pure radium is silvery-white, but blackens rapidly when exposed to air.",
                electronConfigurationNotation: "[Rn] 7s²",
                commonUses: ["Historical luminescent watch dials", "Targeted alpha therapy in medical oncology", "Radiological research"]
            )
        ]
    }
}

