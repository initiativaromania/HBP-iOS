import Foundation

class LicitatieViewController: UIViewController {
    var id: Int!
    var senderId: String!

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delaysContentTouches = false
    }
}
