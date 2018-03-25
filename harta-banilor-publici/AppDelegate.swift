import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyCoozczgogGgRz3XnercMCy-OYbiyfXYNY")
        UINavigationBar.appearance().barTintColor = UIColor(red: 80/255, green: 0/255, blue: 20/255, alpha: 1)
        return true
    }
}
