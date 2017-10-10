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
}
