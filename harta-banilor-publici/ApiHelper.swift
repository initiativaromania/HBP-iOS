import Foundation

struct Institution: Codable {
    let id: Int
    let cui, nume, adresa, judet, uat: String
    let longitude, latitude: Double
    
    private enum CodingKeys : String, CodingKey {
        case id = "InstitutiePublicaId", cui = "CUI", nume = "Nume"
        case adresa = "Adresa", judet = "Judet", uat = "UAT"
        case longitude = "long", latitude = "lat"
    }
}

struct InstitutionSummary: Codable {
    let nume: String
    let nr_achizitii, nr_licitatii: Int
    
    private enum CodingKeys : String, CodingKey {
        case nume = "nume_institutie", nr_achizitii, nr_licitatii
    }
}

struct InstitutionContract: Codable {
    let id: Int
    let titluContract, numarContract: String
    let valoareRON: Double
    
    private enum CodingKeys : String, CodingKey {
        case id = "ContracteId", numarContract = "NumarContract"
        case titluContract = "TitluContract", valoareRON = "ValoareRON"
    }
}

struct InstitutionLicitatie: Codable {
    let id: Int
    let titluContract, numarContract: String
    let valoareRON: Double
    
    private enum CodingKeys : String, CodingKey {
        case id = "LicitatieID", numarContract = "NumarContract"
        case titluContract = "TitluContract", valoareRON = "ValoareRON"
    }
}

struct CompanyByInstitution: Codable {
    let id: Int
    let nume, cui, tara, localitate, adresa: String
    
    private enum CodingKeys : String, CodingKey {
        case id = "CompanieId", nume = "Nume", cui = "CUI"
        case tara = "Tara", localitate = "Localitate", adresa = "Adresa"
    }
}
struct InstitutionByCompany: Codable {
    let cui, nume: String
    
    private enum CodingKeys : String, CodingKey {
        case cui = "CUI", nume = "Nume"
    }
}

struct CompanyContract: Codable {
    let id: Int
    let titluContract, numarContract: String
    let valoareRON: Double
    
    private enum CodingKeys : String, CodingKey {
        case id = "ContractID", numarContract = "NumarContract"
        case titluContract = "TitluContract", valoareRON = "ValoareRON"
    }
}

struct CompanyLicitatie: Codable {
    let id: Int
    let titluContract, numarContract: String
    let valoareRON: Double
    
    private enum CodingKeys : String, CodingKey {
        case id = "TenderId", numarContract = "NumarContract"
        case titluContract = "TitluContract", valoareRON = "ValoareRON"
    }
}

class ApiHelper {
    let api_url = "https://hbp-api.azurewebsites.net/api/"
    
    func getInstitutionByID(id: String, handler: @escaping (Institution) -> ()) {
        let url_str = self.api_url + "InstitutionByID/" + id
        NSLog("Fetching Institution: " + url_str)
        let url = URL(string: url_str)
        var institution: Institution!
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            institution = try! JSONDecoder().decode([Institution].self, from: data)[0]
            handler(institution)
        }
        task.resume()
    }
    
    func getInstitutionContracts(id: String, handler: @escaping ([InstitutionContract]) -> ()) {
        NSLog("Fetching Contracts")
        let url_str = self.api_url + "InstitutionContracts/" + id
        let url = URL(string: url_str)
        var contracte:[InstitutionContract] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            contracte = try! JSONDecoder().decode([InstitutionContract].self, from: data)
            
            contracte.sort(by: { $0.valoareRON > $1.valoareRON})
            handler(contracte)
        }
        task.resume()
    }
    
    func getInstitutionTenders(id: String, handler: @escaping ([InstitutionLicitatie]) -> ()) {
        NSLog("Fetching Licitatii")
        
        let url_str = self.api_url + "InstitutionTenders/" + id
        let url = URL(string: url_str)
        var licitatii:[InstitutionLicitatie] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            licitatii = try! JSONDecoder().decode([InstitutionLicitatie].self, from: data)
            licitatii.sort(by: { $0.valoareRON > $1.valoareRON})
            handler(licitatii)
        }
        task.resume()
    }
    
    func getCompaniesByInstitution(id: String, handler: @escaping ([CompanyByInstitution]) -> ()) {
        NSLog("Fetching Companii")
        let url_str = self.api_url + "CompaniesByInstitution/" + id
        let url = URL(string: url_str)
        var companii:[CompanyByInstitution] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            companii = try! JSONDecoder().decode([CompanyByInstitution].self, from: data)
            handler(companii)
        }
        task.resume()
    }

    // Company API calls

    func getCompanyContracts(cui: String, handler: @escaping ([CompanyContract]) -> ()) {
        NSLog("Fetching Company Contracts")
        let url_str = self.api_url + "CompanyContracts/" + cui
        let url = URL(string: url_str)
        var contracte:[CompanyContract] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            contracte = try! JSONDecoder().decode([CompanyContract].self, from: data)
            contracte.sort(by: { $0.valoareRON > $1.valoareRON})
            handler(contracte)
        }
        task.resume()
    }
    
    func getInstitutionsByCompany(cui: String, handler: @escaping ([InstitutionByCompany]) -> ()) {
        let url_str = self.api_url + "InstitutionsByCompany/" + cui
        NSLog("Fetching Institutions: " + url_str)
        let url = URL(string: url_str)
        var institutii: [InstitutionByCompany] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            institutii = try! JSONDecoder().decode([InstitutionByCompany].self, from: data)
            handler(institutii)
        }
        task.resume()
    }
    
    func getCompanyTenders(cui: String, handler: @escaping ([CompanyLicitatie]) -> ()) {
        NSLog("Fetching Licitatii")
        
        let url_str = self.api_url + "CompanyTenders/" + cui
        let url = URL(string: url_str)
        var licitatii:[CompanyLicitatie] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            licitatii = try! JSONDecoder().decode([CompanyLicitatie].self, from: data)
            licitatii.sort(by: { $0.valoareRON > $1.valoareRON})
            handler(licitatii)            
        }
        task.resume()
    }

