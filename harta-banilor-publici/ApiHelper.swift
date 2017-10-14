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

extension String {
    func trailingTrim(_ characterSet : CharacterSet) -> String {
        if let range = rangeOfCharacter(from: characterSet, options: [.anchored, .backwards]) {
            return self.substring(to: range.lowerBound).trailingTrim(characterSet)
        }
        return self
    }
}

class ApiHelper {
    private let apiURL = "https://hbp-api.azurewebsites.net/api/"
    
    func getInstitutionByID(id: Int, handler: @escaping (Institution, URLResponse?, Error?) -> ()) {
        var institution: Institution!

        let url = self.apiURL + "InstitutionByID/" + String(id)
        print("Fetching Institution: " + url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(institution, response, error!)
                return
            }
            guard let data = data else {
                handler(institution, response, error)
                return
            }
            do {
                institution = try JSONDecoder().decode([Institution].self, from: data)[0]
                handler(institution, response, error)
            }
            catch let error {
                print("json error \(error)")
                handler(institution, response, error)
            }
        }
        task.resume()
    }
    
    func getInstitutionSummary(id: Int, handler: @escaping (InstitutionSummary, URLResponse?, Error?) -> ()) {
        var institutionSummary: InstitutionSummary!

        let url = self.apiURL + "PublicInstitutionSummary/" + String(id)
        print("Fetching InstitutionSummary: " + url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(institutionSummary, response, error)
                return
            }
            guard let data = data else {
                handler(institutionSummary, response, error)
                return
            }
            do {
                institutionSummary = try JSONDecoder().decode([InstitutionSummary].self, from: data)[0]
                handler(institutionSummary, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(institutionSummary, response, error)
            }
        }
        task.resume()
    }

    func getContractByID(id: Int, handler: @escaping (Contract, URLResponse?, Error?) -> ()) {
        var contract: Contract!

        let url = self.apiURL + "Contract/" + String(id)
        print("Fetching Contract: " + url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(contract, response, error!)
                return
            }
            guard let data = data else {
                handler(contract, response, error)
                return
            }
            do {
                contract = try JSONDecoder().decode([Contract].self, from: data)[0]
                handler(contract, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(contract, response, error)
            }
        }
        task.resume()
    }
    
    func getLicitatieByID(id: Int, handler: @escaping (Licitatie, URLResponse?, Error?) -> ()) {
        var licitatie: Licitatie!

        let url = self.apiURL + "Tender/" + String(id)
        print("Fetching Licitatie: " + url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(licitatie, response, error!)
                return
            }
            guard let data = data else {
                handler(licitatie, response, error)
                return
            }
            do {
                licitatie = try JSONDecoder().decode([Licitatie].self, from: data)[0]
                handler(licitatie, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(licitatie, response, error)
            }
        }
        task.resume()
    }
    
    func getInstitutionContracts(id: Int, handler: @escaping ([InstitutionContract], URLResponse?, Error?) -> ()) {
        var contracte:[InstitutionContract] = []

        let url = self.apiURL + "InstitutionContracts/" + String(id)
        print("Fetching Contracts: " + url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(contracte, response, error)
                return
            }
            guard let data = data else {
                handler(contracte, response, error)
                return
            }
            do {
                contracte = try JSONDecoder().decode([InstitutionContract].self, from: data)
                contracte.sort(by: { $0.valoareRON > $1.valoareRON})
                handler(contracte, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(contracte, response, error)
            }
        }
        task.resume()
    }
    
    func getInstitutionTenders(id: Int, handler: @escaping ([InstitutionLicitatie], URLResponse?, Error?) -> ()) {
        var licitatii:[InstitutionLicitatie] = []

        let url = self.apiURL + "InstitutionTenders/" + String(id)
        print("Fetching Licitatii: " + url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(licitatii, response, error)
                return
            }
            guard let data = data else {
                handler(licitatii, response, error)
                return
            }
            do {
                licitatii = try JSONDecoder().decode([InstitutionLicitatie].self, from: data)
                licitatii.sort(by: { $0.valoareRON > $1.valoareRON})
                handler(licitatii, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(licitatii, response, error)
            }
        }
        task.resume()
    }
    
    func getCompaniesByInstitution(id: Int, handler: @escaping ([CompanyByInstitution], URLResponse?, Error?) -> ()) {
        var companii:[CompanyByInstitution] = []

        let url = self.apiURL + "CompaniesByInstitution/" + String(id)
        print("Fetching Companii: " + url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(companii, response, error)
                return
            }
            guard let data = data else {
                handler(companii, response, error)
                return
            }
            do {
                companii = try JSONDecoder().decode([CompanyByInstitution].self, from: data)
                handler(companii, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(companii, response, error)
            }
        }
        task.resume()
    }

    // Company API calls
    
    func getCompanyByCUI(cui: String, handler: @escaping (Companie, URLResponse?, Error?) -> ()) {
        var companie: Companie!

        let url = self.apiURL + "Company/" + cui
        print("Fetching Companie: " + url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(companie, response, error!)
                return
            }
            guard let data = data else {
                handler(companie, response, error)
                return
            }
            do {
                companie = try JSONDecoder().decode([Companie].self, from: data)[0]
                handler(companie, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(companie, response, error)
            }
        }
        task.resume()
    }

    func getCompanyContracts(cui: String, handler: @escaping ([CompanyContract], URLResponse?, Error?) -> ()) {
        var contracte:[CompanyContract] = []

        let url = self.apiURL + "CompanyContracts/" + cui
        print("Fetching Company Contracts: " + url)

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(contracte, response, error)
                return
            }
            guard let data = data else {
                handler(contracte, response, error)
                return
            }
            do {
                contracte = try JSONDecoder().decode([CompanyContract].self, from: data)
                contracte.sort(by: { $0.valoareRON > $1.valoareRON})
                handler(contracte, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(contracte, response, error)
            }
        }
        task.resume()
    }
    
    func getInstitutionsByCompany(cui: String, handler: @escaping ([InstitutionByCompany], URLResponse?, Error?) -> ()) {
        var institutii: [InstitutionByCompany] = []

        let url = self.apiURL + "InstitutionsByCompany/" + cui
        print("Fetching Institutions: " + url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(institutii, response, error)
                return
            }
            guard let data = data else {
                handler(institutii, response, error)
                return
            }
            do {
                institutii = try JSONDecoder().decode([InstitutionByCompany].self, from: data)
                handler(institutii, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(institutii, response, error)
            }
        }
        task.resume()
    }
    
    func getCompanyTenders(cui: String, handler: @escaping ([CompanyLicitatie], URLResponse?, Error?) -> ()) {
        var licitatii:[CompanyLicitatie] = []

        let url = self.apiURL + "CompanyTenders/" + cui
        print("Fetching Company Licitatii: " + url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(licitatii, response, error)
                return
            }
            guard let data = data else {
                handler(licitatii, response, error)
                return
            }
            do {
                licitatii = try JSONDecoder().decode([CompanyLicitatie].self, from: data)
                licitatii.sort(by: { $0.valoareRON > $1.valoareRON})
                handler(licitatii, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(licitatii, response, error)
            }
        }
        task.resume()
    }

