
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

@MainActor
class ViewModel: ObservableObject {
    
    static let shared = ViewModel()
    
    @Published private(set) var userSession: FirebaseAuth.User?
    @Published private(set) var currentUser: User?
    @Published var selectedFeedType: FeedType = .none
    
    private let db = Firestore.firestore()
    
    @Published private(set) var shortLooks: [ShortLook] = []
    private(set) var lastShortLookDocument: DocumentSnapshot?
    
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
    
    func fetchShortLook(_ limit: Int = 20) async {
        do {
            var query = db.collection("shortLook").limit(to: limit)
            
            if let lastDocument = lastShortLookDocument {
                query = query.start(afterDocument: lastDocument)
            }

            let snapshot = try await query.getDocuments()
            let documents = snapshot.documents
            
            self.lastShortLookDocument = documents.last
            
            let newShortLooks = documents.compactMap { document in
                do {
                    var shortLook = try document.data(as: ShortLook.self)
                    shortLook.id = document.documentID
                    return shortLook
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }
            
            let uniqueLooks = newShortLooks.filter { newLook in
                !self.shortLooks.contains(newLook)
            }
            
            DispatchQueue.main.async {
                self.shortLooks.append(contentsOf: uniqueLooks)
            }
        } catch {
            print("Error fetching documents: \(error)")
        }
    }
    
    func createShortLook(images: [UIImage?], feedType: String) async {
        do {
            let uploadedImageUrls = try await uploadImages(images)

            let newShortLook = ShortLook(
                id: nil,
                imageUrls: uploadedImageUrls,
                isLiked: false,
                feedType: feedType
            )
            
            let _ = try db.collection("shortLook").addDocument(from: newShortLook)

            DispatchQueue.main.async {
                self.shortLooks.append(newShortLook)
            }
        } catch {
            print("Error creating ShortLook: \(error)")
        }
    }
    
    private func uploadImages(_ images: [UIImage?]) async throws -> [String] {
        let images: [UIImage] = images.compactMap { $0 }
        var imageURLs: [String] = []
        
        for (index, image) in images.enumerated() {
            let storageRef = Storage.storage().reference().child("shortLooks/\(UUID().uuidString)/image\(index).jpg")
            
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                continue
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
            let downloadURL = try await storageRef.downloadURL()
            imageURLs.append(downloadURL.absoluteString)
        }
        
        return imageURLs
    }
    
    func update(_ look: ShortLook, completion: (() -> Void)?) async {
        do {
            var look = look
            look.isLiked.toggle()
            
            guard let id = look.id else {
                print("Document ID is nil")
                return
            }
            
            let document = db.collection("shortLook").document(id)
            
            try document.setData(from: look, merge: false)
            
            completion?()
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    func update(_ look: ShortLook) async {
        await update(look, completion: nil)
    }
    
}

