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
    public func save(_ message: String){
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Favorites", in: manageContext) else { return }
        
        let favorites = NSManagedObject(entity: entityDescription, insertInto: manageContext) as! Favorites
        
        favorites.message = message
        
        do {
            try manageContext.save()
            favoriteMessage.append(favorites)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func fetchdData() {
        let fetchRequest: NSFetchRequest<Favorites > = Favorites.fetchRequest()
        
        do {
            favoriteMessage = try manageContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
