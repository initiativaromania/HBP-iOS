import UIKit
import Foundation

class CompanieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var companieSummary: CompanyByInstitution?
    
    @IBOutlet weak var adresaLabel: UILabel!
    @IBOutlet weak var cuiLabel: UILabel!
    @IBOutlet weak var tabBar: UISegmentedControl!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet var tableView: UITableView!

    let cellReuseIdentifier = "cell"
    
    var institutii: [InstitutionByCompany] = []
    var contracte: [CompanyContract] = []
    var licitatii: [CompanyLicitatie] = []
    
    var fetchedInstitutii: Bool = false
    var fetchedContracts: Bool = false
    var fetchedLicitatii: Bool = false
    
    var api: ApiHelper!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch tabBar.selectedSegmentIndex {
        case 0:
            if institutii.count == 0 && !fetchedInstitutii {
                api.getInstitutionsByCompany(cui: (companieSummary?.cui)!) { (institutii) -> () in
                    self.institutii = institutii
                    DispatchQueue.main.async {
                        NSLog("DONE Fetching Institutions")
                        self.tableView.allowsSelection = true
                        self.tableView.isScrollEnabled = true
                        self.tableView.reloadData()
                    }
                }
            }
        case 1:
            if contracte.count == 0 && !fetchedContracts {
                api.getCompanyContracts(cui: (companieSummary?.cui)!) { (contracte) -> () in
                    self.contracte = contracte
                    DispatchQueue.main.async {
                        NSLog("DONE Fetching Contracts")
                        self.tableView.allowsSelection = true
                        self.tableView.isScrollEnabled = true
                        self.tableView.reloadData()
                    }
                }
            }
        case 2:
            if licitatii.count == 0 && !fetchedLicitatii {
                api.getCompanyTenders(cui: (companieSummary?.cui)!) { (licitatii) -> () in
                    self.licitatii = licitatii
                    DispatchQueue.main.async {
                        NSLog("DONE Fetching Licitatii")
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
        self.setLabels()
        
        self.companyNameLabel.adjustsFontSizeToFitWidth = true
        self.companyNameLabel.minimumScaleFactor = 0.2
        self.companyNameLabel.text = companieSummary?.nume
        
        setTableHeaderSeparator()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        api.getInstitutionsByCompany(cui: (companieSummary?.cui)!) { (institutii) -> () in
            self.institutii = institutii
            DispatchQueue.main.async {
                NSLog("DONE Fetching Institutions")
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.tableView.reloadData()
            }
        }
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
    
    private func setLabels() {
        self.adresaLabel.text = companieSummary?.adresa
        self.adresaLabel.adjustsFontSizeToFitWidth = true
        self.adresaLabel.minimumScaleFactor = 0.2
        
        self.cuiLabel.text = companieSummary?.cui
        self.cuiLabel.adjustsFontSizeToFitWidth = true
        self.cuiLabel.minimumScaleFactor = 0.2
    }
            
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tabBar.selectedSegmentIndex {
        case 0:
            if institutii.count == 0 && !fetchedInstitutii { return 15 }
            return institutii.count
        case 1:
            if contracte.count == 0 && !fetchedContracts { return 15 }
            return contracte.count
        case 2:
            if licitatii.count == 0 && !fetchedLicitatii { return 15 }
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
            if institutii.count == 0 {
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                if !fetchedInstitutii {
                    cell.startShimmer()
                }
                return cell
            }
            cell.stopShimmer()
            cell.titleLabel.text = institutii[indexPath.row].nume
            cell.button.text = ">"
            self.tableView.allowsSelection = true
            self.tableView.isScrollEnabled = true
        case 1:
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
        case 2:
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
}
