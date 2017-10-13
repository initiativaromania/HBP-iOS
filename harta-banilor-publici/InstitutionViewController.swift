import UIKit
import Foundation

let hbpBlue = UIColor(red: 133/255, green: 205/255, blue: 208/255, alpha: 1)

class ShimmerLabel: UILabel {
    var shimmer: FBShimmeringView!
    var initialColor: UIColor!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        shimmer = FBShimmeringView(frame: self.frame)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.2
        self.initialColor = self.backgroundColor
    }
    
    func startShimmer() {
        shimmer.contentView = self
        self.text = ""
        self.backgroundColor = UIColor(red: (238.0/255.0), green: (238.0/255.0), blue: (238.0/255.0), alpha: 1.0)
        shimmer.isShimmering = true
    }
    
    func stopShimmer() {
        self.backgroundColor = initialColor
        guard let _ = shimmer else { return }
        shimmer.isShimmering = false
    }
}

class TableCell: UITableViewCell {
    @IBOutlet weak var titleLabel: ShimmerLabel!
    @IBOutlet weak var priceLabel: ShimmerLabel!
    @IBOutlet weak var button: ShimmerLabel!
    var addedShimmerViews: Bool = false
    var bgview: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.bgview = UIView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.titleLabel.textColor = .white
            self.priceLabel.textColor = .white
            self.button.backgroundColor = .white
            self.button.textColor = hbpBlue
            bgview.backgroundColor = hbpBlue
            self.selectedBackgroundView = bgview
        }
        else {
            self.titleLabel.textColor = .black
            self.priceLabel.textColor = .black
            self.button.backgroundColor = hbpBlue
            self.button.textColor = .white
            bgview.backgroundColor = .white
            self.selectedBackgroundView = bgview
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.titleLabel.textColor = .white
            self.titleLabel.textColor = .white
            self.priceLabel.textColor = .white
            self.button.backgroundColor = .white
            self.button.textColor = hbpBlue
            bgview.backgroundColor = hbpBlue
            self.selectedBackgroundView = bgview
        }
        else {
            self.titleLabel.textColor = .black
            self.priceLabel.textColor = .black
            self.button.backgroundColor = hbpBlue
            self.button.textColor = .white
            bgview.backgroundColor = .white
            self.selectedBackgroundView = bgview
        }
    }
    
    func startShimmer() {
        if !addedShimmerViews {
            self.contentView.addSubview(titleLabel.shimmer)
            self.contentView.addSubview(priceLabel.shimmer)
            self.contentView.addSubview(button.shimmer)
            addedShimmerViews = true
        }
        
        titleLabel.startShimmer()
        priceLabel.startShimmer()
        button.startShimmer()

    }
    func stopShimmer() {
        titleLabel.stopShimmer()
        priceLabel.stopShimmer()
        button.stopShimmer()
    }
}

class InstitutionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var id: Int!
    var institutionName: String = ""
    var achizitiiCount: String = ""
    var licitatiiCount: String = ""
    
    @IBOutlet weak var adresaLabel: UILabel!
    @IBOutlet weak var achizitiiCountLabel: UILabel!
    @IBOutlet weak var licitatiiCountLabel: UILabel!
    @IBOutlet weak var cuiLabel: UILabel!
    @IBOutlet weak var tabBar: UISegmentedControl!
    @IBOutlet weak var institutionNameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    
    var contracte: [InstitutionContract] = []
    var licitatii: [InstitutionLicitatie] = []
    var companii: [CompanyByInstitution] = []
    var institution: Institution!
    
    var fetchedContracts: Bool = false
    var fetchedLicitatii: Bool = false
    var fetchedCompanii: Bool = false
    
    var api: ApiHelper!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        DispatchQueue.main.async {
            self.tableView.setContentOffset(.zero, animated: false)
            self.tableView.reloadData()
        }
        
        switch tabBar.selectedSegmentIndex {
        case 0:
            if contracte.count == 0 && !fetchedContracts{
                api.getInstitutionContracts(id: id) { (contracte, response, error) -> () in
                    guard error == nil else {
                        self.fetchedContracts = true
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        return
                    }
                    self.contracte = contracte
                    self.fetchedContracts = true

                    DispatchQueue.main.async {
                        NSLog("DONE Fetching contracts")
                        self.tableView.allowsSelection = true
                        self.tableView.isScrollEnabled = true
                        self.tableView.reloadData()
                    }
                }
            }
        case 1:
            if licitatii.count == 0 && !fetchedLicitatii {
                api.getInstitutionTenders(id: id) { (licitatii, response, error) -> () in
                    guard error == nil else {
                        self.fetchedLicitatii = true
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        return
                    }
                    self.licitatii = licitatii
                    self.fetchedLicitatii = true

                    DispatchQueue.main.async {
                        NSLog("DONE Fetching Licitatii")
                        self.tableView.allowsSelection = true
                        self.tableView.isScrollEnabled = true
                        self.tableView.reloadData()
                    }
                }
            }
        case 2:
            if companii.count == 0 && !fetchedCompanii {
                api.getCompaniesByInstitution(id: id) { (companii, response, error) -> () in
                    guard error == nil else {
                        self.fetchedCompanii = true
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        return
                    }
                    self.companii = companii
                    self.fetchedCompanii = true

                    DispatchQueue.main.async {
                        NSLog("DONE Fetching companii")
                        self.tableView.allowsSelection = true
                        self.tableView.isScrollEnabled = true
                        self.tableView.reloadData()
                    }
                }
            }
        default:
            break;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        api = ApiHelper()
        
        self.customizeNavBar()
        
        self.institutionNameLabel.adjustsFontSizeToFitWidth = true
        self.institutionNameLabel.minimumScaleFactor = 0.2
        self.institutionNameLabel.text = institutionName
        
        self.achizitiiCountLabel.text = achizitiiCount
        self.licitatiiCountLabel.text = licitatiiCount

        api.getInstitutionByID(id: id) { (institution, response, error) -> () in
            guard error == nil else {
                print("ERROR getting institution")
                return
            }
            self.institution = institution
            DispatchQueue.main.async {
                NSLog("DONE fetching institution")
                self.setLabels()
            }
        }
        setTableHeaderSeparator()
        
        tableView.delegate = self
        tableView.dataSource = self
        api.getInstitutionContracts(id: id) { (contracte, response, error) -> () in
            guard error == nil else {
                self.fetchedContracts = true
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            self.contracte = contracte
            DispatchQueue.main.async {
                NSLog("DONE Fetching contracts")
                self.fetchedContracts = true
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.tableView.reloadData()
            }
        }
    }
        
    private func customizeNavBar() {
        self.navigationController?.navigationBar.backItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    private func setTableHeaderSeparator() {
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        self.tableView.tableHeaderView = line
        line.backgroundColor = self.tableView.separatorColor
    }
    
    private func setLabels() {
        self.adresaLabel.text = institution.adresa
        self.adresaLabel.adjustsFontSizeToFitWidth = true
        self.adresaLabel.minimumScaleFactor = 0.2
        
        self.cuiLabel.text = institution.cui
        self.cuiLabel.adjustsFontSizeToFitWidth = true
        self.cuiLabel.minimumScaleFactor = 0.2
    }

    

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tabBar.selectedSegmentIndex {
        case 0:
            if contracte.count == 0 && !fetchedContracts { return 20 }
            return contracte.count
        case 1:
            if licitatii.count == 0 && !fetchedLicitatii { return 20 }
            return licitatii.count
        case 2:
            if companii.count == 0 && !fetchedCompanii { return 20 }
            return companii.count
        default:
            break;
        }
        return contracte.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TableCell
        
        switch tabBar.selectedSegmentIndex {
        case 0:
            if contracte.count == 0 {
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                if !fetchedContracts {
                    cell.startShimmer()
                }
                return cell
            }
            cell.stopShimmer()
            cell.titleLabel.text = contracte[indexPath.row].titluContract.capitalized(with: Locale(identifier: "ro"))
            cell.priceLabel.text = String(contracte[indexPath.row].valoareRON) + "\nRON"
            cell.button.text = ">"
            self.tableView.allowsSelection = true
            self.tableView.isScrollEnabled = true
        case 1:
            if licitatii.count == 0 {
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                if !fetchedLicitatii {
                    cell.startShimmer()
                }
                return cell
            }
            cell.stopShimmer()
            cell.titleLabel.text = licitatii[indexPath.row].titluContract
            cell.priceLabel.text = String(licitatii[indexPath.row].valoareRON) + "\nRON"
            cell.button.text = ">"
            self.tableView.allowsSelection = true
            self.tableView.isScrollEnabled = true
        case 2:
            if companii.count == 0 {
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                if !fetchedCompanii {
                    cell.startShimmer()
                }
                return cell
            }
            cell.stopShimmer()
            cell.titleLabel.text = companii[indexPath.row].nume
            cell.priceLabel.text = String(licitatii[indexPath.row].valoareRON) + "\nRON"
            cell.button.text = ">"
            self.tableView.allowsSelection = true
            self.tableView.isScrollEnabled = true
        default:
            break;
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tabBar.selectedSegmentIndex {
        case 0:
            let controller = storyboard?.instantiateViewController(withIdentifier: "ContractViewController") as! ContractViewController
            controller.id = self.contracte[indexPath.row].id
            controller.senderId = self.id
            show(controller, sender: self)
        case 1:
            let controller = storyboard?.instantiateViewController(withIdentifier: "LicitatieViewController") as! LicitatieViewController
            controller.id = self.licitatii[indexPath.row].id
            show(controller, sender: self)
        case 2:
            let controller = storyboard?.instantiateViewController(withIdentifier: "CompanieViewController") as! CompanieViewController
            controller.companieSummary = self.companii[indexPath.row]
            show(controller, sender: self)
        default:
            break
        }
    }
}
