import Foundation
import FluentPostgreSQL


final class AcronymCategoryPivot: PostgreSQLUUIDPivot, ModifiablePivot {
    
    typealias Left = Acronym
    typealias Right = Category
    
    var id: UUID?
    var acronymID: Acronym.ID
    var categoryID: Category.ID
    
    static let leftIDKey: LeftIDKey = \.acronymID
    static let rightIDKey: RightIDKey = \.categoryID
 
    
    init(_ left: AcronymCategoryPivot.Left, _ right: AcronymCategoryPivot.Right) throws {
        self.acronymID = try left.requireID()
        self.categoryID = try right.requireID()
    }
    
}

extension AcronymCategoryPivot: Migration {
    
    static func prepare ( on connection: PostgreSQLConnection) -> Future <Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.acronymID, to: \Acronym.id, onDelete: .cascade)
            builder.reference(from: \.categoryID, to: \Category.id, onDelete: .cascade)
        }
    }
    
    
    
}
