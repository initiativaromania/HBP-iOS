import Foundation

class LicitatieViewController: UIViewController {
    var id: Int!
    var senderId: Int!
    var userDefaults: UserDefaults!
    var api: ApiHelper!
    var licitatie: Licitatie!
    var companie: Companie!
    var institutie: Institution!

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
    @IBOutlet weak var dataAnuntParticipareLabel: UILabel!
    @IBOutlet weak var tipContractLabel: UILabel!
    @IBOutlet weak var numarAnuntParticipareLabel: UILabel!
    @IBOutlet weak var dataAnuntAtribuire: UILabel!
    @IBOutlet weak var criteriiAtribuireLabel: UILabel!
    @IBOutlet weak var numarOfertePrimiteLabel: UILabel!
    @IBOutlet weak var subcontractLabel: UILabel!
    @IBOutlet weak var valoareEstimataLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cereJustificareButton: UIButton!
    
    @IBOutlet weak var numarAnuntAtribuireLabel: UILabel!
    
    @IBAction func pressedSemnaleazaButton(_ sender: Any) {
        let alreadySemnalat = self.userDefaults.bool(forKey: "licitatie_" + String(id))
        if alreadySemnalat {
            let alert = UIAlertController(title: "Ai mai semnalat acest contract.", message: "Mulțumim!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.api.semnaleazaTender(tenderId: id)
            userDefaults.set(true, forKey: "licitatie_" + String(id))
            
            let alert = UIAlertController(title: "Contractul a fost semnalat.", message: "Mulțumim!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
            self.cereJustificareButton.setTitle("Semnaleaza (" + String(self.licitatie.numarJustificari+1) + ")", for: .normal)
        }

    }
    
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
        scrollView.delaysContentTouches = false
        userDefaults = UserDefaults.standard
        
        let institutionLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContractViewController.pressedInstitutieButton(_:)))
        institutieLabel.addGestureRecognizer(institutionLabelGestureRecognizer)
        
        let companieLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContractViewController.pressedCompanieButton(_:)))
        companieLabel.addGestureRecognizer(companieLabelGestureRecognizer)
        
        titluLabel.layer.addBorder(edge: UIRectEdge.bottom, color: .groupTableViewBackground, thickness: 1)
        separatorLabel.layer.addBorder(edge: UIRectEdge.bottom, color: .groupTableViewBackground, thickness: 1)
        separatorLabel2.layer.addBorder(edge: UIRectEdge.top, color: .groupTableViewBackground, thickness: 1)
        separatorLabel3.layer.addBorder(edge: UIRectEdge.bottom, color: .groupTableViewBackground, thickness: 1)
        separatorLabel4.layer.addBorder(edge: UIRectEdge.top, color: .groupTableViewBackground, thickness: 1)
        tipIncheiereLabel.adjustsFontSizeToFitWidth = true
        dataAnuntAtribuire.adjustsFontSizeToFitWidth = true
        
        api.getLicitatieByID(id: self.id) { (licitatie, response, error) -> Void in
            guard error == nil else {
                print(error!)
                return
            }
            self.licitatie = licitatie
            DispatchQueue.main.async {
                print("DONE Fetching Licitatie")
                self.titluLabel.text = self.licitatie.titluContract
                self.titluLabel.adjustsFontSizeToFitWidth = true
                self.numarContractLabel.text = self.licitatie.numarContract
                self.valoareRONLabel.text = self.licitatie.valoareRON + " RON"
                self.valoareEUROLabel.text = self.licitatie.valoareEUR + " EURO"
                self.dataContractLabel.text = self.licitatie.dataContract
                self.cpvLabel.text = self.licitatie.cpvCode
                self.tipIncheiereLabel.text = self.licitatie.tipIncheiereContract
                self.tipProceduraLabel.text = self.licitatie.tipProcedura
                self.tipContractLabel.text = self.licitatie.tipContract
                self.numarAnuntParticipareLabel.text = self.licitatie.numarAnuntParticipare
                self.dataAnuntParticipareLabel.text = self.licitatie.dataAnuntParticipare
                self.numarAnuntAtribuireLabel.text = self.licitatie.numarAnuntAtribuire
                self.dataAnuntAtribuire.text = self.licitatie.dataAnuntAtribuire
                self.criteriiAtribuireLabel.text = self.licitatie.tipCriteriiAtribuire
                self.numarOfertePrimiteLabel.text = String(self.licitatie.numarOfertePrimite)
                self.subcontractLabel.text = String(self.licitatie.subcontractat)
                self.valoareEstimataLabel.text = self.licitatie.valoareEstimataParticipare
                self.cereJustificareButton.setTitle("Semnaleaza (" + String(self.licitatie.numarJustificari) + ")", for: .normal)
            }
            DispatchQueue.main.async {
                //TODO Check what kind of company we get by ID
                // https://github.com/initiativaromania/HBP-web/issues/5
                self.api.getADCompany(id: self.licitatie.companieId) { (companie, _ respone, error) -> Void in
                    if error == nil && (companie != nil) {
                        self.companie = companie
                        DispatchQueue.main.async {
                            self.companieLabel.text = self.companie.nume
                            self.companieLabel.adjustsFontSizeToFitWidth = true
                            self.companieButton.isEnabled = true
                        }
                    } else {
                        self.api.getTenderCompany(id: self.licitatie.companieId) { (companie, _ response, error) -> Void in
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
                self.api.getInstitutionByID(id: self.licitatie.institutiePublicaID) { (institutie, _ response, error) -> Void in
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
