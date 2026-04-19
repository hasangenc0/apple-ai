import Foundation

/// Mirrors the public availability states exposed by Apple Foundation Models.
/// This stays framework-agnostic so messaging remains testable and reusable.
enum ModelAvailability: Sendable, Equatable {
    case available
    case appleIntelligenceNotEnabled
    case deviceNotEligible
    case modelNotReady
    case unknownUnavailable

    var isAvailable: Bool {
        self == .available
    }

    var shortLabel: String {
        switch self {
        case .available:
            return "yes"
        case .appleIntelligenceNotEnabled:
            return "no (Apple Intelligence not enabled)"
        case .deviceNotEligible:
            return "no (device not eligible)"
        case .modelNotReady:
            return "no (model not ready - still downloading?)"
        case .unknownUnavailable:
            return "no (unknown reason)"
        }
    }

    var remediation: String {
        switch self {
        case .available:
            return "Model is ready for requests."
        case .appleIntelligenceNotEnabled:
            return """
                Apple Intelligence is not turned on for this Mac.

                Fix:
                  1. Open System Settings > Apple Intelligence & Siri
                  2. Turn Apple Intelligence ON
                  3. Ensure Device Language and Siri Language are set to the same supported language
                  4. Wait for the on-device model download to complete (keep your Mac on Wi-Fi and power)

                Details: https://support.apple.com/en-us/121115
                """
        case .deviceNotEligible:
            return """
                This Mac is not eligible for Apple Intelligence.

                Apple Intelligence requires an Apple Silicon Mac (M1 or later).
                Intel Macs are not supported.

                Details: https://support.apple.com/en-us/121115
                """
        case .modelNotReady:
            return """
                The on-device model is still downloading or not yet ready.

                Fix:
                  1. Keep your Mac on Wi-Fi and power
                  2. Check System Settings > Apple Intelligence & Siri for download progress
                  3. Try again in a few minutes

                Details: https://support.apple.com/en-us/121115
                """
        case .unknownUnavailable:
            return """
                The model reported an unknown unavailable reason.

                Try:
                  - Updating macOS and Xcode
                  - Checking System Settings > Apple Intelligence & Siri
                  - Re-running: ai --model-info
                """
        }
    }
}
