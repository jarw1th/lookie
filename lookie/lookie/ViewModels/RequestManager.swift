
import Foundation
import SystemConfiguration

final class RequestManager: ObservableObject {
    
    static let shared = RequestManager()
    
    @Published private(set) var alertType: String = ""
    
    @discardableResult
    func checkInternetConnectivity(withDelay: Bool = false) -> Bool {
        if withDelay {
            Thread.sleep(forTimeInterval: 2.0)
        }
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
    
    func resetAlert() {
        alertType = ""
   }
    
}
