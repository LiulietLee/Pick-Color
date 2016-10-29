//
//  Pick_ColorUITests.swift
//  Pick ColorUITests
//
//  Created by Liuliet.Lee on 23/8/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import XCTest

class Pick_ColorUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasic() {
        let toggleMenu = app.navigationBars["pick color"].children(matching: .button).element(boundBy: 0)
        let swRevealMenu = app.tables
        let memoNavigationBar = app.navigationBars["memo"]

        // Reset memo
        toggleMenu.tap()
        swRevealMenu.staticTexts["memo"].tap()
        memoNavigationBar.buttons["ic delete"].tap()
        app.buttons["Yes"].tap()
        memoNavigationBar.buttons["ic menu"].tap()
        swRevealMenu.staticTexts["picker"].tap()

        // Collect Color
        app.buttons["select an image"].tap()
        app.cells["Moments"].tap()
        app.collectionViews["PhotosGridView"].cells["Photo, Landscape, March 12, 2011, 7:17 PM"].tap()
        app.buttons["pick this color"].tap() // Simulate picking a color
        app.buttons["pick this color"].tap()

        // Save Color
        app.navigationBars["Pick_Color.CurrentColorView"].buttons["ic bookmark border"].tap()
        app.textFields["title here"].typeText("coffee")
        app.buttons["save"].tap()

        // Back to memo
        app.buttons["pick color"].tap()
        toggleMenu.tap()
        swRevealMenu.staticTexts["memo"].tap()

        // Edit
        let coffeeMemo = app.tables.staticTexts["coffee"]
        coffeeMemo.tap()
        
        app.buttons["ic mode edit"].tap()
        app.sliders["53%"].adjust(toNormalizedSliderPosition: 1)

        app.buttons["ic bookmark"].tap()
        app.textFields["coffee"].press(forDuration: 1.2)
        app.menuItems["Select All"].tap()
        app.typeText("red")
        app.buttons["save"].tap()

        app.buttons["ic mode edit"].tap()

        // Switch Language
        app.buttons["Swift"].tap()
        XCTAssertTrue(app.staticTexts["UIColor(red: 1.0, "].exists)
        app.buttons["ObjC"].tap()
        XCTAssertTrue(app.staticTexts["[UIColor colorWithRed:1.0 "].exists)
        app.buttons["C#"].tap()
        XCTAssertTrue(app.staticTexts["Color.FromArgb(1.0,  "].exists)

        // Export
        app.buttons["copy"].tap()
        app.buttons["Done"].tap()

        // Check if name updated
        app.buttons["memo"].tap()
        XCTAssertFalse(coffeeMemo.exists)
    }

}
