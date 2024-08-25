
import SwiftUI
import Firebase

@main
struct ProjectApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoadingScreen()
        }
    }
    
}
