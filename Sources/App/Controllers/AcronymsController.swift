import Vapor
import Fluent

struct AcronymsController: RouteCollection {

    func boot(router: Router) throws {
        let acronymsRoutes = router.grouped("api","acronyms")
        acronymsRoutes.get(use: getAllAcronyms)
        acronymsRoutes.get(Acronym.parameter,use: getAcronym)
        acronymsRoutes.post(Acronym.self, use: createNewAcronym)
        acronymsRoutes.put(Acronym.parameter, use: updateAcronym)
        acronymsRoutes.delete(Acronym.parameter, use: deleteAcronym)
        acronymsRoutes.get("search", use: searchForAcronym)
        acronymsRoutes.get("first", use: getFirstAcronym)
        acronymsRoutes.get("sorted",use:getAllAcronymsSorted)
        acronymsRoutes.get(Acronym.parameter, "user",use: getUserForAcronym)
        
        
    }
    
    private func getAllAcronyms(_ request: Request)throws -> Future<[Acronym]> {
        return Acronym.query(on: request).all()
    }
    
    
    func  getAcronym (request:Request)throws -> Future<Acronym> {
        return try request.parameters.next(Acronym.self)
    }
    
//    func createNewAcronym (request: Request)throws -> Future<Acronym> {
//        return try request.content.decode(Acronym.self).flatMap(to: Acronym.self, { acronym in
//            return acronym.save(on: request)
//        })
//    }
    
    func createNewAcronym(request: Request, acronym: Acronym)throws -> Future<Acronym> {
        return acronym.save(on: request)
    }
    
    func updateAcronym(request: Request)throws -> Future<Acronym> {
        return try flatMap(to:Acronym.self,request.parameters.next(Acronym.self),request.content.decode(Acronym.self)) {
            acronym, updatedAcronym in
            acronym.short = updatedAcronym.short
            acronym.long = updatedAcronym.long
            acronym.userID = updatedAcronym.userID
            return acronym.save(on: request)
        }
        
    }
    
 
    func deleteAcronym(request: Request)throws -> Future<HTTPStatus> {
        
        return try request.parameters.next(Acronym.self).delete(on: request).transform(to: HTTPStatus.noContent)
    
    }
    
    
    func searchForAcronym(request:Request)throws -> Future<[Acronym]> {
        
        guard let searchTerm = request.query[String.self,at:"term"] else { throw Abort(.badRequest) }
        return Acronym.query(on: request).group(.or) { $0.filter(\.short == searchTerm); $0.filter(\.long == searchTerm) }.all()
    }
    
    
  
  
    func getFirstAcronym (request: Request) -> Future<Acronym> {
        
        return Acronym.query(on: request).first().map(to: Acronym.self, { possibleAcronym in
        guard let acronym = possibleAcronym else { throw Abort(.notFound) }
        return acronym
        })
    
    }
   
    func getAllAcronymsSorted(request: Request) -> Future<[Acronym]> {
        return Acronym.query(on: request).sort(\.short, .ascending).all()
    }
    
    
    func getUserForAcronym(request: Request)throws -> Future<User> {
        return try request.parameters.next(Acronym.self).flatMap(to: User.self) { acronym in
            return acronym.user.get(on: request)
        }
    }
    
}
