//
//  AmpUpTests.swift
//  AmpUpTests
//
//  Created by Arya Gupta on 4/1/24.
//

import XCTest
import FirebaseFirestore
@testable import AmpUp

class MockFirestoreService: FirestoreServiceProtocol {
    var setDataCallCount = 0
    var addDataCallCount = 0
    var lastSetDataDocument: String?
    var lastSetDataCollection: String?
    var lastAddDataCollection: String?
    var lastSetData: [String: Any]?
    var lastAddData: [String: Any]?
    
    func setData(for document: String, in collection: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        setDataCallCount += 1
        lastSetDataDocument = document
        lastSetDataCollection = collection
        lastSetData = data
        completion(nil) // Simulate success
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
        // Setup initial state if necessary, e.g., viewModel.workoutData = [1, 2, 3]

        workoutGraph.endWorkout()

        // Verify that setData was called to stop the workout
        XCTAssertEqual(mockFirestoreService.setDataCallCount, 1)
        XCTAssertEqual(mockFirestoreService.lastSetDataCollection, "start_stop")
        XCTAssertEqual(mockFirestoreService.lastSetDataDocument, "0")
        XCTAssertEqual(mockFirestoreService.lastSetData?["state"] as? String, "stop")

        // Verify that addData was called to add the workout session
        XCTAssertEqual(mockFirestoreService.addDataCallCount, 1)
        XCTAssertEqual(mockFirestoreService.lastAddDataCollection, "users/dummy3/workouts")
        // Here, you might want to check specific fields in `lastAddData`, like the presence of "timestamp" and "workoutData"
        XCTAssertNotNil(mockFirestoreService.lastAddData?["timestamp"])
        XCTAssertNotNil(mockFirestoreService.lastAddData?["workoutData"])

        // Optionally, verify the workoutData is reset/empty after ending the workout
        XCTAssertTrue(workoutGraph.workoutData.isEmpty)
    }
    func testWorkoutGroup() throws {
        let mockFirestoreService = MockFirestoreService()
        let workoutGroups = [WorkoutGroup(title: "dummyGroup1", exercises: []), WorkoutGroup(title: "dummyGroup2", exercises: [])]
        let workoutGroupTest = AddWorkoutGroupView(workoutGroups: workoutGroups, firestoreService: mockFirestoreService)
        workoutGroupTest.addNewWorkoutGroup()
    }
}
