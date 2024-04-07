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
    
    func setData(for document: String, in collection: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        setDataCallCount += 1
        lastSetDataDocument = document
        lastSetDataCollection = collection
        lastSetData = data
        
        setDataWasCalled = true
        if shouldReturnError {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firestore Error"])
            completion(error)
        } else {
            completion(nil)
        }
    }
    
    func addData(to collection: String, data: [String: Any], completion: @escaping (Error?, String?) -> Void) {
        addDataCallCount += 1
        lastAddDataCollection = collection
        lastAddData = data
        completion(nil, "dummyDocumentID") // Simulate success and document ID creation
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
        // Mock implementation
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
        // Create an instance of the mock service
        let mockFirestoreService = MockFirestoreService()
        
        // Assume WorkoutGraphViewModel exists and startWorkout has been moved to it
        let workoutGraph = WorkoutGraph(firestoreService: mockFirestoreService)
        
        // Call startWorkout
        workoutGraph.startWorkout()
        
        // Verify that setData was called once
        XCTAssertEqual(mockFirestoreService.setDataCallCount, 1)
        
        // Verify that setData was called with the correct parameters
        XCTAssertEqual(mockFirestoreService.lastSetDataCollection, "start_stop")
        XCTAssertEqual(mockFirestoreService.lastSetDataDocument, "0")
        XCTAssertEqual(mockFirestoreService.lastSetData?["state"] as? String, "start")
    }
    
    func testEndWorkout() throws {
        let mockFirestoreService = MockFirestoreService()
        let workoutGraph = WorkoutGraph(firestoreService: mockFirestoreService)
        workoutGraph.workoutData = [1,2,4]
        workoutGraph.endWorkout()

        // Verify that setData was called to stop the workout
        XCTAssertEqual(mockFirestoreService.setDataCallCount, 1)
        XCTAssertEqual(mockFirestoreService.lastSetDataCollection, "start_stop")
        XCTAssertEqual(mockFirestoreService.lastSetDataDocument, "0")
        XCTAssertEqual(mockFirestoreService.lastSetData?["state"] as? String, "stop")

        // Verify that addData was called to add the workout session
        XCTAssertEqual(mockFirestoreService.addDataCallCount, 1)
        XCTAssertEqual(mockFirestoreService.lastAddDataCollection, "users/dummy6/workouts")
        // Here, you might want to check specific fields in `lastAddData`, like the presence of "timestamp" and "workoutData"
        XCTAssertNotNil(mockFirestoreService.lastAddData?["timestamp"])
        XCTAssertNotNil(mockFirestoreService.lastAddData?["workoutData"])

        // Optionally, verify the workoutData is reset/empty after ending the workout
        XCTAssertTrue(workoutGraph.workoutData.isEmpty)
    }
    
    func testHandleSignUpSuccess() {
        let mockAuthService = MockAuthService()
        let mockFirestoreService = MockFirestoreService()
        let mockAppState = AppState() // Assuming AppState is instantiable like this
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

//    func testFetchWorkoutDataSuccess() {
//        // Mock service setup
//        let mockService = MockFirestoreService()
//        // Adjust mock data to match expected structure: [(title: String, data: [Int])]
//        mockService.mockWorkoutDataWithTitles = [("Workout 1", [10, 20, 30]), ("Workout 2", [40, 50, 60])]
//
//        let prev = PreviousWorkouts(firestoreService: mockService)
//
//        let expectation = XCTestExpectation(description: "Fetch workout data with titles")
//        prev.fetchWorkoutData()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            XCTAssertEqual(prev.workoutDataWithTitles.count, Optional(2), "workoutDataWithTitles should contain data for 2 workouts")
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 5.0)
//    }
    

}
