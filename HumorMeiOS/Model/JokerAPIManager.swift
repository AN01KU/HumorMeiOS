//
//  JokerAPIManager.swift
//  HumorMeApp
//
//  Created by Ankush Ganesh on 24/01/23.
//

import Foundation

protocol JokerAPIManagerDelegate: NSObject {
    func postJokes(jokes: [Jokes])
}

struct JokerAPIManager {
    
    weak var delegate: JokerAPIManagerDelegate?
    
    var baseURL = "https://sv443.net/jokeapi/v2/joke"
    
    func getJokes(){
        let urlString = "\(baseURL)/Any?type=single&amount=10"
        performRequest(with: urlString)
    }
    
    func getJokeWithCategory(amount: Int,categories: [String]){
        let urlString = "\(baseURL)/\(categories)?type=single&amount=\(amount)"
        performRequest(with: urlString)
    }
    
    
    
    func performRequest(with urlString: String ) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if (error != nil) != false {
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
            return nil
        }
    }
}
