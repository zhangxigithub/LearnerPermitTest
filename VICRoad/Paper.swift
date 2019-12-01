//
//  Paper.swift
//  VICRoad
//
//  Created by zhangxi on 2018/6/4.
//  Copyright © 2018 zhangxi. All rights reserved.
//

import Foundation
import SwiftyJSON

class Paper
{
    
    var id : String!
    var date = Date()
    var isSubmit = false
    var questions = [Question]()
    
    var percentage : Float
    {
        var count = 0 as Float
        for q in questions
        {
            if q.myAnswer != nil
            {
                count += 1
            }
        }
        return count/Float(questions.count)
    }
    var score : Int
    {
        var count = 0 as Float
        for q in questions
        {
            if q.myAnswer != nil && q.myAnswer == q.answer
            {
                count += 1
            }
        }
        return Int((count/Float(questions.count)) * 100)
    }
    var answers : [String]
    {
        var result = [String]()
        
        for q in questions
        {
            result.append(String(q.myAnswer ?? -1))
        }
        return result
    }
    
    static func randomPaper() -> Paper
    {
        let id = String(format: "%d", Int(arc4random() % 60))
        return Paper(id: id)
    }
    
    static func all() -> Paper
    {
        return Paper(id: "all")
    }
    
    
    
    init(id:String)
    {
        self.id = id
        let path = Bundle.main.path(forResource: id, ofType: "txt", inDirectory: "Papers")!
        let content = try! String(contentsOfFile: path)
        let data = content.data(using: .utf8)
        let json = JSON(data!)
        
        for item in json.arrayValue
        {
            let question = Question(json: item)
            questions.append(question)
        }
    }
}


class Question
{
    var title = ""
    var answers = [String]()
    var image : String?
    var answer = 0
    var myAnswer : Int?
    
    
    init(json:JSON) {
        title = json["title"].stringValue
        image = json["img"].string
        
        for s in json["answers"].arrayValue
        {
            answers.append(s.stringValue)
        }
        switch json["answer"].stringValue {
        case "a": answer = 0
        case "b": answer = 1
        case "c": answer = 2
        default: break
        }
        
    }
}



class TestManager
{
    static func savePaper(paper:Paper)
    {
        var list = UserDefaults.standard.array(forKey: "me.zhangxi.vicroad.history") ?? [String]()
        list.append(paper.stringValue)
        UserDefaults.standard.set(list, forKey: "me.zhangxi.vicroad.history")
    }
    static func papers() -> [Paper]
    {
        var array = [Paper]()
        if let list = UserDefaults.standard.array(forKey: "me.zhangxi.vicroad.history") as? [String]
        {
            for s in list
            {
                array.append(s.paperValue)
            }
        }
        
        return array.reversed()
    }
}


extension String
{
    var paperValue : Paper
    {
        let array = self.components(separatedBy: "#")
        let paper = Paper(id: array[0])
        paper.isSubmit = true
        
        for (i,s) in array[1].components(separatedBy: ",").enumerated()
        {
            switch s
            {
            case "-1": paper.questions[i].myAnswer = nil
            case "0","1","2": paper.questions[i].myAnswer = Int(s)
            default : break
            }
        }
        paper.date = Date(timeIntervalSince1970: TimeInterval(array[2])!)
        
        return paper
    }
}
extension Paper
{
    var stringValue : String
    {
        let record = String(format: "%@#%@#%f",id, answers.joined(separator: ","), date.timeIntervalSince1970)
        return record
    }
}
