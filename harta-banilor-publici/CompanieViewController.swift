import UIKit
import Foundation

class CompanieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var companieSummary: CompanyByInstitution?
    
    @IBOutlet weak var adresaLabel: UILabel!
    @IBOutlet weak var cuiLabel: UILabel!
    @IBOutlet weak var tabBar: UISegmentedControl!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch tabBar.selectedSegmentIndex {
        case 0:
            populateInstitutii()
        case 1:
            populateContracte()
        case 2:
            populateLicitatii()
        default:
            break;
        }
    }
    let cellReuseIdentifier = "cell"
    
    var institutii: [InstitutionByCompany] = []
    var contracte: [CompanyContract] = []
    var licitatii: [CompanyLicitatie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeNavBar()
        self.setLabels()
        
        self.companyNameLabel.adjustsFontSizeToFitWidth = true
        self.companyNameLabel.minimumScaleFactor = 0.2
        self.companyNameLabel.text = companieSummary?.nume
        
        setTableHeaderSeparator()
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchInstitutii()
    }
    
    func customizeNavBar() {
        self.navigationController?.navigationBar.backItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
        
    func setTableHeaderSeparator() {
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        self.tableView.tableHeaderView = line
        line.backgroundColor = self.tableView.separatorColor
        
    }
    
    func populateInstitutii() {
        tableView.reloadData()

        if institutii.count == 0 {
            self.tableView.allowsSelection = false
            self.tableView.isScrollEnabled = false

            fetchInstitutii()
        }
    }
    
    func populateContracte() {
        tableView.reloadData()

        if contracte.count == 0 {
            self.tableView.allowsSelection = false
            self.tableView.isScrollEnabled = false

            fetchContracte()
        }
    }
    
    func populateLicitatii() {
        tableView.reloadData()

        if licitatii.count == 0 {
            self.tableView.allowsSelection = false
            self.tableView.isScrollEnabled = false

            fetchLicitatii()
        }
    }
    
    func fetchInstitutii() {
        let url_str = "https://hbp-api.azurewebsites.net/api/InstitutionsByCompany/" + (companieSummary?.cui)!
        NSLog("Fetching Institutions: " + url_str)
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
            
            self.institutii = try! JSONDecoder().decode([InstitutionByCompany].self, from: data)
            
            DispatchQueue.main.async {
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.tableView.reloadData()
            }

        }
        task.resume()
    }
    
    func fetchContracte() {
        NSLog("Fetching Contracts")
        let url_str = "https://hbp-api.azurewebsites.net/api/CompanyContracts/" + (companieSummary?.cui)!
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
            
            self.contracte = try! JSONDecoder().decode([CompanyContract].self, from: data)
            
            self.contracte.sort(by: { $0.valoareRON > $1.valoareRON})
            
            DispatchQueue.main.async {
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func fetchLicitatii() {
        NSLog("Fetching Licitatii")
        
        let url_str = "https://hbp-api.azurewebsites.net/api/CompanyTenders/" + (companieSummary?.cui)!
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
            
            self.licitatii = try! JSONDecoder().decode([CompanyLicitatie].self, from: data)
            self.licitatii.sort(by: { $0.valoareRON > $1.valoareRON})
            
            DispatchQueue.main.async {
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
            guard institutii.count > 0 else {
                return 15
            }
            return institutii.count
        case 1:
            guard contracte.count > 0 else {
                return 15
            }
            return contracte.count
        case 2:
            guard licitatii.count > 0 else {
                return 15
            }
            return licitatii.count
        default:
            break;
        }
        return institutii.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TableCell
        switch tabBar.selectedSegmentIndex {
        case 0:
            guard institutii.count > 0 else {
                cell.startShimmer()
                break
            }
            cell.stopShimmer()
            cell.titleLabel.text = institutii[indexPath.row].nume
            cell.button.text = ">"
        case 1:
            guard contracte.count > 0 else {
                cell.startShimmer()
                break
            }
            cell.stopShimmer()
            cell.titleLabel.text = contracte[indexPath.row].titluContract.capitalized(with: Locale(identifier: "ro"))
            cell.priceLabel.text = String(contracte[indexPath.row].valoareRON) + "\nRON"
            cell.button.text = ">"
        case 2:
            guard licitatii.count > 0 else {
                cell.startShimmer()
                break
            }
            cell.stopShimmer()
            cell.titleLabel.text = licitatii[indexPath.row].titluContract
            cell.priceLabel.text = String(licitatii[indexPath.row].valoareRON) + "\nRON"
            cell.button.text = ">"
        default:
            break;
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tabBar.selectedSegmentIndex {
        case 0:
            let controller = storyboard?.instantiateViewController(withIdentifier: "InstitutionViewController") as! InstitutionViewController
            controller.id = "1" //String(institutii[indexPath.row].id)
            controller.institutionName = institutii[indexPath.row].nume
            show(controller, sender: self)
        default:
            break;
        }
    }
    
    private func setLabels() {
        self.adresaLabel.text = companieSummary?.adresa
        self.adresaLabel.adjustsFontSizeToFitWidth = true
        self.adresaLabel.minimumScaleFactor = 0.2
        
        self.cuiLabel.text = companieSummary?.cui
        self.cuiLabel.adjustsFontSizeToFitWidth = true
        self.cuiLabel.minimumScaleFactor = 0.2
    }
}

