import Foundation

class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
override func viewDidAppear(_ animated: Bool) {
    //sleep(1)
    let tabBar = self.storyboard!.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
    present(tabBar, animated: false, completion: nil)
    }
}
