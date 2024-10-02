import Testing
@testable import XpertFive9Chat

@Test("XpertFive9ChatConfigurationTest")
func configInitialization() {
    // test default five9Enabled init
    let config1 = XpertChatConfiguration(
        xpertKey: "xpertKey-test",
        useCase: "useCase-test",
        segmentKey: "segmentKey-test"
    )
    #expect(config1.xpertKey == "xpertKey-test")
    #expect(config1.useCase == "useCase-test")
    #expect(config1.segmentKey == "segmentKey-test")
    #expect(config1.five9Enabled == true)
    #expect(config1.useCaseString == """
        chatApi: {
            payloadParams: {
                use_case: 'useCase-test'    },
        },
        """)

    // test five9Enabled = false init
    // test empty useCase
    let config2 = XpertChatConfiguration(
        xpertKey: "",
        useCase: "",
        segmentKey: "",
        five9Enabled: false
    )
    #expect(config2.five9Enabled == false)
    #expect(config2.useCaseString == "")

    // test complex useCase
    let config3 = XpertChatConfiguration(
        xpertKey: "",
        useCase: "['useCase-test1', 'useCase-test2']",
        segmentKey: ""
    )
    #expect(config3.useCaseString == """
        chatApi: {
            payloadParams: {
                use_case: ['useCase-test1', 'useCase-test2']    },
        },
        """)
}
