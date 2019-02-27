import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    //try services.register(FluentMySQLProvider())
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    /* Configure a MySQL database
    let mySQLDatabaseConfig = MySQLDatabaseConfig(hostname: "localhost", username: "vapor", password: "password", database: "vapor")
    let mySQLDatabase = MySQLDatabase(config: mySQLDatabaseConfig)
    */
    
    // Configure a PostgreSQL database
    struct DatabaseEnviromentKeys {
        static let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
        static let username = Environment.get("DATABASE_USER") ?? "vapor"
        static let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
        static let password = Environment.get("DATABASE_PASSWORD") ?? "password"
    }
    
    
     let postgreSQLDatabaseConfig = PostgreSQLDatabaseConfig(
        hostname: DatabaseEnviromentKeys.hostname,
        username: DatabaseEnviromentKeys.username,
        database: DatabaseEnviromentKeys.databaseName,
        password: DatabaseEnviromentKeys.password
    )
     let postgresDatabase = PostgreSQLDatabase(config: postgreSQLDatabaseConfig)
    
 
    // Register the configured database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgresDatabase, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    //Order is important!
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Acronym.self, database: .psql)

    services.register(migrations)
    
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
}
