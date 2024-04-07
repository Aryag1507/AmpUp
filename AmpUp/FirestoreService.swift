import Foundation
import FirebaseFirestore

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
}
