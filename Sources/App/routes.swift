import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    
    
    let controllers: [RouteCollection] = [AcronymsController(),
                                          UsersController(),CategoriesController ()
                                          ]
    for controller in controllers {
        try router.register(collection: controller)
    }

}
