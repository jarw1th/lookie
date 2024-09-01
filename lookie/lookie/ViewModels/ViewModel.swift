
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SDWebImageSwiftUI

@MainActor
final class ViewModel: ObservableObject {
    
    static let shared = ViewModel()
    
    @State private var aiManager: AIManager = AIManager()
    @State private var networkManager: NetworkManager = NetworkManager()
    
    @Published private(set) var userSession: FirebaseAuth.User?
    @Published private(set) var currentUser: User?
    @State var selectedFeedType: FeedType = .none
    
    private let db = Firestore.firestore()
    
    @Published private(set) var shortLooks: [ShortLook] = []
    private(set) var lastShortLookDocument: DocumentSnapshot?
    
    init() {
        self.userSession = Auth.auth().currentUser
        configureImageCache()
    }
    
    private func configureImageCache() {
        let cache = SDImageCache(namespace: "tiny")
        cache.config.maxDiskAge = 24 * 60 * 60
        cache.config.maxDiskSize = 100 * 1024 * 1024
        SDImageCachesManager.shared.addCache(cache)
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
                !self.shortLooks.contains(where: { $0.id == newLook.id })
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
            let validImages = images.compactMap { $0 }
            let uploadedImageUrls = try await uploadImages(images)

            let tags = await withTaskGroup(of: String?.self) { group -> [String] in
                for image in validImages {
                    group.addTask {
                        return try? await self.aiManager.analyzeImage(image: image)
                    }
                }

                var combinedTags: [String] = []
                for await tag in group {
                    if let tag = tag {
                        combinedTags.append(tag)
                    }
                }
                return combinedTags
            }
            
            let newShortLook = ShortLook(
                id: nil,
                imageUrls: uploadedImageUrls,
                isLiked: false,
                feedType: feedType,
                tags: tags
            )
            
            let _ = try db.collection("shortLook").addDocument(from: newShortLook)

            DispatchQueue.main.async {
                self.shortLooks.append(newShortLook)
            }
        } catch {
            print("Error creating ShortLook: \(error)")
        }
    }
    
    func imageData(from image: UIImage) -> Data? {
        // Attempt to get JPEG data first
        if let jpegData = image.jpegData(compressionQuality: 0.9) {
            return jpegData
        }
        
        // Fallback to PNG data if JPEG conversion fails
        return image.pngData()
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
            
            if let index = shortLooks.firstIndex(where: { $0.id == look.id }) {
                shortLooks[index] = look
            }
            
            DispatchQueue.main.async {
                completion?()
            }
        } catch {
            print("Error updating document: \(error)")
        }
    }
    
    func update(_ look: ShortLook) async {
        await update(look, completion: nil)
    }
    
    func generateImage(_ text: String) async -> String {
        let imageUrl = try? await networkManager.generateImage(prompt: text)
        return imageUrl ?? ""
    }
    
}

