//
//  TopicsMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation
import CoreData

@objc class TopicsMediator: Mediator {
    
    override init() {
        super.init(path: "topics", modelCLass: Topic.self)
    }
    
    // save to DB
    override func save(toDB objects: Any, _ completionBlock: @escaping errorCompletionBlock) {
        let topics = objects as! [Topic]
        topics.forEach { (topic) in
            let topicCD = TopicCoreData(context: CoreDataManager.sharedInstance().context)
            topic.mapToCoreData(topicCD: topicCD)
        }
        CoreDataManager.sharedInstance().saveItems { error in
            completionBlock(error)
        }
    }
    
    // fetch from DB
    override func fetch(fromDB completionBlock: @escaping completion) {
        CoreDataManager.sharedInstance().fetch("TopicCoreData") { (objects, error) in
            if error != nil {
                completionBlock(nil, error)
            } else {
                var topics = [Topic]()
                for object in objects as! [TopicCoreData] {
                    topics.append(Topic(topicCD: object))
                }
                DispatchQueue.main.async {
                    completionBlock(topics, nil)
                }
            }
        }
    }
    
    // delete single entity from db
    override func delete(fromDB object: Model, _ completionBlock: @escaping errorCompletionBlock) {
        let request = NSFetchRequest<TopicCoreData>(entityName: "TopicCoreData")
        let topicPredicate = NSPredicate(format: "id == %@", object.sid!)
        request.predicate = topicPredicate
        
        do {
            guard let topicCD = try CoreDataManager.sharedInstance().context.fetch(request).first else { return }
            CoreDataManager.sharedInstance().saveItems { error in
                completionBlock(error)
            }
            CoreDataManager.sharedInstance().deleteItem(topicCD) { error in
                completionBlock(error)
            }
            
        } catch {
            print("Error deleting: \n \(error.localizedDescription)")
            completionBlock(error)
        }
    }
    
    // delete all entitied from DB
    override func deleteEntities(fromDB completionBlock: @escaping errorCompletionBlock) {
        CoreDataManager.sharedInstance().resetAllRecords("TopicCoreData") { error in
            completionBlock(error)
        }
    }
    
    override func update(inDB object: Model, _ completionBlock: @escaping errorCompletionBlock) {
        let request = NSFetchRequest<TopicCoreData>(entityName: "TopicCoreData")
        
        do {
            let topicsCD = try CoreDataManager.sharedInstance().context.fetch(request)
            
            topicsCD.forEach { topicCD in
                let topic = object as! Topic
                if object.sid == topicCD.sid {
                    topicCD.createdOn = topic.createdOn ?? 0
                    topicCD.dueDate = topic.dueDate ?? 0
                    topicCD.sid = topic.sid
                    topicCD.notes = topic.notes
                    topicCD.title = topic.title
                    topicCD.status = topic.status
                    CoreDataManager.sharedInstance().saveItems { error in
                        completionBlock(error)
                    }
                }
            }
            
        } catch {
            print("Error updating: \n \(error.localizedDescription)")
            completionBlock(error)
        }
    }
    
    override func create(inDB object: Model, _ completionBlock: @escaping errorCompletionBlock) {
        let topic = object as! Topic
        let topicCD = TopicCoreData(context: CoreDataManager.sharedInstance().context)
        topic.mapToCoreData(topicCD: topicCD)
        CoreDataManager.sharedInstance().saveItems { error in
            completionBlock(error)
        }
    }
}
