import SwiftUI

@main
struct GRAINApp: App {
    @StateObject private var editor = EditorViewModel()
    @AppStorage("didCompletePermissionOnboarding") private var didCompletePermissionOnboarding = false

    var body: some Scene {
        WindowGroup {
            Group {
                if didCompletePermissionOnboarding {
                    RootView()
                        .environmentObject(editor)
                } else {
                    PermissionOnboardingView {
                        didCompletePermissionOnboarding = true
                    }
                }
            }
            .preferredColorScheme(.dark)
            .onAppear(perform: GrainHaptics.prepare)
        }
    }
}
