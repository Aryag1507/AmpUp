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

    func testChangeGroup() throws {
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

        let changeGroupButton = app.buttons["sample ChangeGroup"]
        changeGroupButton.tap()
        XCTAssertTrue(changeGroupButton.exists, "Change Group button not found")
        
        let switchGroup = app.buttons["Calves"]
        let exists3 = NSPredicate(format: "exists == 1")
        expectation(for: exists3, evaluatedWith: switchGroup, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(switchGroup.exists, "The options for change group should exist.")
        switchGroup.tap()
    }

    func testWorkout() throws {
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
        
        let tricepButton = app.buttons["Triceps"]
        let existsTricep = NSPredicate(format: "exists == true")
        expectation(for: existsTricep, evaluatedWith: tricepButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(tricepButton.exists, "Tricep Workout Group does not exist")
        tricepButton.tap()
        
        let tricepButton2 = app.buttons["Tricep Pulldowns"]
        let existsTricepPic = NSPredicate(format: "exists == true")
        expectation(for: existsTricepPic, evaluatedWith: tricepButton2, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(tricepButton2.exists, "Tricep Pulldown Picture does not exist")
        tricepButton2.tap()
    }
    
    func testCompareWorkoutView() throws {
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
                
        let compareWorkouts = app.buttons["Compare Workouts"]
        let existsCompare = NSPredicate(format: "exists == 1")
        expectation(for: existsCompare, evaluatedWith: compareWorkouts, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(compareWorkouts.exists, "The 'Compare Workout' button should exist.")
        compareWorkouts.tap()
    }
    
    func testWorkoutHistory() throws {
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
                
        let compareWorkouts = app.buttons["Workout History"]
        let existsCompare = NSPredicate(format: "exists == 1")
        expectation(for: existsCompare, evaluatedWith: compareWorkouts, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(compareWorkouts.exists, "The 'Workout History' button should exist.")
        compareWorkouts.tap()
    }
    
    func testSignup() throws {
        let app = XCUIApplication()
        app.launch()
        
        let signUp = app.buttons["Sign Up"]
        let existsSignup = NSPredicate(format: "exists == true")
        
        expectation(for: existsSignup, evaluatedWith: signUp, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)  // Adjust timeout as necessary

        XCTAssertTrue(signUp.exists, "Signup Button does not exist")
        signUp.tap()
        
    }
    
    func testSignOut() throws {
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
        
        let profileTab = app.tabBars.buttons["Profile"]
        let existsProfile = NSPredicate(format: "exists == true")
        
        expectation(for: existsProfile, evaluatedWith: profileTab, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(profileTab.exists, "Profile tab does not exist")
        profileTab.tap()
        
        let signOutButton = app.buttons["Sign Out"]
        let exists1 = NSPredicate(format: "exists == 1")
        expectation(for: exists1, evaluatedWith: signOutButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(signOutButton.exists, "The 'Sign Out' button should exist.")
        signOutButton.tap()
    }
    
    func testExerciseShow() throws {
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
        
        let tricepGroup = app.buttons["Triceps"]
        let exists2 = NSPredicate(format: "exists == 1")
        expectation(for: exists2, evaluatedWith: tricepGroup, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(tricepGroup.exists, "The Tricep workout group is not visible.")
        tricepGroup.tap()
        
        let tricepPulldown = app.buttons["Tricep Pulldowns"]
        let exists3 = NSPredicate(format: "exists == 1")
        expectation(for: exists3, evaluatedWith: tricepPulldown, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(tricepPulldown.exists, "The Tricep workout group is not visible.")
        tricepPulldown.tap()
    }
    
    func testAddDeleteWorkoutGroup() throws {
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
        
        let addGroup = app.buttons["Add Workout Group"]
        let exists2 = NSPredicate(format: "exists == 1")
        expectation(for: exists2, evaluatedWith: addGroup, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(addGroup.exists, "The add workout group button is not visible.")
        addGroup.tap()
        
        let titleField = app.textFields["Workout Group Title"]
        XCTAssertTrue(titleField.exists, "The workout group text field should exist.")
        
        titleField.tap()
        titleField.typeText("Shoulders")

        let addButton = app.buttons["Add Workout Group Button"]
        let exists3 = NSPredicate(format: "exists == 1")
        expectation(for: exists3, evaluatedWith: addButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(addButton.exists, "The add workout group button is not visible.")
        addButton.tap()
        
        let deleteButton = app.buttons["Delete Shoulders Workout Group"]
        let exists4 = NSPredicate(format: "exists == 1")
        expectation(for: exists4, evaluatedWith: deleteButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(deleteButton.exists, "The delete workout group button is not visible.")
        deleteButton.tap()
    }

    func testWorkoutStartPauseEnd() throws {
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
                
        let navigateWorkout = app.buttons["NavigateToWorkouts"]
        let exists1 = NSPredicate(format: "exists == 1")
        expectation(for: exists1, evaluatedWith: navigateWorkout, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(navigateWorkout.exists, "The 'Navigate to Workouts' button should exist.")
        navigateWorkout.tap()
        
        let startWorkout = app.buttons["Start Workout"]
        let exists2 = NSPredicate(format: "exists == 1")
        expectation(for: exists2, evaluatedWith: startWorkout, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(startWorkout.exists, "The 'Start Workout' button should exist.")
        startWorkout.tap()
        
        let pauseWorkout = app.buttons["Pause Workout"]
        let exists3 = NSPredicate(format: "exists == 1")
        expectation(for: exists3, evaluatedWith: pauseWorkout, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(startWorkout.exists, "The 'Pause Workout' button should exist.")
        pauseWorkout.tap()
        
        startWorkout.tap()
        
        let endWorkout = app.buttons["End Workout"]
        let exists4 = NSPredicate(format: "exists == 1")
        expectation(for: exists4, evaluatedWith: endWorkout, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(endWorkout.exists, "The 'End Workout' button should exist.")
        endWorkout.tap()
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
