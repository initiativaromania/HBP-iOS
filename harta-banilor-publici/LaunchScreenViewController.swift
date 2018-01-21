import Foundation

class LaunchScreenViewController: UIViewController {
    @IBOutlet weak var launchImageView: UIImageView!
    var animatedImage: UIImage!
    var imageVector:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...119 {
            let image_name = "splash_" + String(i)
            imageVector.append(UIImage(named: image_name)!)
        }
        animatedImage = UIImage.animatedImage(with: imageVector, duration: 4)
        launchImageView.image = animatedImage
        //launchImageView.frame = CGRect(x: 0, y: self.view.frame.size.height/2 - self.view.bounds.width/2, width: self.view.bounds.width, height: self.view.bounds.width)
        
    }
override func viewDidAppear(_ animated: Bool) {
    sleep(1)
    let tabBar = self.storyboard!.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
    present(tabBar, animated: false, completion: nil)
}
}
