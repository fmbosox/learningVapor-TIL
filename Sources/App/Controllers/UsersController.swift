import Vapor


struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api","users")
        usersRoute.post(User.self, use: createUser)
        usersRoute.get(use: getAllUsers)
        usersRoute.get(User.parameter, use: getUser)
        usersRoute.get(User.parameter,"acronyms", use: getUsersAcronyms)
    }
    
    
    private func createUser(request: Request, user: User)throws -> Future<User> {
        return user.save(on: request)
    }
    
    
    private func getAllUsers(request: Request)throws -> Future<Array<User>> {
        return User.query(on: request).all()
    }
    
    private func getUser(request: Request)throws -> Future<User> {
        return try request.parameters.next(User.self)
    }
    
    
    private func getUsersAcronyms(request: Request)throws -> Future<[Acronym]> {
        return try request.parameters.next(User.self).flatMap(to: Array<Acronym>.self) {
            return  try $0.acronyms.query(on: request).all()
        }
        
    }
    
}