// Search API calls

    func searchInstitution(pattern: String, handler: @escaping ([Institution]) -> ()) {
        if pattern.isEmpty {
            return
        }
        NSLog("Searching Institutions for " + pattern)
        
        var institutionResults:[Institution] = []
        let pattern_escaped = pattern.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        NSLog(pattern_escaped!)
        
        
        let url_str = self.api_url + "SearchInstitution/" + pattern_escaped!
        NSLog(url_str)
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                /*DispatchQueue.main.async {
                    self.tableView.allowsSelection = false
                    self.tableView.isScrollEnabled = false
                    self.isSearching = false
                    self.institutionResults = []
                    self.tableView.reloadData()
                }*/
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            institutionResults = try! JSONDecoder().decode([Institution].self, from: data)
            handler(institutionResults)
        }
        task.resume()
    }
    
    func searchCompanies(pattern: String, handler: @escaping ([CompanyByInstitution]) -> ()) {
        if pattern.isEmpty {
            return
        }
        NSLog("Fetching Companies for " + pattern)
        var companieResults:[CompanyByInstitution] = []
        
        let pattern_escaped = pattern.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        NSLog(pattern_escaped!)
        
        let url_str = "https://hbp-api.azurewebsites.net/api/SearchCompany/" + pattern_escaped!
        NSLog(url_str)
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                /*DispatchQueue.main.async {
                    self.tableView.allowsSelection = false
                    self.tableView.isScrollEnabled = false
                    self.isSearching = false
                    self.companieResults = []
                    self.tableView.reloadData()
                }*/
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            companieResults = try! JSONDecoder().decode([CompanyByInstitution].self, from: data)
            handler(companieResults)
        }
        task.resume()
    }
    
    func searchContracts(pattern: String, handler: @escaping ([InstitutionContract]) -> ()) {
        if pattern.isEmpty {
            return
        }
        NSLog("Fetching Contracts for " + pattern)
        var contractResults:[InstitutionContract] = []

        let pattern_escaped = pattern.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        NSLog(pattern_escaped!)
        
        let url_str = "https://hbp-api.azurewebsites.net/api/SearchContract/" + pattern_escaped!
        NSLog(url_str)
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                /*DispatchQueue.main.async {
                    self.tableView.allowsSelection = false
                    self.tableView.isScrollEnabled = false
                    self.isSearching = false
                    self.contractResults = []
                    self.tableView.reloadData()
                    
                }*/
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            contractResults = try! JSONDecoder().decode([InstitutionContract].self, from: data)
            handler(contractResults)
        }
        task.resume()
    }
    
    func searchLicitatii(pattern: String, handler: @escaping ([InstitutionLicitatie]) -> ()) {
        if pattern.isEmpty {
            return
        }
        NSLog("Fetching Licitatii for " + pattern)
        var licitatieResults:[InstitutionLicitatie] = []

        let pattern_escaped = pattern.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        NSLog(pattern_escaped!)
        
        let url_str = "https://hbp-api.azurewebsites.net/api/SearchTenters/" + pattern_escaped!
        NSLog(url_str)
        let url = URL(string: url_str)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                /*DispatchQueue.main.async {
                    self.tableView.allowsSelection = false
                    self.tableView.isScrollEnabled = false
                    self.isSearching = false
                    self.licitatieResults = []
                    self.tableView.reloadData()
                }*/
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            licitatieResults = try! JSONDecoder().decode([InstitutionLicitatie].self, from: data)
            handler(licitatieResults)
        }
        task.resume()
    }
}
