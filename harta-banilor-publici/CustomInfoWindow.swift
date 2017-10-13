import Foundation
import UIKit

protocol CustomInfoWindowDelegate: class {
    func callSegueFromInfoWindow()
}

class CustomInfoWindow: UIView {
    var id: Int!
    var institusionName: String = ""
        
    @IBOutlet weak var intitutionNameLabel: UILabel!
    @IBOutlet weak var achizitiiDirecteLabel: UILabel!
    @IBOutlet weak var licitatiiLabel: UILabel!
    weak var delegate: CustomInfoWindowDelegate?
    
    @IBAction func press(_ sender: UIButton) {
        if delegate != nil {
            delegate?.callSegueFromInfoWindow()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadView() -> CustomInfoWindow{
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?[0] as! CustomInfoWindow
        return customInfoWindow
    }
}
