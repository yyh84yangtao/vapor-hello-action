import Vapor

func routes(_ app: Application) throws {
    
    app.get { req in
        return "Date:\t\(Date())\nTimeStamp:\t\(Date().timeIntervalSince1970*1000)"
    }

    app.get("hello") { req -> String in
        let remote = req.remoteAddress?.description ?? "world!"
        return "Hello, \(remote)"
    }
}
