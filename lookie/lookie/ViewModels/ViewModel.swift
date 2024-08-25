
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@MainActor
class ViewModel: ObservableObject {
    
    static let shared = ViewModel()
    
    @Published private(set) var userSession: FirebaseAuth.User?
    @Published private(set) var currentUser: User?
    
    private let db = Firestore.firestore()
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(with email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            try await createUser(with: email, password: password)
        }
    }
    
    func createUser(with email:String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await db.collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("Authorization Error: \(error.localizedDescription)")
        }
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Signout Error: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await db.collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func fetchUser(by id: String) async -> User? {
        guard id != "" else { return nil }
        guard let snapshot = try? await db.collection("users").document(id).getDocument() else { return nil }
        let dict = snapshot.data()
        let email = dict?["email"] as? String ?? ""
        let uid = dict?["id"] as? String
        return User(id: uid ?? "", email: email)
    }
    
}
