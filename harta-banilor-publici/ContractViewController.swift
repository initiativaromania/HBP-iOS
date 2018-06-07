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
    @IBOutlet weak var dataContractLabel: UILabel!
    @IBOutlet weak var valoareEUROLabel: UILabel!
    @IBOutlet weak var valoareRONLabel: UILabel!
    @IBOutlet weak var numarContractLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var companieButton: UIButton!
    @IBOutlet weak var institutieButton: UIButton!
    @IBOutlet weak var tipIncheiereLabel: UILabel!
    @IBOutlet weak var tipProceduraLabel: UILabel!
    @IBOutlet weak var separatorLabel2: UILabel!
    
    @IBOutlet weak var separatorLabel4: UILabel!
    @IBOutlet weak var separatorLabel3: UILabel!
    var contract: Contract!
    var api: ApiHelper!
    var companie: Companie!
    var institutie: Institution!
    
    @IBAction func pressedCompanieButton(_ sender: UIButton) {
        if senderId == self.companie.id {
            self.navigationController?.popViewController(animated: true)
        } else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "CompanieViewController") as! CompanieViewController
            controller.id = self.companie.id
            controller.ad = self.companie.ad
            show(controller, sender: self)
        }
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
        self.companieButton.isEnabled = false
        
        let institutionLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContractViewController.pressedInstitutieButton(_:)))
        institutieLabel.addGestureRecognizer(institutionLabelGestureRecognizer)

        let companieLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContractViewController.pressedCompanieButton(_:)))
        companieLabel.addGestureRecognizer(companieLabelGestureRecognizer)
        
        titluLabel.layer.addBorder(edge: UIRectEdge.bottom, color: .groupTableViewBackground, thickness: 0.5)
        separatorLabel.layer.addBorder(edge: UIRectEdge.bottom, color: .groupTableViewBackground, thickness: 1)
        separatorLabel2.layer.addBorder(edge: UIRectEdge.top, color: .groupTableViewBackground, thickness: 1)
        separatorLabel3.layer.addBorder(edge: UIRectEdge.bottom, color: .groupTableViewBackground, thickness: 1)
        separatorLabel4.layer.addBorder(edge: UIRectEdge.top, color: .groupTableViewBackground, thickness: 1)
        
        api.getContractByID(id: self.id) { (contract, response, error) -> Void in
            guard error == nil else {
                print(error!)
                return
            }
            self.contract = contract
            DispatchQueue.main.async {
                print("DONE Fetching contract")
                self.titluLabel.text = self.contract.titluContract
                self.titluLabel.adjustsFontSizeToFitWidth = true
                self.numarContractLabel.text = self.contract.numarContract
                self.valoareRONLabel.text = self.contract.valoareRON + " RON"
                self.valoareEUROLabel.text = self.contract.valoareEUR + " EURO"
                self.dataContractLabel.text = self.contract.dataContract
                self.cpvLabel.text = self.contract.cpvCode
                self.tipIncheiereLabel.text = self.contract.tipIncheiereContract
                self.tipProceduraLabel.text = self.contract.tipProcedura
            }
            DispatchQueue.main.async {
                //TODO Check what kind of company we get by ID
                // https://github.com/initiativaromania/HBP-web/issues/5
                self.api.getADCompany(id: self.contract.companieId) { (companie, _ respone, error) -> Void in
                    if error == nil && (companie != nil) {
                        self.companie = companie
                        DispatchQueue.main.async {
                            self.companieLabel.text = self.companie.nume
                            self.companieLabel.adjustsFontSizeToFitWidth = true
                            self.companieButton.isEnabled = true
                        }
                    } else {
                        self.api.getTenderCompany(id: self.contract.companieId) { (companie, _ response, error) -> Void in
                            if error == nil && (companie != nil) {
                                self.companie = companie
                                DispatchQueue.main.async {
                                    self.companieLabel.text = self.companie.nume
                                    self.companieLabel.adjustsFontSizeToFitWidth = true
                                    self.companieButton.isEnabled = true
                                }
                            }
                        }
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
                        self.institutieLabel.adjustsFontSizeToFitWidth = true
                        self.institutieButton.isEnabled = true
                    }
                }
            }
        }
    }
}
