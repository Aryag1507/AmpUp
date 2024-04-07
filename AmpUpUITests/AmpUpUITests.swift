//
//  AmpUpUITests.swift
//  AmpUpUITests
//
//  Created by Arya Gupta on 4/7/24.
//

import XCTest

final class AmpUpUITests: XCTestCase {

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
        
        // Find the email text field by its accessibility identifier
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists, "The email text field should exist.")
        
        emailTextField.tap()
        emailTextField.typeText("keeg@gmail.com")
        
        // Find the password text field by its accessibility identifier
        let passwordSecureField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureField.exists, "The password text field should exist.")
        
        passwordSecureField.tap()
        passwordSecureField.typeText("123456")
        
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists, "The login button should exist.")

        loginButton.press(forDuration: 0.3)
                
        let addWorkoutButton = app.buttons["NavigateToWorkouts"]
        let exists1 = NSPredicate(format: "exists == 1")
        expectation(for: exists1, evaluatedWith: addWorkoutButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(addWorkoutButton.exists, "The 'Add Workout' button should exist.")
        addWorkoutButton.tap()
        
        let allExercisesButton = app.navigationBars.buttons["NavigateToAllExercises"]
        let exists2 = NSPredicate(format: "exists == 1")
        expectation(for: exists2, evaluatedWith: allExercisesButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(allExercisesButton.exists, "The 'All Exercises' navigation link is not visible.")
        allExercisesButton.tap()

        let changeGroupButton = app.buttons["ChangeGroup"].firstMatch // Use .firstMatch if there are multiple instances
        changeGroupButton.tap()
        XCTAssertTrue(changeGroupButton.exists, "Change Group button not found")

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
