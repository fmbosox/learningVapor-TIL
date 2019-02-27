import Vapor


struct CategoriesController: RouteCollection {
    func boot(router: Router) throws {
        let categoriesRoute = router.grouped("api","categories")
        categoriesRoute.post(Category.self,use: createCategory)
        categoriesRoute.get(use: getAllCategoriesFromDB)
        categoriesRoute.get(Category.parameter, use: getCategoryFromDB)
        categoriesRoute.get(Category.parameter,"acronyms",use: getAcronyms)
    }
    
    
    private func createCategory(request: Request,category: Category )throws -> Future<Category> {
        return category.save(on: request)
    }
    
    private func getAllCategoriesFromDB(request: Request )throws -> Future<[Category]> {
        return Category.query(on: request).all()
    }
    
    
    private func getCategoryFromDB(request: Request )throws -> Future<Category> {
        return try request.parameters.next(Category.self)
    }
    
    private func getAcronyms(request: Request)throws -> Future<[Acronym]> {
        return try request.parameters.next(Category.self).flatMap(to: [Acronym].self) {
            category in
            
            try category.acronyms.query(on: request).all()
            
        }
        
    }
    
    
}

