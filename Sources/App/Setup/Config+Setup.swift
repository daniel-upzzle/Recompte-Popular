import FluentProvider
import MySQLProvider
import AuthProvider
import JWTProvider


extension Config {
	
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
		
		setupMiddleware()
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
		try addProvider(MySQLProvider.Provider.self)
		try addProvider(AuthProvider.Provider.self)
		try addProvider(JWTProvider.Provider.self)
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
		preparations.append(ActionModel.self)
		preparations.append(UserModel.self)
		preparations.append(TokenModel.self)
    }
	
	private func setupMiddleware(){
		addConfigurable(middleware: VersionMiddleware(), name: "version")
		addConfigurable(middleware: FlowneyErrorsMiddleware(), name: "flowney-errors")
	}
}
