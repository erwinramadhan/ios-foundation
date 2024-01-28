//
//  ios_foundationUITests.swift
//  ios-foundationUITests
//
//  Created by Erwin Ramadhan Edwar Putra on 22/01/24.
//

import XCTest

final class ios_foundationUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let homeNavBarTitle = app.staticTexts["Movies"]
        XCTAssertTrue(homeNavBarTitle.exists, "Home navigation bar doesn't exist or text didn't match")
        
        let sectionTitle = app.staticTexts["Movie List"]
        XCTAssertTrue(sectionTitle.exists, "Section title doesn't exist or text didn't match")
        
        let wonkaMovieCell = app.tables.cells.containing(.staticText, identifier:"Wonka").staticTexts["Wonka"]
        XCTAssertTrue(wonkaMovieCell.exists, "Wonka movie cell doesn't exist or text didn't match")
        wonkaMovieCell.tap()
        
        let detailMovieNavBarTitle = app.staticTexts["Detail Movie"]
        XCTAssertTrue(detailMovieNavBarTitle.exists, "DetailMovie navigation bar doesn't exist or text didn't match")
        
        let movieTitle = app.staticTexts["Wonka"]
        XCTAssertTrue(movieTitle.exists, "DetailMovie title doesn't exist or text didn't match")
        let movieRating = app.staticTexts["⭐️ 7.2/10"]
        XCTAssertTrue(movieRating.exists, "DetailMovie rating doesn't exist or text didn't match")
        
        let movieCategory1 = app.staticTexts["Comedy"]
        XCTAssertTrue(movieCategory1.exists, "DetailMovie category1 doesn't exist or text didn't match")
        let movieCategory2 = app.staticTexts["Family"]
        XCTAssertTrue(movieCategory2.exists, "DetailMovie category2 doesn't exist or text didn't match")
        let movieCategory3 = app.staticTexts["Fantasy"]
        XCTAssertTrue(movieCategory3.exists, "DetailMovie category3 doesn't exist or text didn't match")
        
        let movieStatusTitle = app.staticTexts["Status"]
        XCTAssertTrue(movieStatusTitle.exists, "DetailMovie status title doesn't exist or text didn't match")
        let movieStatusValue = app.staticTexts["Released"]
        XCTAssertTrue(movieStatusValue.exists, "DetailMovie status value doesn't exist or text didn't match")
        
        let movieLanguageTitle = app.staticTexts["Language"]
        XCTAssertTrue(movieLanguageTitle.exists, "DetailMovie language title doesn't exist or text didn't match")
        let movieLanguageValue = app.staticTexts["EN"]
        XCTAssertTrue(movieLanguageValue.exists, "DetailMovie language value doesn't exist or text didn't match")
        
        let movieDateReleaseTitle = app.staticTexts["Release Date"]
        XCTAssertTrue(movieDateReleaseTitle.exists, "DetailMovie date release title doesn't exist or text didn't match")
        let movieDateReleaseValue = app.staticTexts["2023-12-06"]
        XCTAssertTrue(movieDateReleaseValue.exists, "DetailMovie date release value doesn't exist or text didn't match")
        
        let movieDescriptionTitle = app.staticTexts["Description"]
        XCTAssertTrue(movieDescriptionTitle.exists, "DetailMovie description title doesn't exist or text didn't match")
        let movieDescriptionValuePredicate = NSPredicate(format: "label BEGINSWITH[c] %@", "Willy Wonka – chock-full")
//        let movieDescriptionValue = app.staticTexts["Willy Wonka – chock-full of ideas and determined to change the world one delectable bite at a time – is proof that the best things in life begin with a dream, and if you’re lucky enough to meet Willy Wonka, anything is possible."]
        let movieDescriptionValue = app.staticTexts.element(matching: movieDescriptionValuePredicate)
        XCTAssertTrue(movieDescriptionValue.exists, "DetailMovie description value doesn't exist or text didn't match")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
