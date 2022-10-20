//
//  CoreDataService.swift
//  WeatherApp
//
//  Created by p h on 02.09.2022.
//

import UIKit
import CoreData

class CoreDataService {
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func setData(key: String, value: Data?) {
        defaults.set(value, forKey: key)
    }
    
    func getData(key: String) -> Data {
        defaults.data(forKey: key) ?? Data()
    }
    
    func saveWeatherModel(model: GeoModel) {
        clearCoreDataValues()
        let newModel = GeoModelEntity(context: context)
        newModel.city = model.city
        newModel.lat = model.lat
        newModel.lon = model.lon
        context.perform {
            try? self.context.save()
        }
    }

    func getWeatherModel() -> GeoModelEntity? {
        guard let model = try? context.fetch(GeoModelEntity.fetchRequest()) else { return nil }
        return model.last
    }
    
    // MARK: - Private funcs
    private func clearCoreDataValues() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GeoModelEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}
