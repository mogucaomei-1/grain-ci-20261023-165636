import SwiftUI

enum GrainTheme {
    static let black = Color(hex: 0x070706)
    static let surface = Color(hex: 0x131311)
    static let raised = Color(hex: 0x1D1D1A)
    static let paper = Color(hex: 0xF4EDE1)
    static let muted = Color(hex: 0x8E8B84)
    static let line = Color.white.opacity(0.09)
    static let accent = Color(hex: 0xD9774E)
}

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

extension FilmProfile {
    var uiPalette: [Color] {
        palette.map { Color(hex: $0) }
    }
}

struct GrainBackground: View {
    var body: some View {
        ZStack {
            GrainTheme.black
            RadialGradient(
                colors: [GrainTheme.accent.opacity(0.07), .clear],
                center: UnitPoint(x: 0.82, y: 0.02),
                startRadius: 0,
                endRadius: 320
            )
        }
        .ignoresSafeArea()
    }
}

struct FilmPresetChip: View {
    let profile: FilmProfile
    let selected: Bool

    var body: some View {
        VStack(spacing: 4) {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [
                        Color(hex: 0x2B2925),
                        Color(hex: 0x121210)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                RadialGradient(
                    colors: [
                        profile.uiPalette[1].opacity(0.34),
                        profile.uiPalette[0].opacity(0.10),
                        .clear
                    ],
                    center: UnitPoint(x: 0.68, y: 0.42),
                    startRadius: 1,
                    endRadius: 52
                )
                FilmCameraGlyph(profile: profile)
                    .frame(width: 76, height: 40)
            }
            .frame(width: 82, height: 42)
            .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .stroke(Color.white.opacity(selected ? 0.16 : 0.07), lineWidth: 0.8)
            }

            Text(profile.name)
                .font(.system(size: 8.2, weight: selected ? .semibold : .regular, design: .rounded))
                .foregroundStyle(selected ? GrainTheme.paper : GrainTheme.muted)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.82)
                .frame(width: 86, height: 22, alignment: .top)
        }
        .padding(4)
        .background(
            selected ? GrainTheme.raised : Color.clear,
            in: RoundedRectangle(cornerRadius: 13, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .stroke(selected ? GrainTheme.accent.opacity(0.86) : .clear, lineWidth: 1)
        }
    }
}

struct FilmCameraGlyph: View {
    let profile: FilmProfile

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let style = profile.cameraIconStyle
            let bodyWidth = width * (style == .instant ? 0.80 : 0.88)
            let bodyHeight = height * (style == .instant ? 0.66 : 0.61)
            let bodyY = height * 0.10
            let corner = height * (style == .instant ? 0.08 : 0.16)
            let lensCenterX = -width * 0.08
            let lensCenterY = height * 0.14
            let lensDiameter = height * (style == .instant ? 0.57 : 0.54)

            ZStack {
                RoundedRectangle(cornerRadius: height * 0.22, style: .continuous)
                    .fill(Color.black.opacity(0.48))
                    .frame(width: bodyWidth, height: bodyHeight)
                    .offset(y: bodyY + height * 0.09)

                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                GrainTheme.paper.opacity(0.98),
                                profile.uiPalette[2].opacity(0.68),
                                Color(hex: 0x766F64)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: bodyWidth, height: bodyHeight)
                    .overlay {
                        RoundedRectangle(cornerRadius: corner, style: .continuous)
                            .stroke(Color.white.opacity(0.33), lineWidth: 0.75)
                    }
                    .offset(y: bodyY)

