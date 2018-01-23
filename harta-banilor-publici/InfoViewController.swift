import Foundation

class InfoViewController: UIViewController {
    var imageVector: [UIImage] = []
    var animatedImage: UIImage!
    @IBOutlet weak var infoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...119 {
            let image_name = "splash_" + String(i)
            self.imageVector.append(UIImage(named: image_name)!)
        }
        animatedImage = UIImage.animatedImage(with: imageVector, duration: 4)
        infoImageView.image = animatedImage
        infoImageView.animationRepeatCount = 0
        //infoImageView.frame = CGRect(x: self.view.bounds.minX, y: self.view.frame.size.height/2 - self.view.bounds.width/2, width: self.view.bounds.width, height: self.view.bounds.width)
        
    }
}
