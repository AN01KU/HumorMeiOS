//
//  JokerAPIManager.swift
//  HumorMeApp
//
//  Created by Ankush Ganesh on 24/01/23.
//

import Foundation

protocol JokerAPIManagerDelegate: NSObject {
    func postJokes(jokes: [Jokes])
    
    func postError(error: String)
}

struct JokerAPIManager {
    
    weak var delegate: JokerAPIManagerDelegate?
    
    var baseURL = "https://sv443.net/jokeapi/v2/joke/"
    
    func getJokes(){
        let urlString = "\(baseURL)/Any?type=single&amount=20&backlistFlags=nsfw,sexist"
        performRequest(with: urlString)
    }

    
    
    func getJokeWithFilter(categories: [String], searchQuery: String) {
        var someString = baseURL
        
        for eachCategory in categories {
            someString += "\(eachCategory),"
        }
        someString.removeLast()
        let urlString = "\(someString)?type=single&contains=\(searchQuery)&amount=20&backlistFlags=nsfw,sexist"
        
        performRequest(with: urlString)
        
        
    }
    
    
    
    func performRequest(with urlString: String ) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if (error != nil) == true {
//                    delegate?.postError(error: "Could not find any jokes :(")
                    return
                }
                if let safeData = data {
                    if let jokes = self.parseJSON(safeData){
                        delegate?.postJokes(jokes: jokes)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> [Jokes]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(JokerData.self, from: data)
            let jokes = decodedData.jokes
            return jokes
        } catch {
            delegate?.postError(error: "Could not find any jokes :(")
            return nil
        }
    }
}
