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

struct Contract: Codable {
    let id, institutiePublicaID: Int
    let companieCUI, tipProcedura, institutiePublicaCUI, numarAnuntParticipare: String
    let dataAnuntParticipare, tipIncheiereContract, numarContract, dataContract: String
    let titluContract, cpvCode: String
    let valoareRON, valoareEUR: Double
    
    private enum CodingKeys : String, CodingKey {
        case id = "ContracteId", institutiePublicaID = "InstitutiePublicaID"
        case companieCUI = "CompanieCUI", tipProcedura = "TipProcedura", institutiePublicaCUI = "InstitutiePublicaCUI"
        case numarAnuntParticipare = "NumarAnuntParticipare", dataAnuntParticipare = "DataAnuntParticipare"
        case tipIncheiereContract = "TipIncheiereContract", numarContract = "NumarContract", dataContract = "DataContract"
        case titluContract = "TitluContract", cpvCode = "CPVCode", valoareRON = "ValoareRON", valoareEUR = "ValoareEUR"
    }
}

struct Licitatie: Codable {
    let id, institutiePublicaID: Int
    let companieCUI, tip, tipContract, tipProcedura, institutiePublicaCUI, tipActivitateAC, numarAnuntAtribuire: String
    let dataAnuntAtribuire, tipIncheiereContract, tipCriteriiAtribuire, CUILicitatieElectronica, numarOfertePrimite: String
    let subcontractat, numarContract, dataContract: String
    let titluContract, cpvCodeID, cpvCode, numarAnuntParticipare, dataAnuntParticipare: String
    let valoareEstimataParticipare, monedaValoareEstimataParticipare, depoziteGarantii, modalitatiFinantare: String
    let valoareRON, valoareEUR: Double
    
    private enum CodingKeys : String, CodingKey {
        case id = "LicitatiiId", institutiePublicaID = "InstitutiePublicaID"
        case companieCUI = "CompanieCUI", tip = "Tip", tipContract = "TipContract", tipProcedura = "TipProcedura"
        case institutiePublicaCUI = "InstitutiePublicaCUI", tipActivitateAC = "TipActivitateAC", numarAnuntAtribuire = "NumarAnuntAtribuire"
        case dataAnuntAtribuire = "DataAnuntAtribuire", tipIncheiereContract = "TipIncheiereContract", tipCriteriiAtribuire = "TipCriteriiAtribuire"
        case CUILicitatieElectronica = "CUILicitatieElectronica", numarOfertePrimite = "NumarOfertePrimite", subcontractat = "Subcontractat"
        case numarContract = "NumarContract", dataContract = "DataContract", titluContract = "TitluContract", valoareRON = "ValoareRON"
        case valoareEUR = "ValoareEUR", cpvCodeID = "CPVCodeID", cpvCode = "CPVCode", numarAnuntParticipare = "NumarAnuntParticipare"
        case dataAnuntParticipare = "DataAnuntParticipare", valoareEstimataParticipare = "ValoareEstimataParticipare"
        case monedaValoareEstimataParticipare = "MonedaValoareEstimataParticipare", depoziteGarantii = "DepoziteGarantii", modalitatiFinantare = "ModalitatiFinantare"
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
    
    private enum CodingKeys: String, CodingKey {
        case cui = "CUI", nume = "Nume"
    }
}

struct Companie: Codable {
    let id: Int
    let nume, cui, tara, localitate, adresa: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "CompanieId", nume = "Nume", cui = "CUI"
        case tara = "Tara", localitate = "Localitate", adresa = "Adresa"
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
    
    func getInstitutionByID(id: String, handler: @escaping (Institution, URLResponse?, Error?) -> ()) {
        let url_str = self.api_url + "InstitutionByID/" + id
        NSLog("Fetching Institution: " + url_str)
        let url = URL(string: url_str)
        var institution: Institution!
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                handler(institution, response, error!)
                return
            }
            guard let data = data else {
                handler(institution, response, error)
                return
            }
            
