import Vapor
import FluentPostgreSQL


final class Category: Codable {
    
    var id: Int?
    var name:String
    
    var acronyms: Siblings <Category, Acronym, AcronymCategoryPivot> {
        return siblings()
    }
    
    init(name: String) {
        self.name = name
    }
    
}


extension Category: PostgreSQLModel { }
extension Category: Content { }
extension Category: Migration { }
extension Category: Parameter { }
