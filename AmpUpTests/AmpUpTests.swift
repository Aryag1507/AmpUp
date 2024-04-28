//
//  AmpUpTests.swift
//  AmpUpTests
//
//  Created by Arya Gupta on 4/1/24.
//

import XCTest
import FirebaseFirestore
@testable import AmpUp

import SwiftUI

class MockFirestoreService: FirestoreServiceProtocol {
    var setDataCallCount = 0
    var addDataCallCount = 0
    var lastSetDataDocument: String?
    var lastSetDataCollection: String?
    var lastAddDataCollection: String?
    var lastSetData: [String: Any]?
    var lastAddData: [String: Any]?
    
    var mockWorkoutDataWithTitles: [(title: String, data: [Int])] = []
    var mockError: Error?
    
    var shouldReturnError: Bool = false
    var setDataWasCalled: Bool = false
    
    var lastError: Error?
    
    func setData(for document: String, in collection: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        setDataCallCount += 1
        lastSetDataDocument = document
        lastSetDataCollection = collection
        lastSetData = data
        setDataWasCalled = true
        
        if shouldReturnError {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firestore Error"])
            lastError = error
            completion(error)
        } else {
            completion(nil)
        }
    }
    
    func addData(to collection: String, data: [String: Any], completion: @escaping (Error?, String?) -> Void) {
        addDataCallCount += 1
        lastAddDataCollection = collection
        lastAddData = data

        if shouldReturnError {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firestore Error"])
            lastError = error
            completion(error, nil)
        } else {
            lastError = nil
            completion(nil, "dummyDocumentID")
        }
    }

    func listenToDocument(in collection: String, document: String, completion: @escaping ([String: Any]?, Error?) -> Void) -> ListenerRegistration {
        // Implement if needed for the test
        return ListenerRegistrationMock()
    }
    
    func addWorkoutGroup(title: String, completion: @escaping (Result<AmpUp.WorkoutGroup, any Error>) -> Void) {
        completion(.success(WorkoutGroup(title: "dummyGroup", exercises: [])))
    }
}

class MockAuthService: AuthProtocol {
    var shouldReturnError: Bool = false
    
    func createUser(withEmail email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        if shouldReturnError {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Auth Error"])
            completion(false, error)
        } else {
            completion(true, nil)
        }
    }
}


class ListenerRegistrationMock: NSObject, ListenerRegistration {
    func remove() {
    }
}

final class AmpUpTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartWorkout() throws {
        let mockFirestoreService = MockFirestoreService()
        
        let workoutGraph = WorkoutGraph(firestoreService: mockFirestoreService)
        workoutGraph.startWorkout()
        
        XCTAssertEqual(mockFirestoreService.setDataCallCount, 1)
        XCTAssertEqual(mockFirestoreService.lastSetDataCollection, "start_stop")
        XCTAssertEqual(mockFirestoreService.lastSetData?["state"] as? String, "start")
    }
    
    func testStartWorkoutWithError() throws {
        let mockFirestoreService = MockFirestoreService()
        mockFirestoreService.shouldReturnError = true

        let workoutGraph = WorkoutGraph(firestoreService: mockFirestoreService)
        workoutGraph.startWorkout()
        
        XCTAssertEqual(mockFirestoreService.setDataCallCount, 1)
        XCTAssertNotNil(mockFirestoreService.lastError)
    }
    
    func testEndWorkout() throws {
        let mockFirestoreService = MockFirestoreService()
        let workoutGraph = WorkoutGraph(firestoreService: mockFirestoreService)
        workoutGraph.workoutData = [1,2,4]
        workoutGraph.endWorkout()

        XCTAssertEqual(mockFirestoreService.setDataCallCount, 1)
        XCTAssertEqual(mockFirestoreService.lastSetDataCollection, "start_stop")
        XCTAssertEqual(mockFirestoreService.lastSetData?["state"] as? String, "stop")

        XCTAssertEqual(mockFirestoreService.addDataCallCount, 1)
        XCTAssertEqual(mockFirestoreService.lastAddDataCollection, "users/dummy6/workouts")
        XCTAssertNotNil(mockFirestoreService.lastAddData?["timestamp"])
        XCTAssertNotNil(mockFirestoreService.lastAddData?["workoutData"])

        XCTAssertTrue(workoutGraph.workoutData.isEmpty)
    }
    
    func testEndWorkoutWithError() throws {
        let mockFirestoreService = MockFirestoreService()
        mockFirestoreService.shouldReturnError = true
        
        let workoutGraph = WorkoutGraph(firestoreService: mockFirestoreService)
        workoutGraph.workoutData = [1,2,4]
        workoutGraph.endWorkout()

        XCTAssertEqual(mockFirestoreService.setDataCallCount, 1)
        XCTAssertNotNil(mockFirestoreService.lastError)
        XCTAssertEqual(mockFirestoreService.addDataCallCount, 1)
    }
    
    func testHandleSignUpSuccess() {
        let mockAuthService = MockAuthService()
        let mockFirestoreService = MockFirestoreService()
        let mockAppState = AppState()
        let signupViewModel = SignupViewModel(authService: mockAuthService, firestoreService: mockFirestoreService, appState: mockAppState)
        
        signupViewModel.email = "test@example.com"
        signupViewModel.password = "password"
        signupViewModel.confirmPassword = "password"
        
        let expectation = XCTestExpectation(description: "Signup success")
    
        signupViewModel.handleSignUp()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(mockFirestoreService.setDataWasCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testWorkoutGroup() throws {
        let mockFirestoreService = MockFirestoreService()
        let workoutGroups = Binding.constant([WorkoutGroup(title: "dummyGroup1", exercises: []), WorkoutGroup(title: "dummyGroup2", exercises: [])])
        let workoutGroupTest = AddWorkoutGroupView(workoutGroups: workoutGroups, firestoreService: mockFirestoreService)
        workoutGroupTest.addNewWorkoutGroup()
    }
    
    func testCompareWorkoutDataMore1() {
        let workouts = [
            (title: "Morning Cardio", data: [100, 16383, 200, 16383, 300]),
            (title: "Evening Yoga", data: [100, 200, 300, 400, 500])
        ]
        
        let comparisonView = CompareWorkoutsView()
        let result = comparisonView.compareWorkoutData(workout1: workouts[0], workout2: workouts[1])
        comparisonView.performComparison()
        XCTAssertEqual(result, "Morning Cardio hit the peak value more often (2 times) than Evening Yoga (0 times).")
    }
    
    func testCompareWorkoutDataLess1() {
        let workouts = [
            (title: "Morning Cardio", data: [100, 660, 200, 640, 300]),
            (title: "Evening Yoga", data: [16383, 200, 300, 16383, 500])
        ]
        
        let comparisonView = CompareWorkoutsView()
        let result = comparisonView.compareWorkoutData(workout1: workouts[0], workout2: workouts[1])
        comparisonView.performComparison()
        XCTAssertEqual(result, "Evening Yoga hit the peak value more often (2 times) than Morning Cardio (0 times).")
    }
    
    func testCompareWorkoutEqual() {
        let workouts = [
            (title: "Morning Cardio", data: [100, 200, 200, 16383, 300]),
            (title: "Evening Yoga", data: [100, 200, 16383, 400, 500])
        ]
        
        let comparisonView = CompareWorkoutsView()
        let result = comparisonView.compareWorkoutData(workout1: workouts[0], workout2: workouts[1])
        comparisonView.performComparison()
        XCTAssertEqual(result, "Both workouts hit the peak value the same number of times (1).")
    }
}
