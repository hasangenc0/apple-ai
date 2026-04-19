import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

@main
struct ai {
    private enum Command {
        case help
        case modelInfo
        case interactive(initialPrompt: String?)
        case prompt(String)
        case unknownOption(String)
    }

    static func main() async {
        let command = parse(arguments: Array(CommandLine.arguments.dropFirst()))

        switch command {
        case .help:
            printUsage()
        case .modelInfo:
#if canImport(FoundationModels)
            if #available(macOS 26.0, *) {
                printModelInfo()
            } else {
                print("Foundation Models require macOS 26.0 or newer.")
            }
#else
            print("This Swift toolchain does not include the FoundationModels framework.")
#endif
        case .interactive(let initialPrompt):
#if canImport(FoundationModels)
            if #available(macOS 26.0, *) {
                await runInteractiveMode(initialPrompt: initialPrompt)
            } else {
                print("Foundation Models require macOS 26.0 or newer.")
            }
#else
            print("This Swift toolchain does not include the FoundationModels framework.")
#endif
        case .prompt(let prompt):
#if canImport(FoundationModels)
            if #available(macOS 26.0, *) {
                await runFoundationModel(prompt: prompt)
            } else {
                print("Error: Foundation Models require macOS 26.0 or newer.")
            }
#else
            print("Error: This Swift toolchain does not include the FoundationModels framework.")
#endif
        case .unknownOption(let option):
            print("Error: unknown option '\(option)'.")
            printUsage()
        }
    }

    private static func printUsage() {
        print("""
        Usage:
          ai "<prompt>"
          ai <prompt words>
          ai --model-info
          ai --status
          ai --interactive
          ai -i

        Example:
          ai "Summarize why on-device AI can improve privacy in 3 bullet points."
        """)
    }

    private static func parse(arguments: [String]) -> Command {
        guard !arguments.isEmpty else { return .help }
        if arguments.contains("--help") || arguments.contains("-h") {
            return .help
        }

        if arguments.contains("--model-info") || arguments.contains("--status") {
            return arguments.count == 1 ? .modelInfo : .unknownOption("--model-info")
        }

        let interactiveRequested = arguments.contains("--interactive") || arguments.contains("-i")
        let nonFlagArguments = arguments.filter { !$0.hasPrefix("-") }
        let firstUnknownFlag = arguments.first { $0.hasPrefix("-") && $0 != "--interactive" && $0 != "-i" }

        if let firstUnknownFlag {
            return .unknownOption(firstUnknownFlag)
        }

        let prompt = nonFlagArguments.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)

        if interactiveRequested {
            return .interactive(initialPrompt: prompt.isEmpty ? nil : prompt)
        }

        return prompt.isEmpty ? .help : .prompt(prompt)
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
    private static func runInteractiveMode(initialPrompt: String?) async {
        let availability = currentModelAvailability()
        guard availability.isAvailable else {
            print("Model unavailable: \(availability.shortLabel)")
            print("")
            print(availability.remediation)
            return
        }

        var session = LanguageModelSession()

        print("Interactive mode started. Type /exit to quit, /new to reset conversation.")

        if let initialPrompt {
            do {
                let response = try await session.respond(to: initialPrompt)
                print("ai> \(response.content)")
            } catch {
                print("Model request failed: \(error)")
            }
        }

        while true {
            FileHandle.standardOutput.write(Data("you> ".utf8))
            guard let line = readLine() else {
                print("")
                print("Goodbye.")
                return
            }

            if line.isEmpty {
                continue
            }

            switch line {
            case "/exit", "/quit":
                print("Goodbye.")
                return
            case "/new":
                session = LanguageModelSession()
                print("Started a new conversation.")
                continue
            default:
                break
            }

            do {
                let response = try await session.respond(to: line)
                print("ai> \(response.content)")
            } catch {
                print("Model request failed: \(error)")
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
