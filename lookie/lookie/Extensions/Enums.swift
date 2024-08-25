
import Foundation

enum TabType {
    
    case home, search, profile
    
}

enum FeedType: CaseIterable {
    
    case none, stylists, outfits, shoes
    
    func text() -> String? {
        switch self {
        case .none:
            return nil
        case .stylists:
            return "Stylists"
        case .outfits:
            return "Outfits"
        case .shoes:
            return "Shoes"
        }
    }
    
    func isPremium() -> Bool {
        switch self {
        case .none:
            return false
        case .stylists:
            return true
        case .outfits:
            return false
        case .shoes:
            return false
        }
    }
    
}

enum AuthorizationErrorType {
    
    case password, email
    
    func text() -> String {
        switch self {
        case .password:
            return "invalid password*"
        case .email:
            return "invalid email*"
        }
    }
    
}
