//
//  JokeExtension.swift
//  HumorMeiOS
//
//  Created by Ankush Ganesh on 24/01/23.
//

import Foundation
import CoreData


extension LikedJoke {
    public class func fetchLikedJokes() -> [LikedJoke] {
        let viewContext = StorageManager.shared.persistentContainer.viewContext
    
        let fetchRequest = NSFetchRequest<LikedJoke>(entityName: "LikedJoke")
        do {
            let jokes = try viewContext.fetch(fetchRequest)
            return jokes
        } catch {
    
        }
        return []
    }
    
    public class func addLikedJoke(joke: String, category: String, id: Int) -> Bool{
        let backgroundContext = StorageManager.shared.persistentContainer.newBackgroundContext()
        do {
    
            let newJoke = LikedJoke(context: backgroundContext)
    
            newJoke.joke = joke
            newJoke.category = category
            newJoke.id = Int64(id)
            try backgroundContext.save()
            return true
        } catch {
    
        }
        return false
    }
    
    public class func deleteLikedJoke(jokeId: Int) -> Bool {
        let backgroundContext = StorageManager.shared.persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = LikedJoke.fetchRequest()
    
        fetchRequest.predicate = NSPredicate(format: "id == %i", jokeId)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
        do {
            try backgroundContext.execute(deleteRequest)
    
            return true
        } catch {
    
        }
        return false
    }

}

