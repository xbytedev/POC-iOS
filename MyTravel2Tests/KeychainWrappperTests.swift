//
//  KeychainWrappperTests.swift
//  MyTravelTests
//
//  Created by Mrugesh Tank on 13/06/23.
//

import XCTest
@testable import MyTravel

final class KeychainWrappperTests: XCTestCase {
	func test_addItem() {
		XCTAssertTrue(KeychainWrapper.standard.set("123456", forKey: "myKey"))
		XCTAssertTrue(KeychainWrapper.standard.set("123", forKey: "myKey"))
		XCTAssertEqual(KeychainWrapper.standard.string(forKey: "myKey"), "123")
		XCTAssertTrue(KeychainWrapper.standard.remove(forKey: "myKey"))
	}
}
