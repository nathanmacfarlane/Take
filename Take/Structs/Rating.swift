//
//  OldRating.swift
//  Take
//
//  Created by Family on 5/16/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Foundation

//struct Rating {
//    var type                : TYPE!
//    var classification      : Int!
//    var subClassification   : Int?
//    var buffer              : BUFFER?
//    var protection          : PROTECTION!
//
//    var description : String! {
//        switch type {
//        case .boulder:
//            return "V\(classification)\(buffer != nil && buffer == .plus ? "+" : "-")"
//        case .climb:
//            return "\(classification).\(subClassification!)\(buffer != nil && buffer == .plus ? "+" : "-")"
//        default:
//            return "INVALID TYPE"
//        }
//    }
//
//}

struct Rating {
    var desc        : String!
    var intDiff     : Int!
    var type        : TYPE!
    var buffer      : String?
    var danger      : String?
    
    var description : String! {
        switch type {
        case .boulder:
            return "V\(intDiff!)\(buffer ?? "")"
        case .climb:
            return "5.\(intDiff!)\(buffer ?? "")"
        default:
            fatalError("Unsupported")
        }
    }
    
    func toAnyObject() -> Any {
        var a : [String: Any] = [:]
        a["desc"] = desc
        a["intDiff"] = intDiff
        a["type"] = type.hashValue
        if buffer != nil {
            a["buffer"] = buffer
        }
        if danger != nil {
            a["danger"] = danger
        }
        return a
    }
    
    init(desc: String) {
        self.desc = desc
        self.type = getType(desc)
        self.intDiff = getDiff(desc)
        self.buffer = getBuffer(desc)
        self.danger = getDanger(desc)
    }
    
    init(anyObject: [String: Any]) {
        let typeInt = anyObject["type"] as! Int
        self.desc       = anyObject["desc"] as! String
        self.intDiff    = anyObject["intDiff"] as! Int
        self.type       = typeInt == 1 ? .climb : .boulder
        self.buffer     = anyObject["buffer"] as? String
        self.danger     = anyObject["danger"] as? String
    }
    
    private func getDanger(_ desc: String) -> String? {
        let chars = Array(desc)
        let i = chars.index(of: " ")
        var danger = ""
        if i == nil {
            return nil
        }
        for n in i!..<chars.count {
            danger = "\(danger)\(chars[n])"
        }
        if danger == "" {
            return nil
        }
        return danger
    }
    
    private func getBuffer(_ desc: String) -> String? {
        let chars = Array(desc)
        var buff = ""
        for n in 1..<chars.count {
            if (chars[n] >= "0" && chars[n] <= "9") || chars[n] == "." {
                continue
            }
            if chars[n] == " " {
                break
            }
            buff = "\(buff)\(chars[n])"
        }
        if buff == "" {
            return nil
        }
        return buff
    }
    
    private func getType(_ desc: String) -> TYPE {
        let chars = Array(desc)
        if chars[0] == "V" {
            return .boulder
        } else {
            return .climb
        }
    }
    
    private func getDiff(_ desc: String) -> Int {
        let chars = Array(desc)
        var diff = ""
        var start = 1
        if self.type == .climb {
            start += 1
        }
        for n in start..<chars.count {
            if chars[n] > "9" || chars[n] < "0" {
                if let toReturn = Int(diff) {
                    return toReturn
                } else {
                    return 0
                }
            }
            diff = "\(diff)\(chars[n])"
        }
        if let toReturn = Int(diff) {
            return toReturn
        } else {
            return 0
        }
    }
    
}