                // Leatherette and grip are kept behind the lens so the camera
                // silhouette remains legible at the small preset-chip size.
                RoundedRectangle(cornerRadius: corner * 0.45, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.76),
                                Color(hex: 0x25231F).opacity(0.90)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: bodyWidth * 0.58, height: bodyHeight * 0.45)
                    .offset(x: bodyWidth * 0.11, y: bodyY + bodyHeight * 0.22)
                    .overlay {
                        VStack(spacing: bodyHeight * 0.055) {
                            ForEach(0..<4, id: \.self) { _ in
                                Capsule()
                                    .fill(Color.white.opacity(0.055))
                                    .frame(width: bodyWidth * 0.47, height: 0.45)
                            }
                        }
                        .offset(x: bodyWidth * 0.11, y: bodyY + bodyHeight * 0.21)
                    }

                // The stepped top plate and viewfinder make each camera read as
                // a complete object rather than a colour swatch.
                RoundedRectangle(cornerRadius: corner * 0.72, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                profile.uiPalette[2].opacity(0.94),
                                GrainTheme.paper.opacity(0.86),
                                profile.uiPalette[1].opacity(0.72)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(
                        width: bodyWidth * (style == .rangefinder ? 0.58 : 0.46),
                        height: bodyHeight * (style == .instant ? 0.22 : 0.18)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: corner * 0.72, style: .continuous)
                            .stroke(Color.white.opacity(0.28), lineWidth: 0.65)
                    }
                    .offset(
                        x: style == .rangefinder ? -bodyWidth * 0.12 : -bodyWidth * 0.04,
                        y: bodyY - bodyHeight * 0.56
                    )

                if style != .instant {
                    RoundedRectangle(cornerRadius: height * 0.06, style: .continuous)
                        .fill(Color(hex: 0x151713))
                        .frame(width: height * 0.22, height: height * 0.15)
                        .overlay {
                            RoundedRectangle(cornerRadius: height * 0.045, style: .continuous)
                                .stroke(profile.uiPalette[1].opacity(0.72), lineWidth: 0.7)
                                .padding(1.4)
                        }
                        .offset(
                            x: width * (style == .rangefinder ? 0.27 : 0.31),
                            y: -height * 0.17
                        )
                }

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                GrainTheme.paper.opacity(0.96),
                                profile.uiPalette[1].opacity(0.82),
                                Color(hex: 0x4A4843)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: lensDiameter, height: lensDiameter)
                    .overlay {
                        Circle()
                            .fill(Color.black.opacity(0.92))
                            .padding(height * 0.047)
                    }
                    .overlay {
                        Circle()
                            .fill(
                                AngularGradient(
                                    colors: [
                                        profile.uiPalette[0],
                                        profile.uiPalette[1],
                                        profile.uiPalette[2],
                                        profile.uiPalette[0]
                                    ],
                                    center: .center
                                )
                            )
                            .padding(height * 0.09)
                    }
                    .overlay {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        profile.uiPalette[2].opacity(0.62),
                                        Color(hex: 0x101817),
                                        Color.black
                                    ],
                                    center: UnitPoint(x: 0.34, y: 0.28),
                                    startRadius: 0,
                                    endRadius: lensDiameter * 0.44
                                )
                            )
                            .padding(height * 0.13)
                    }
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .fill(Color.white.opacity(0.34))
                            .frame(width: height * 0.075, height: height * 0.075)
                            .blur(radius: 0.35)
                            .offset(x: height * 0.15, y: height * 0.10)
                    }
                    .offset(x: lensCenterX, y: lensCenterY)

                Circle()
                    .fill(Color.white.opacity(0.92))
                    .frame(width: height * 0.055, height: height * 0.055)
                    .overlay {
                        Circle()
                            .fill(profile.uiPalette[1])
                            .padding(0.8)
                    }
                    .offset(x: -width * 0.16, y: height * 0.005)

                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(profile.uiPalette[0].opacity(0.96))
                    .frame(width: bodyWidth * 0.21, height: height * 0.08)
                    .overlay {
                        Capsule()
                            .fill(Color.white.opacity(0.24))
                            .frame(width: bodyWidth * 0.13, height: 0.55)
                    }
                    .offset(x: bodyWidth * 0.19, y: bodyY - bodyHeight * 0.34)

                Capsule()
                    .fill(Color(hex: 0x22211E))
                    .frame(width: width * 0.12, height: height * 0.075)
                    .overlay {
                        Capsule()
                            .fill(GrainTheme.paper.opacity(0.75))
                            .padding(1)
                    }
                    .offset(x: width * 0.35, y: bodyY - bodyHeight * 0.28)

                if style == .instant {
                    HStack(spacing: 0) {
                        ForEach(Array(profile.uiPalette.enumerated()), id: \.offset) { _, color in
                            Rectangle().fill(color)
                        }
                    }
                    .frame(width: bodyWidth * 0.72, height: height * 0.055)
                    .offset(x: 0, y: bodyY - bodyHeight * 0.41)
                }
            }
        }
        .shadow(color: .black.opacity(0.50), radius: 2.5, y: 2)
    }
}

private enum FilmCameraIconStyle {
    case rangefinder
    case instant
    case compact
}

private extension FilmProfile {
    var cameraIconStyle: FilmCameraIconStyle {
        switch self {
        case .dazzFxnR, .dazzCCDR, .dazzDClassic, .dazzGRDR, .dazzDFunS, .dazzClassicU:
            return .rangefinder
        case .portra, .portra160, .portra800, .nostalgicNeg, .gold, .colorPlus200:
            return .instant
        default:
            return .compact
        }
    }
}
