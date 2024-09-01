
import Foundation

final class PagesManager {
    
    static let shared = PagesManager()
    
    private init() {}
    
    var currentAuthorizationPage: AuthorizationPages = .fields
    var currentAuthorizationPageIndex: Int {
        return AuthorizationPages.allCases.firstIndex(of: currentAuthorizationPage) ?? 0
    }
    
}
