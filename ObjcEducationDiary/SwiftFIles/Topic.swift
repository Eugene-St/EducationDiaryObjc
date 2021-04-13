//
//  Topic.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

@objc class Topic: NSObject, Model {
    
    public var sid: String? = String(Date.timeIntervalSinceReferenceDate)
    @objc let title: String?
    let notes: String?
    let status: String?
    let dueDate: Int32?
    let createdOn: Int32?
    
    private enum CodingKeys : String, CodingKey {
        case dueDate = "due_date"
        case createdOn = "created_on"
        case id
        case title
        case notes
        case status
    }
    
    required init!(dictionary jsonObject: [AnyHashable : Any]) {
        self.sid = jsonObject["id"] as? String
        self.title = jsonObject["title"] as? String
        self.notes = jsonObject["notes"] as? String
        self.status = jsonObject["status"] as? String
        self.dueDate = jsonObject["due_date"] as? Int32
        self.createdOn = jsonObject["created_on"] as? Int32
    }
    
    @objc func mapJSONToData() throws -> Data {
        var topic: [String: Any] = [:]
        
        topic["id"] = self.sid
        topic["title"] = self.title
        topic["notes"] = self.notes
        topic["status"] = self.status
        topic["due_date"] = self.dueDate
        topic["created_on"] = self.createdOn
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: topic, options: JSONSerialization.WritingOptions(rawValue: 0))
            return jsonData
        }
        catch {
            return Data.init() // todo - update
        }
    }
    
    init(sid: String?, title: String?,
         notes: String?, status: String?, dueDate: Int32?,
         createdOn: Int32?) {
        self.sid = sid
        self.title = title
        self.notes = notes
        self.status = status
        self.dueDate = dueDate
        self.createdOn = createdOn
    }
    
    init(topicCD: TopicCoreData) {
        self.sid = topicCD.sid
        self.title = topicCD.title
        self.notes = topicCD.notes
        self.status = topicCD.status
        self.dueDate = topicCD.dueDate
        self.createdOn = topicCD.createdOn
    }
    
    func mapToCoreData(topicCD: TopicCoreData) {
        topicCD.sid = self.sid
        topicCD.title = self.title
        topicCD.notes = self.notes
        topicCD.status = self.status
        topicCD.dueDate = self.dueDate ?? 0
        topicCD.createdOn = self.createdOn ?? 0
    }
}
