import UIKit
import Foundation

class ShimmerLabel: UILabel {
    var shimmer: FBShimmeringView!
    var initialColor: UIColor!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        shimmer = FBShimmeringView(frame: self.frame)
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.2
    }
    
    func startShimmer() {
        shimmer.contentView = self
        self.text = ""
        self.initialColor = self.backgroundColor
        self.backgroundColor = UIColor(red: (238.0/255.0), green: (238.0/255.0), blue: (238.0/255.0), alpha: 1.0)
        shimmer.isShimmering = true
    }
    
    func stopShimmer() {
        guard let _ = shimmer else { return }
        shimmer.isShimmering = false
        self.backgroundColor = initialColor
    }
}

class TableCell: UITableViewCell {
    @IBOutlet weak var titleLabel: ShimmerLabel!
    @IBOutlet weak var priceLabel: ShimmerLabel!
    @IBOutlet weak var button: ShimmerLabel!
    var addedShimmerViews: Bool = false

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
    var id: String = ""
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
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadData()
        switch tabBar.selectedSegmentIndex {
        case 0:
            if contracte.count == 0 && !fetchedContracts {
                fetchInstitutionContracts()
            }
        case 1:
            if licitatii.count == 0 && !fetchedLicitatii {
                fetchLicitatii()
            }
        case 2:
            if companii.count == 0 && !fetchedCompanii {
                fetchCompanii()
            }
        default:
            break;
        }
    }
    
    let cellReuseIdentifier = "cell"
    
    var contracte: [InstitutionContract] = []
    var licitatii: [InstitutionLicitatie] = []
    var companii: [CompanyByInstitution] = []
    var institution: Institution!
    
    var fetchedContracts: Bool = false
    var fetchedLicitatii: Bool = false
    var fetchedCompanii: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeNavBar()
        
        self.institutionNameLabel.adjustsFontSizeToFitWidth = true
        self.institutionNameLabel.minimumScaleFactor = 0.2
        self.institutionNameLabel.text = institutionName
        
        self.achizitiiCountLabel.text = achizitiiCount
        self.licitatiiCountLabel.text = licitatiiCount

        fetchInstitution(id: id)

        setTableHeaderSeparator()
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchInstitutionContracts()
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

    
    func fetchInstitution(id: String!) {
        let url_str = "https://hbp-api.azurewebsites.net/api/InstitutionByID/" + id!
        NSLog("Fetching Institution: " + url_str)
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            self.institution = try! JSONDecoder().decode([Institution].self, from: data)[0]
            DispatchQueue.main.async {
                NSLog("DONE fetching institution")
                self.setLabels()
            }
        }
        task.resume()
    }
    
    func fetchInstitutionContracts() {
        NSLog("Fetching Contracts")
        let url_str = "https://hbp-api.azurewebsites.net/api/InstitutionContracts/" + id
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    self.fetchedContracts = true
                    self.tableView.reloadData()
                }
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            self.contracte = try! JSONDecoder().decode([InstitutionContract].self, from: data)
            
            self.contracte.sort(by: { $0.valoareRON > $1.valoareRON})
            DispatchQueue.main.async {
                NSLog("DONE Fetching contracts")
                self.fetchedContracts = true
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func fetchLicitatii() {
        NSLog("Fetching Licitatii")

        let url_str = "https://hbp-api.azurewebsites.net/api/InstitutionTenders/" + id
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    self.fetchedLicitatii = true
                    self.tableView.reloadData()
                }
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            self.licitatii = try! JSONDecoder().decode([InstitutionLicitatie].self, from: data)
            self.licitatii.sort(by: { $0.valoareRON > $1.valoareRON})
            
            DispatchQueue.main.async {
                NSLog("DONE Fetching Licitatii")
                self.fetchedLicitatii = true
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func fetchCompanii() {
        NSLog("Fetching Companii")
        let url_str = "https://hbp-api.azurewebsites.net/api/CompaniesByInstitution/" + id
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    self.fetchedCompanii = true
                    self.tableView.reloadData()
                }
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            self.companii = try! JSONDecoder().decode([CompanyByInstitution].self, from: data)
            
            DispatchQueue.main.async {
                NSLog("DONE Fetching companii")
                self.fetchedCompanii = true
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tabBar.selectedSegmentIndex {
        case 0:
            if contracte.count == 0 && !fetchedContracts { return 15 }
            return contracte.count
        case 1:
            if licitatii.count == 0 && !fetchedLicitatii { return 15 }
            return licitatii.count
        case 2:
            if companii.count == 0 && !fetchedCompanii { return 15 }
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
            controller.contractSummary = self.contracte[indexPath.row]
            show(controller, sender: self)
        case 1:
            let controller = storyboard?.instantiateViewController(withIdentifier: "LicitatieViewController") as! LicitatieViewController
            controller.licitatieSummary = self.licitatii[indexPath.row]
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
