import Foundation

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var companieResults:[CompanyByInstitution] = []
    var institutionResults:[Institution] = []
    var contractResults:[InstitutionContract] = []
    var licitatieResults:[InstitutionLicitatie] = []
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchingInstitutions: Bool = false
    var isSearchingCompanies: Bool = false
    var isSearchingContracts: Bool = false
    var isSearchingLicitatii: Bool = false
    
    var api: ApiHelper!

    //@IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api = ApiHelper()
        
        searchController.searchBar.scopeButtonTitles = ["Instituții", "Companii", "Contracte", "Licitații"]
        searchController.searchBar.placeholder = "Caută..."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        if #available(iOS 11.0, *) {
            searchController.dimsBackgroundDuringPresentation = false
            self.definesPresentationContext = true

            searchController.searchBar.tintColor = .white
            searchController.searchBar.barTintColor = .white

            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                textfield.textColor = .gray
                textfield.tintColor = .gray
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    backgroundview.backgroundColor = .white
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
        }
        else {
            
            /*definesPresentationContext = true
            searchBar.tintColor = .white
            searchBar.placeholder = "Cauta..."
            tableView.tableHeaderView = searchBar
            searchBar.scopeButtonTitles = ["Instituții", "Companii", "Contracte", "Licitații"]
            searchBar.sizeToFit()
            searchBar.delegate = self
            tableView.tableHeaderView = searchBar*/
            //self.navigationItem.titleView = searchBar
            //self.navigationController?.extendedLayoutIncludesOpaqueBars = true
            //tableView.tableHeaderView = searchController.searchBar
            //tableView.sectionHeaderHeight = UITableViewAutomaticDimension
            
            // add searchBar to navigationBar
            
            // call sizeToFit.. this will set the frame of the searchBar to exactly the same as the size of the allowable frame of the navigationBar
            searchBar.sizeToFit()

            searchBar.barTintColor = UIColor(red: 116/255, green: 197/255, blue: 201/255, alpha: 1)
            searchBar.tintColor = .white
            searchBar.isTranslucent = true
            searchBar.layer.borderWidth = 0;

            searchBar.scopeButtonTitles = ["Instituții", "Companii", "Contracte", "Licitații"]
            tableView.tableHeaderView = searchBar
            automaticallyAdjustsScrollViewInsets = false
            // now reframe the searchBar to add some margins
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        switch searchController.searchBar.selectedScopeButtonIndex {
        case 0:
            isSearchingInstitutions = true
            self.tableView.reloadData()

            api.searchInstitution(pattern: searchBar.text!) { (institutionResults, response, error) -> () in
                guard error == nil else {
                    self.isSearchingInstitutions = false
                    self.institutionResults = []
                    DispatchQueue.main.async {
                     self.tableView.allowsSelection = false
                     self.tableView.isScrollEnabled = false
                     self.tableView.reloadData()
                    }
                    return
                }
                self.institutionResults = institutionResults
                self.isSearchingInstitutions = false
                
                DispatchQueue.main.async{
                    NSLog("DONE Fetching Institutions")
                    self.tableView.allowsSelection = true
                    self.tableView.isScrollEnabled = true
                    self.tableView.reloadData()
                }
            }
        case 1:
            isSearchingCompanies = true
            self.tableView.reloadData()

            api.searchCompanies(pattern: searchBar.text!) { (companieResults, response, error) -> () in
                guard error == nil else {
                    self.isSearchingCompanies = false
                    self.companieResults = []
                    DispatchQueue.main.async {
                        self.tableView.allowsSelection = false
                        self.tableView.isScrollEnabled = false
                        self.tableView.reloadData()
                    }
                    return
                }
                self.companieResults = companieResults
                self.isSearchingCompanies = false

                DispatchQueue.main.async{
                    NSLog("DONE Fetching Companies")
                    self.tableView.allowsSelection = true
                    self.tableView.isScrollEnabled = true
                    self.tableView.reloadData()
                }
            }
        case 2:
            isSearchingContracts = true
            self.tableView.reloadData()

            api.searchContracts(pattern: searchBar.text!) { (contractResults, response, error) -> () in
                guard error == nil else {
                    self.isSearchingContracts = false
                    self.contractResults = []
                    DispatchQueue.main.async {
                        self.tableView.allowsSelection = false
                        self.tableView.isScrollEnabled = false
                        self.tableView.reloadData()
                    }
                    return
                }
                self.contractResults = contractResults
                self.isSearchingContracts = false

                DispatchQueue.main.async{
                    NSLog("DONE Fetching Contracts")
                    self.tableView.allowsSelection = true
                    self.tableView.isScrollEnabled = true
                    self.tableView.reloadData()
                }
            }
        case 3:
            isSearchingLicitatii = true
            self.tableView.reloadData()

            api.searchLicitatii(pattern: searchBar.text!) { (licitatieResults, response, error) -> () in
                guard error == nil else {
                    self.isSearchingLicitatii = false
                    self.licitatieResults = []
                    DispatchQueue.main.async {
                        self.tableView.allowsSelection = false
                        self.tableView.isScrollEnabled = false
                        self.tableView.reloadData()
                    }
                    return
                }
                self.licitatieResults = licitatieResults
                self.isSearchingLicitatii = false

                DispatchQueue.main.async{
                    NSLog("DONE Fetching Licitatii")
                    self.tableView.allowsSelection = true
                    self.tableView.isScrollEnabled = true
                    self.tableView.reloadData()
                }
            }
        default:
            break
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        institutionResults = []
        companieResults = []
        tableView.reloadData()
    }
    
    func setupSearchBarSize(){
        self.searchController.searchBar.frame.size.width = self.view.frame.size.width
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            if institutionResults.count == 0 {
                self.isSearchingInstitutions = true
                self.tableView.reloadData()

                api.searchInstitution(pattern: searchBar.text!) { (institutionResults, response, error) -> () in
                    guard error == nil else {
                        self.isSearchingInstitutions = false
                        self.institutionResults = []
                        DispatchQueue.main.async {
                            self.tableView.allowsSelection = false
                            self.tableView.isScrollEnabled = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                    self.institutionResults = institutionResults
                    self.isSearchingInstitutions = false
                    DispatchQueue.main.async{
                        NSLog("DONE Fetching Institutions")
                        self.tableView.allowsSelection = true
                        self.tableView.isScrollEnabled = true
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                if isSearchingCompanies || isSearchingContracts || isSearchingLicitatii {
                    self.tableView.allowsSelection = true
                    self.tableView.isScrollEnabled = true
                    self.tableView.reloadData()
                }
            }
        case 1:
            if companieResults.count == 0 {
                self.isSearchingCompanies = true
                self.tableView.reloadData()
                
                api.searchCompanies(pattern: searchBar.text!) { (companieResults, response, error) -> () in
                    guard error == nil else {
                        self.isSearchingCompanies = false
                        self.companieResults = []
                        DispatchQueue.main.async {
                            self.tableView.allowsSelection = false
                            self.tableView.isScrollEnabled = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                    self.companieResults = companieResults
                    self.isSearchingCompanies = false
                    
                    DispatchQueue.main.async{
                        NSLog("DONE Fetching Companies")
                        self.tableView.allowsSelection = true
                        self.tableView.isScrollEnabled = true
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                if isSearchingInstitutions || isSearchingContracts || isSearchingLicitatii {
                    self.tableView.allowsSelection = true
                    self.tableView.isScrollEnabled = true
                    self.tableView.reloadData()
                }
            }
        case 2:
            if contractResults.count == 0 {
                self.isSearchingContracts = true
                self.tableView.reloadData()
                
                api.searchContracts(pattern: searchBar.text!) { (contractResults, response, error) -> () in
                    guard error == nil else {
                        self.isSearchingContracts = false
                        self.contractResults = []
                        DispatchQueue.main.async {
                            self.tableView.allowsSelection = false
                            self.tableView.isScrollEnabled = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                    self.contractResults = contractResults
                    self.isSearchingContracts = false
                    
                    DispatchQueue.main.async{
                        NSLog("DONE Fetching Contracts")
                        self.tableView.allowsSelection = true
                        self.tableView.isScrollEnabled = true
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                if isSearchingInstitutions || isSearchingCompanies || isSearchingLicitatii {
                    self.tableView.allowsSelection = true
                    self.tableView.isScrollEnabled = true
                    self.tableView.reloadData()
                }
            }
        case 3:
            if licitatieResults.count == 0 {
                self.isSearchingLicitatii = true
                self.tableView.reloadData()
                api.searchLicitatii(pattern: searchBar.text!) { (licitatieResults, response, error) -> () in
                    guard error == nil else {
                        self.isSearchingLicitatii = false
                        self.licitatieResults = []
                        DispatchQueue.main.async {
                            self.tableView.allowsSelection = false
                            self.tableView.isScrollEnabled = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                    self.licitatieResults = licitatieResults
                    self.isSearchingLicitatii = false
                    
                    DispatchQueue.main.async{
                        NSLog("DONE Fetching Licitatii")
                        self.tableView.allowsSelection = true
                        self.tableView.isScrollEnabled = true
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                if isSearchingInstitutions || isSearchingCompanies || isSearchingContracts {
                    self.tableView.allowsSelection = true
                    self.tableView.isScrollEnabled = true
                    self.tableView.reloadData()
                }
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchController.searchBar.selectedScopeButtonIndex {
        case 0:
            if institutionResults.count == 0 && isSearchingInstitutions { return 15 }
            return institutionResults.count
        case 1:
            if companieResults.count == 0 && isSearchingCompanies { return 15 }
            return companieResults.count
        case 2:
            if contractResults.count == 0 && isSearchingContracts { return 15 }
            return contractResults.count
        case 3:
            if licitatieResults.count == 0 && isSearchingLicitatii { return 15 }
            return licitatieResults.count
        default:
            break;
        }
        return institutionResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TableCell
        switch searchController.searchBar.selectedScopeButtonIndex {
        case 0:
            if institutionResults.count == 0 {
                if isSearchingInstitutions {
                    cell.button.isHidden = false
                    cell.startShimmer()
                }
                else {
                    cell.button.isHidden = true
                    cell.stopShimmer()
                }
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                return cell
            }
            cell.button.isHidden = false
            cell.stopShimmer()
            cell.titleLabel.text = institutionResults[indexPath.row].nume
            cell.titleLabel.adjustsFontSizeToFitWidth = true
            cell.titleLabel.minimumScaleFactor = 0.2
            cell.button.text = ">"
        case 1:
            if companieResults.count == 0 {
                if isSearchingCompanies {
                    cell.button.isHidden = false
                    cell.startShimmer()
                }
                else {
                    cell.button.isHidden = true
                    cell.stopShimmer()
                }
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                return cell
            }
            cell.button.isHidden = false
            cell.stopShimmer()
            cell.titleLabel.text = companieResults[indexPath.row].nume
            cell.titleLabel.adjustsFontSizeToFitWidth = true
            cell.titleLabel.minimumScaleFactor = 0.2
            cell.button.text = ">"
        case 2:
            if contractResults.count == 0 {
                if isSearchingContracts {
                    cell.button.isHidden = false
                    cell.startShimmer()
                }
                else {
                    cell.button.isHidden = true
                    cell.stopShimmer()
                }
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                return cell
            }
            cell.button.isHidden = false
            cell.stopShimmer()
            cell.titleLabel.text = contractResults[indexPath.row].titluContract
            cell.titleLabel.adjustsFontSizeToFitWidth = true
            cell.titleLabel.minimumScaleFactor = 0.2
            cell.button.text = ">"
        case 3:
            if licitatieResults.count == 0 {
                if isSearchingLicitatii {
                    cell.button.isHidden = false
                    cell.startShimmer()
                }
                else {
                    cell.button.isHidden = true
                    cell.stopShimmer()
                }
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                return cell
            }
            cell.button.isHidden = false
            cell.stopShimmer()
            cell.titleLabel.text = licitatieResults[indexPath.row].titluContract
            cell.titleLabel.adjustsFontSizeToFitWidth = true
            cell.titleLabel.minimumScaleFactor = 0.2
            cell.button.text = ">"
        default:
            break;
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchController.searchBar.selectedScopeButtonIndex {
        case 0:
            let controller = storyboard?.instantiateViewController(withIdentifier: "InstitutionViewController") as! InstitutionViewController
            controller.id = String(institutionResults[indexPath.row].id)
            controller.institutionName = institutionResults[indexPath.row].nume
            show(controller, sender: self)
        case 1:
            let controller = storyboard?.instantiateViewController(withIdentifier: "CompanieViewController") as! CompanieViewController
            controller.companieSummary = self.companieResults[indexPath.row]
            show(controller, sender: self)
        case 2:
            let controller = storyboard?.instantiateViewController(withIdentifier: "ContractViewController") as! ContractViewController
            controller.id = self.contractResults[indexPath.row].id
            show(controller, sender: self)
        case 3:
            let controller = storyboard?.instantiateViewController(withIdentifier: "LicitatieViewController") as! LicitatieViewController
            controller.licitatieSummary = self.licitatieResults[indexPath.row]
            show(controller, sender: self)
        default:
            break;
        }
    }
}
