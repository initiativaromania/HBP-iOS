import Foundation

extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
        default:
            break
        }
        border.backgroundColor = color.cgColor
        
        self.addSublayer(border)
    }
}

class ContractViewController: UIViewController {
    var id: Int!
    var senderId: Int!
    
    @IBOutlet weak var titluLabel: UILabel!
    @IBOutlet weak var institutieLabel: UILabel!
    @IBOutlet weak var companieLabel: UILabel!
    @IBOutlet weak var cpvLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var valoareEUROLabel: UILabel!
    @IBOutlet weak var valoareRONLabel: UILabel!
    @IBOutlet weak var numarContractLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var companieButton: UIButton!
    @IBOutlet weak var institutieButton: UIButton!
    
    var contract: Contract!
    var api: ApiHelper!
    var companie: Companie!
    var institutie: Institution!
    
    @IBAction func pressedCompanieButton(_ sender: UIButton) {
    }
    
    @IBAction func pressedInstitutieButton(_ sender: UIButton) {
        if senderId == self.institutie.id {
            self.navigationController?.popViewController(animated: true)
        } else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "InstitutionViewController") as! InstitutionViewController
            controller.id = self.institutie.id
            controller.institutionName = self.institutie.nume
            show(controller, sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api = ApiHelper()
        
        self.institutieButton.isEnabled = false
        
        companieLabel.layer.borderColor = UIColor(red: 116/255, green: 197/255, blue: 201/255, alpha: 1).cgColor
        companieLabel.layer.borderWidth = 0.5
        
        institutieLabel.layer.borderColor = UIColor(red: 116/255, green: 197/255, blue: 201/255, alpha: 1).cgColor
        institutieLabel.layer.borderWidth = 0.5
        
        //titluLabel.layer.borderColor = UIColor.lightGray.cgColor
        //titluLabel.layer.borderWidth = 0.5
        
        titluLabel.layer.addBorder(edge: UIRectEdge.bottom, color: .groupTableViewBackground, thickness: 0.5)
        separatorLabel.layer.addBorder(edge: UIRectEdge.top, color: .groupTableViewBackground, thickness: 0.5)
        numarContractLabel.layer.addBorder(edge: UIRectEdge.left, color: .lightGray, thickness: 0.5)
        valoareRONLabel.layer.addBorder(edge: UIRectEdge.left, color: .lightGray, thickness: 0.5)
        valoareEUROLabel.layer.addBorder(edge: UIRectEdge.left, color: .lightGray, thickness: 0.5)
        dataLabel.layer.addBorder(edge: UIRectEdge.left, color: .lightGray, thickness: 0.5)
        cpvLabel.layer.addBorder(edge: UIRectEdge.left, color: .lightGray, thickness: 0.5)
        
        api.getContractByID(id: self.id) { (contract, response, error) -> Void in
            guard error == nil else {
                print(error!)
                return
            }
            self.contract = contract
            DispatchQueue.main.async {
                print("DONE Fetching contract")
                self.titluLabel.text = self.contract.titluContract
                self.numarContractLabel.text = self.contract.numarContract
                self.valoareRONLabel.text = String(self.contract.valoareRON)
                self.valoareEUROLabel.text = String(self.contract.valoareEUR)
                self.dataLabel.text = self.contract.dataContract
                self.cpvLabel.text = self.contract.cpvCode
            }
            DispatchQueue.main.async {
                self.api.getCompanyByCUI(cui: self.contract.companieCUI) { (companie, _ respone, error) -> Void in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    self.companie = companie
                    DispatchQueue.main.async {
                        self.companieLabel.text = self.companie.nume
                    }
                }
            }
            DispatchQueue.main.async {
                self.api.getInstitutionByID(id: self.contract.institutiePublicaID) { (institutie, _ response, error) -> Void in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    self.institutie = institutie
                    DispatchQueue.main.async {
                        self.institutieLabel.text = self.institutie.nume
                        self.institutieButton.isEnabled = true
                    }
                }
            }
        }
    }
}
