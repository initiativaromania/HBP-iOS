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
    var isSearching: Bool = false

    //@IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
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
            searchInstitustion(pattern: searchBar.text!)
        case 1:
            searchCompanies(pattern: searchBar.text!)
        case 2:
            searchContracts(pattern: searchBar.text!)
        case 3:
            searchLicitatii(pattern: searchBar.text!)
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
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                searchInstitustion(pattern: searchBar.text!)
            }
            else {
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                tableView.reloadData()
            }
        case 1:
            if companieResults.count == 0 {
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                searchCompanies(pattern: searchBar.text!)
            }
            else {
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                tableView.reloadData()
            }
        case 2:
            if contractResults.count == 0 {
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                searchContracts(pattern: searchBar.text!)
            }
            else {
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                tableView.reloadData()
            }
        case 3:
            if licitatieResults.count == 0 {
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                searchLicitatii(pattern: searchBar.text!)
            }
            else {
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                tableView.reloadData()
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchController.searchBar.selectedScopeButtonIndex {
        case 0:
            if institutionResults.count == 0 && isSearching { return 15 }
            return institutionResults.count
        case 1:
            if companieResults.count == 0 && isSearching { return 15 }
            return companieResults.count
        case 2:
            if contractResults.count == 0 && isSearching { return 15 }
            return contractResults.count
        case 3:
            if licitatieResults.count == 0 && isSearching { return 15 }
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
                if isSearching {
                    cell.button.isHidden = false
                    cell.startShimmer()
                }
                else {
                    cell.button.isHidden = true
                    cell.stopShimmer()
                }
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
                if isSearching {
                    cell.button.isHidden = false
                    cell.startShimmer()
                }
                else {
                    cell.button.isHidden = true
                    cell.stopShimmer()
                }
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
                if isSearching {
                    cell.button.isHidden = false
                    cell.startShimmer()
                }
                else {
                    cell.button.isHidden = true
                    cell.stopShimmer()
                }
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
                if isSearching {
                    cell.button.isHidden = false
                    cell.startShimmer()
                }
                else {
                    cell.button.isHidden = true
                    cell.stopShimmer()
                }
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
            controller.contractSummary = self.contractResults[indexPath.row]
            show(controller, sender: self)
        case 3:
            let controller = storyboard?.instantiateViewController(withIdentifier: "LicitatieViewController") as! LicitatieViewController
            controller.licitatieSummary = self.licitatieResults[indexPath.row]
            show(controller, sender: self)
        default:
            break;
        }
    }
    
    func searchInstitustion(pattern: String) {
        if pattern.isEmpty {
            return
        }
        NSLog("Fetching Institutions for " + pattern)
        self.institutionResults = []
        isSearching = true
        self.tableView.reloadData()
        let pattern_escaped = pattern.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        NSLog(pattern_escaped!)
        let url_str = "https://hbp-api.azurewebsites.net/api/SearchInstitution/" + pattern_escaped!
        NSLog(url_str)
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    self.tableView.allowsSelection = false
                    self.tableView.isScrollEnabled = false
                    self.isSearching = false
                    self.institutionResults = []
                    self.tableView.reloadData()
                }
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            self.institutionResults = try! JSONDecoder().decode([Institution].self, from: data)

            DispatchQueue.main.async{
                NSLog("DONE Fetching Institutions")
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.isSearching = false
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func searchCompanies(pattern: String) {
        guard !pattern.isEmpty else {
            return
        }
        NSLog("Fetching Companies for " + pattern)
        self.companieResults = []
        isSearching = true
        self.tableView.reloadData()
        let pattern_escaped = pattern.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        NSLog(pattern_escaped!)
        let url_str = "https://hbp-api.azurewebsites.net/api/SearchCompany/" + pattern_escaped!
        NSLog(url_str)
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    self.tableView.allowsSelection = false
                    self.tableView.isScrollEnabled = false
                    self.isSearching = false
                    self.companieResults = []
                    self.tableView.reloadData()
                }
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            self.companieResults = try! JSONDecoder().decode([CompanyByInstitution].self, from: data)

            DispatchQueue.main.async{
                NSLog("DONE Fetching Companies")
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.isSearching = false
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func searchContracts(pattern: String) {
        if pattern.isEmpty {
            return
        }
        NSLog("Fetching Contracts for " + pattern)
        self.contractResults = []
        isSearching = true
        self.tableView.reloadData()
        let pattern_escaped = pattern.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        NSLog(pattern_escaped!)
        let url_str = "https://hbp-api.azurewebsites.net/api/SearchContract/" + pattern_escaped!
        NSLog(url_str)
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    self.tableView.allowsSelection = false
                    self.tableView.isScrollEnabled = false
                    self.isSearching = false
                    self.contractResults = []
                    self.tableView.reloadData()
                    
                }
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }

            self.contractResults = try! JSONDecoder().decode([InstitutionContract].self, from: data)

            DispatchQueue.main.async{
                NSLog("DONE Fetching Contracts")
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.isSearching = false
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func searchLicitatii(pattern: String) {
        if pattern.isEmpty {
            return
        }
        NSLog("Fetching Licitatii for " + pattern)
        self.licitatieResults = []
        isSearching = true
        self.tableView.reloadData()
        let pattern_escaped = pattern.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        NSLog(pattern_escaped!)
        let url_str = "https://hbp-api.azurewebsites.net/api/SearchTenters/" + pattern_escaped!
        NSLog(url_str)
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    self.tableView.allowsSelection = false
                    self.tableView.isScrollEnabled = false
                    self.isSearching = false
                    self.licitatieResults = []
                    self.tableView.reloadData()
                }
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            self.licitatieResults = try! JSONDecoder().decode([InstitutionLicitatie].self, from: data)
            
            DispatchQueue.main.async{
                NSLog("DONE Fetching Licitatii")
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.isSearching = false
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
}
