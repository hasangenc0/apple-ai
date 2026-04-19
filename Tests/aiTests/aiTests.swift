import Testing
@testable import ai

@Test("isAvailable reports only available")
func isAvailableSemantics() {
    #expect(ModelAvailability.available.isAvailable)
    #expect(!ModelAvailability.modelNotReady.isAvailable)
}

@Test("shortLabel is stable")
func shortLabelValues() {
    #expect(ModelAvailability.available.shortLabel == "yes")
    #expect(ModelAvailability.appleIntelligenceNotEnabled.shortLabel == "no (Apple Intelligence not enabled)")
    #expect(ModelAvailability.deviceNotEligible.shortLabel == "no (device not eligible)")
    #expect(ModelAvailability.modelNotReady.shortLabel == "no (model not ready - still downloading?)")
    #expect(ModelAvailability.unknownUnavailable.shortLabel == "no (unknown reason)")
}

@Test("remediation includes actionable guidance")
func remediationMessages() {
    #expect(ModelAvailability.appleIntelligenceNotEnabled.remediation.contains("Apple Intelligence"))
    #expect(ModelAvailability.deviceNotEligible.remediation.contains("Apple Silicon"))
    #expect(ModelAvailability.modelNotReady.remediation.contains("Wi-Fi and power"))
    #expect(ModelAvailability.unknownUnavailable.remediation.contains("ai --model-info"))
}
