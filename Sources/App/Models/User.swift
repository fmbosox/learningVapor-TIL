import Foundation
import Vapor
import FluentPostgreSQL


final class User: Codable {
    var id: UUID?
    var name: String
    var userName:String
    
    var acronyms: Children<User,Acronym> {
        return children(\.userID)
    }
    
    
    init(name: String, userName: String) {
        self.name = name
        self.userName = userName
    }
}


extension User: PostgreSQLUUIDModel {}
extension User: Migration {}
extension User: Content {}
extension User: Parameter {}

