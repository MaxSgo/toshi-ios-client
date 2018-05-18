import XCTest
import UIKit
import Teapot
@testable import Toshi

class AddTokenTests: XCTestCase {

    func testAddToken() {
        guard let testCereal = Cereal(words: ["abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "abandon", "about"]) else {
            XCTFail("failed to create cereal")
            return
        }

        Cereal.setSharedCereal(testCereal)

        let mockTeapot = MockTeapot(bundle: Bundle(for: IDAPIClientTests.self), mockFilename: "")
        mockTeapot.overrideEndPoint("timestamp", withFilename: "timestamp")
        
        let ethereumAPIClient = EthereumAPIClient(mockTeapot: mockTeapot)

        let expectation = XCTestExpectation(description: "adds a custom token")

        let address = "0x4d8fc1453a0f359e99c9675954e656d80d996fbf"
        ethereumAPIClient.addToken(with: address) { success, error in
            XCTAssertTrue(success)
            expectation.fulfill()
         }
        
        wait(for: [expectation], timeout: 10.0)
    }

    func testGetTokenWithAddress() {
        let mockTeapot = MockTeapot(bundle: Bundle(for: IDAPIClientTests.self), mockFilename: "0x4d8fc1453a0f359e99c9675954e656d80d996fbf")
        let ethereumAPIClient = EthereumAPIClient(mockTeapot: mockTeapot)

        let expectation = XCTestExpectation(description: "gets token info by address")

        let address = "0x4d8fc1453a0f359e99c9675954e656d80d996fbf"
        ethereumAPIClient.getToken(with: address) { token, _ in
            guard let token = token else {
                XCTFail("nil token")
                return
            }
            XCTAssertEqual(token.name, "Bee")
            XCTAssertEqual(token.decimals, 18)
            XCTAssertEqual(token.symbol, "BEE")
            expectation.fulfill()
         }

        wait(for: [expectation], timeout: 10.0)
    }
}