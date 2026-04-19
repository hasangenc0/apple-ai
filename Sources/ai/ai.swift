import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

@main
struct ai {
    static func main() async {
        let arguments = Array(CommandLine.arguments.dropFirst())

        if arguments.isEmpty {
            printUsage()
            return
        }

        if arguments.count == 1 {
            let command = arguments[0]
            if command == "--help" || command == "-h" {
                printUsage()
                return
            }

            if command == "--model-info" || command == "--status" {
#if canImport(FoundationModels)
                if #available(macOS 26.0, *) {
                    printModelInfo()
                } else {
                    print("Foundation Models require macOS 26.0 or newer.")
                }
#else
                print("This Swift toolchain does not include the FoundationModels framework.")
#endif
                return
            }

            if command.hasPrefix("-") {
                print("Error: unknown option '\(command)'.")
                printUsage()
                return
            }
        }

        let prompt = arguments.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prompt.isEmpty else {
            print("Error: prompt cannot be empty.")
            printUsage()
            return
        }

#if canImport(FoundationModels)
        if #available(macOS 26.0, *) {
            await runFoundationModel(prompt: prompt)
        } else {
            print("Error: Foundation Models require macOS 26.0 or newer.")
        }
#else
        print("Error: This Swift toolchain does not include the FoundationModels framework.")
#endif
    }

    private static func printUsage() {
        print("""
        Usage:
          ai "<prompt>"
          ai <prompt words>
          ai --model-info
          ai --status

        Example:
          ai "Who won World War II?"
        """)
    }

#if canImport(FoundationModels)
    @available(macOS 26.0, *)
    private static func printModelInfo() {
        let availability = currentModelAvailability()
        print("Model available: \(availability.shortLabel)")
        print("")
        print(availability.remediation)
    }

    @available(macOS 26.0, *)
    private static func currentModelAvailability() -> ModelAvailability {
        let model = SystemLanguageModel.default

        switch model.availability {
        case .available:
            return .available
        case .unavailable(let reason):
            switch reason {
            case .appleIntelligenceNotEnabled:
                return .appleIntelligenceNotEnabled
            case .deviceNotEligible:
                return .deviceNotEligible
            case .modelNotReady:
                return .modelNotReady
            @unknown default:
                return .unknownUnavailable
            }
        }
    }

    @available(macOS 26.0, *)
    private static func runFoundationModel(prompt: String) async {
        let availability = currentModelAvailability()

        if availability.isAvailable {
            do {
                let session = LanguageModelSession()
                let response = try await session.respond(to: prompt)
                print(response.content)
            } catch {
                print("Model request failed: \(error)")
            }
            return
        }

        print("Model unavailable: \(availability.shortLabel)")
        print("")
        print(availability.remediation)
    }
#endif
}
