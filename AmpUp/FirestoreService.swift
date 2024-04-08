import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FirestoreServiceProtocol {
    func setData(for document: String, in collection: String, data: [String: Any], completion: @escaping (Error?) -> Void)
    func addData(to collection: String, data: [String: Any], completion: @escaping (Error?, String?) -> Void)
    func listenToDocument(in collection: String, document: String, completion: @escaping ([String: Any]?, Error?) -> Void) -> ListenerRegistration
    func addWorkoutGroup(title: String, completion: @escaping (Result<WorkoutGroup, Error>) -> Void)
    }


class FirestoreService: FirestoreServiceProtocol {
    func setData(for document: String, in collection: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection(collection).document(document).setData(data, completion: completion)
    }
    
    func addData(to collection: String, data: [String: Any], completion: @escaping (Error?, String?) -> Void) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection(collection).addDocument(data: data) { error in
            completion(error, ref?.documentID)
        }
    }
    
    func listenToDocument(in collection: String, document: String, completion: @escaping ([String: Any]?, Error?) -> Void) -> ListenerRegistration {
        let db = Firestore.firestore()
        let docRef = db.collection(collection).document(document)
        
        return docRef.addSnapshotListener { documentSnapshot, error in
            guard let snapshot = documentSnapshot else {
                completion(nil, error)
                return
            }
            completion(snapshot.data(), nil)
        }
    }
    
    func addWorkoutGroup(title: String, completion: @escaping (Result<WorkoutGroup, Error>) -> Void) {
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "title": title
        ]
        
        db.collection("workouts").addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                let newGroup = WorkoutGroup(title: title, exercises: [])
                completion(.success(newGroup))
            }
        }
    }
    
    func fetchWorkouts(for userID: String, completion: @escaping ([(title: String, data: [Int])]?, Error?) -> Void) {
            let db = Firestore.firestore()
            db.collection("users").document(userID).collection("workouts")
                .order(by: "timestamp", descending: true)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        completion(nil, error)
                    } else {
                        var fetchedWorkouts: [(title: String, data: [Int])] = []
                        for document in querySnapshot!.documents {
                            if let workoutArray = document.data()["workoutData"] as? [Int],
                               let title = document.data()["title"] as? String {
                                fetchedWorkouts.append((title: title, data: workoutArray))
                            }
                        }
                        completion(fetchedWorkouts, nil)
                    }
                }
        }
}

protocol AuthProtocol {
    func createUser(withEmail email: String, password: String, completion: @escaping (Bool, Error?) -> Void)
}

class AuthManager: AuthProtocol {
    func createUser(withEmail email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(authResult != nil, error)
        }
    }
}
