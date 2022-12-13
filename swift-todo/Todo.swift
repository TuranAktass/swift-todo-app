//
//  Todo.swift
//  swift-todo
//
//  Created by Risetime on 13.12.2022.
//

import Foundation


class TodoModel {
    var id: UUID
    var todo : String
    var isCompleted : Bool
    
    init(id: UUID, todo: String, isCompleted: Bool){
        self.id = id
        self.todo = todo
        self.isCompleted = isCompleted
    }
}