// Search API calls

    func searchInstitution(pattern: String, handler: @escaping ([Institution], URLResponse?, Error?) -> ()) {
        var institutionResults:[Institution] = []
        
        let url = self.apiURL + "SearchInstitution/" + pattern.folding(options: .diacriticInsensitive, locale: .current).trailingTrim(.whitespaces).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print("Searching Institutions: " + url)

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(institutionResults, response, error)
                return
            }
            guard let data = data else {
                handler(institutionResults, response, error)
                return
            }
            do {
                institutionResults = try JSONDecoder().decode([Institution].self, from: data)
                handler(institutionResults, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(institutionResults, response, error)
            }
        }
        task.resume()
    }
    
    func searchCompanies(pattern: String, handler: @escaping ([CompanyByInstitution], URLResponse?, Error?) -> ()) {
        var companieResults:[CompanyByInstitution] = []
        
        let url = self.apiURL + "/SearchCompany/" + pattern.folding(options: .diacriticInsensitive, locale: .current).trailingTrim(.whitespaces).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print("Searching Companies: " + url)

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(companieResults, response, error)
                return
            }
            guard let data = data else {
                handler(companieResults, response, error)
                return
            }
            do {
                companieResults = try JSONDecoder().decode([CompanyByInstitution].self, from: data)
                handler(companieResults, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(companieResults, response, error)
            }
        }
        task.resume()
    }
    
    func searchContracts(pattern: String, handler: @escaping ([InstitutionContract], URLResponse?, Error?) -> ()) {
        var contractResults:[InstitutionContract] = []
        let url = self.apiURL + "SearchContract/" + pattern.folding(options: .diacriticInsensitive, locale: .current).trailingTrim(.whitespaces).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print("Searching Contracts: " + url)

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(contractResults, response, error)
                return
            }
            guard let data = data else {
                handler(contractResults, response, error)
                return
            }
            do {
                contractResults = try JSONDecoder().decode([InstitutionContract].self, from: data)
                handler(contractResults, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(contractResults, response, error)
            }
        }
        task.resume()
    }
    
    func searchLicitatii(pattern: String, handler: @escaping ([InstitutionLicitatie], URLResponse?, Error?) -> ()) {
        var licitatieResults:[InstitutionLicitatie] = []

        let url = self.apiURL + "SearchTenters/" + pattern.folding(options: .diacriticInsensitive, locale: .current).trailingTrim(.whitespaces).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print("Searching Licitatii for " + url)

        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil else {
                handler(licitatieResults, response, error)
                return
            }
            guard let data = data else {
                handler(licitatieResults, response, error)
                return
            }
            do {
                licitatieResults = try JSONDecoder().decode([InstitutionLicitatie].self, from: data)
                handler(licitatieResults, response, error)
            }
            catch let error {
                print("json error: \(error)")
                handler(licitatieResults, response, error)
            }
        }
        task.resume()
    }
}
