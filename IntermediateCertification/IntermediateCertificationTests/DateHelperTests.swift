//
//  IntermediateCertificationTests.swift
//  IntermediateCertificationTests
//
//  Created by Ринат on 04.09.2023.
//

@testable import IntermediateCertification
import XCTest

class DateHelperTests: XCTestCase {
    private var dateHelper: DateHelper!

    override func setUp() {
        super.setUp()
        dateHelper = DateHelper()
    }

    override func tearDown() {
        dateHelper = nil
        super.tearDown()
    }

    func testDataValid() throws {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let date = df.date(from: "04.09.2023 23:59:59")
        let retString = DateHelper.getDateString(date: date)
        XCTAssertEqual("04.09.2023, 23:59:59", retString, "Даты должны быть равны!")
    }

    func testDataInvalid() throws {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let date = df.date(from: "04.09.2023 23:59:59")
        let retString = DateHelper.getDateString(date: date)
        XCTAssertNotEqual("04.09.2024, 23:59:59", retString, "Даты не должны быть равны!")
    }
}
