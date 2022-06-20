//
//  CoreData.swift
//  MessApp
//
//  Created by Николай Петров on 17.06.2022.
//

import Foundation
import CoreData
import UIKit

class CoreData  {
    static let shared = CoreData()
    
    private let manageContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    public var favoriteMessage: [Favorites] = []
    
    public func save(_ message: Message){
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Favorites", in: manageContext) else { return }
        let favorites = NSManagedObject(entity: entityDescription, insertInto: manageContext) as! Favorites
        favorites.message = message.message
        favorites.id = message.messageId
        do {
            try manageContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func fetchdData(completion: ([Favorites]) -> ()) {
        let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        do {
            favoriteMessage = try manageContext.fetch(fetchRequest)
            completion(favoriteMessage)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func deleteMessage(_ favoriteMessage: Favorites, completion: (() -> ())? = nil) {
        manageContext.delete(favoriteMessage)
        do {
            try manageContext.save()
            if completion != nil {
                completion!()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
