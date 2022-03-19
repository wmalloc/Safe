import XCTest
@testable import Safe

final class SafeTests: XCTestCase {
    func testKeychain() throws {
        let keychain = Keychain(service: "Safe")
        var username = keychain["username"]
        XCTAssertNil(username)
        
        keychain["username"] = "wmalloc"
        username = keychain["username"]
        XCTAssertNotNil(username)
    }
}