            institution = try! JSONDecoder().decode([Institution].self, from: data)[0]
            handler(institution, response, error)
        }
        task.resume()
    }
    
    func getContractByID(id: String, handler: @escaping (Contract, URLResponse?, Error?) -> ()) {
        let url_str = self.api_url + "Contract/" + id
        print("Fetching Contract: " + url_str)
        let url = URL(string: url_str)
        var contract: Contract!
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                handler(contract, response, error!)
                return
            }
            guard let data = data else {
                handler(contract, response, error)
                return
            }
            
            contract = try! JSONDecoder().decode([Contract].self, from: data)[0]
            handler(contract, response, error)
        }
        task.resume()
    }
    
    func getLicitatieByID(id: String, handler: @escaping (Licitatie, URLResponse?, Error?) -> ()) {
        let url_str = self.api_url + "Tender/" + id
        print("Fetching Licitatie: " + url_str)
        let url = URL(string: url_str)
        var licitatie: Licitatie!
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                handler(licitatie, response, error!)
                return
            }
            guard let data = data else {
                handler(licitatie, response, error)
                return
            }
            
            licitatie = try! JSONDecoder().decode([Licitatie].self, from: data)[0]
            handler(licitatie, response, error)
        }
        task.resume()
    }

    
    func getInstitutionContracts(id: String, handler: @escaping ([InstitutionContract], URLResponse?, Error?) -> ()) {
        NSLog("Fetching Contracts")
        let url_str = self.api_url + "InstitutionContracts/" + id
        let url = URL(string: url_str)
        var contracte:[InstitutionContract] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                handler(contracte, response, error)
                return
            }
            guard let data = data else {
                handler(contracte, response, error)
                return
            }
            
            contracte = try! JSONDecoder().decode([InstitutionContract].self, from: data)
            
            contracte.sort(by: { $0.valoareRON > $1.valoareRON})
            handler(contracte, response, error)
        }
        task.resume()
    }
    
    func getInstitutionTenders(id: String, handler: @escaping ([InstitutionLicitatie], URLResponse?, Error?) -> ()) {
        NSLog("Fetching Licitatii")
        
        let url_str = self.api_url + "InstitutionTenders/" + id
        let url = URL(string: url_str)
        var licitatii:[InstitutionLicitatie] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                handler(licitatii, response, error)
                return
            }
            guard let data = data else {
                handler(licitatii, response, error)
                return
            }
            
            licitatii = try! JSONDecoder().decode([InstitutionLicitatie].self, from: data)
            licitatii.sort(by: { $0.valoareRON > $1.valoareRON})
            handler(licitatii, response, error)
        }
        task.resume()
    }
    
    func getCompaniesByInstitution(id: String, handler: @escaping ([CompanyByInstitution], URLResponse?, Error?) -> ()) {
        NSLog("Fetching Companii")
        let url_str = self.api_url + "CompaniesByInstitution/" + id
        let url = URL(string: url_str)
        var companii:[CompanyByInstitution] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                handler(companii, response, error)
                return
            }
            guard let data = data else {
                handler(companii, response, error)
                return
            }
            
            companii = try! JSONDecoder().decode([CompanyByInstitution].self, from: data)
            handler(companii, response, error)
        }
        task.resume()
    }

    // Company API calls
    
    func getCompanyByCUI(cui: String, handler: @escaping (Companie, URLResponse?, Error?) -> ()) {
        let url_str = self.api_url + "Company/" + cui
        NSLog("Fetching Companie: " + url_str)
        let url = URL(string: url_str)
        var companie: Companie!
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                handler(companie, response, error!)
                return
            }
            guard let data = data else {
                handler(companie, response, error)
                return
            }
            
            companie = try! JSONDecoder().decode([Companie].self, from: data)[0]
            handler(companie, response, error)
        }
        task.resume()
    }

    func getCompanyContracts(cui: String, handler: @escaping ([CompanyContract], URLResponse?, Error?) -> ()) {
        NSLog("Fetching Company Contracts")
        let url_str = self.api_url + "CompanyContracts/" + cui
        let url = URL(string: url_str)
        var contracte:[CompanyContract] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                handler(contracte, response, error)
                return
            }
            guard let data = data else {
                handler(contracte, response, error)
                return
            }
            
            contracte = try! JSONDecoder().decode([CompanyContract].self, from: data)
            contracte.sort(by: { $0.valoareRON > $1.valoareRON})
            handler(contracte, response, error)
        }
        task.resume()
    }
    
    func getInstitutionsByCompany(cui: String, handler: @escaping ([InstitutionByCompany], URLResponse?, Error?) -> ()) {
        let url_str = self.api_url + "InstitutionsByCompany/" + cui
        NSLog("Fetching Institutions: " + url_str)
        let url = URL(string: url_str)
        var institutii: [InstitutionByCompany] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                handler(institutii, response, error)
                return
            }
            guard let data = data else {
                handler(institutii, response, error)
                return
            }
            
            institutii = try! JSONDecoder().decode([InstitutionByCompany].self, from: data)
            handler(institutii, response, error)
        }
        task.resume()
    }
    
    func getCompanyTenders(cui: String, handler: @escaping ([CompanyLicitatie], URLResponse?, Error?) -> ()) {
        NSLog("Fetching Licitatii")
        
        let url_str = self.api_url + "CompanyTenders/" + cui
        let url = URL(string: url_str)
        var licitatii:[CompanyLicitatie] = []
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                handler(licitatii, response, error)
                return
            }
            guard let data = data else {
                handler(licitatii, response, error)
                return
            }
            
            licitatii = try! JSONDecoder().decode([CompanyLicitatie].self, from: data)
            licitatii.sort(by: { $0.valoareRON > $1.valoareRON})
            handler(licitatii, response, error)
        }
        task.resume()
    }

// Search API calls

    func searchInstitution(pattern: String, handler: @escaping ([Institution], URLResponse?, Error?) -> ()) {
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
                handler(institutionResults, response, error)
                return
            }
            guard let data = data else {
                handler(institutionResults, response, error)
                return
            }
            institutionResults = try! JSONDecoder().decode([Institution].self, from: data)
            handler(institutionResults, response, error)
        }
        task.resume()
    }
    
    func searchCompanies(pattern: String, handler: @escaping ([CompanyByInstitution], URLResponse?, Error?) -> ()) {
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
                handler(companieResults, response, error)
                return
            }
            guard let data = data else {
                handler(companieResults, response, error)
                return
            }
            
            companieResults = try! JSONDecoder().decode([CompanyByInstitution].self, from: data)
            handler(companieResults, response, error)
        }
        task.resume()
    }
    
    func searchContracts(pattern: String, handler: @escaping ([InstitutionContract], URLResponse?, Error?) -> ()) {
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
                handler(contractResults, response, error)
                return
            }
            guard let data = data else {
                handler(contractResults, response, error)
                return
            }
            
            contractResults = try! JSONDecoder().decode([InstitutionContract].self, from: data)
            handler(contractResults, response, error)
        }
        task.resume()
    }
    
    func searchLicitatii(pattern: String, handler: @escaping ([InstitutionLicitatie], URLResponse?, Error?) -> ()) {
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
                handler(licitatieResults, response, error)
                return
            }
            guard let data = data else {
                handler(licitatieResults, response, error)
                return
            }
            
            licitatieResults = try! JSONDecoder().decode([InstitutionLicitatie].self, from: data)
            handler(licitatieResults, response, error)
        }
        task.resume()
    }
}
