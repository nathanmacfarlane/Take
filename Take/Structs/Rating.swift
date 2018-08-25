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
//    var protection          : Protection!
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
    var desc: String
    var intDiff: Int
    var type: RouteType
    var buffer: String?
    var danger: String?

    var description: String {
        switch type {
        case .boulder:
            return "V\(intDiff)\(buffer ?? "")"
        case .climb:
            return "5.\(intDiff)\(buffer ?? "")"
        default:
            fatalError("Unsupported")
        }
    }

    func toAnyObject() -> Any {
        var any: [String: Any] = [:]
        any["desc"] = desc
        any["intDiff"] = intDiff
        any["type"] = type.hashValue
        if buffer != nil {
            any["buffer"] = buffer
        }
        if danger != nil {
            any["danger"] = danger
        }
        return any
    }

    init(desc: String) {
        self.desc = desc
        self.type = .aid
        self.intDiff = 0
        self.buffer = ""
        self.danger = ""
//        self.type = getType(desc)
//        self.intDiff = getDiff(desc)
        self.buffer = getBuffer(desc)
        self.danger = getDanger(desc)
    }

//    init?(anyObject: [String: Any]) {
//        guard let typeInt = anyObject["type"] as? Int else { return nil }
//
//        guard let tempDesc = anyObject["desc"] as? String else { return nil }
//        guard let tempDiff = anyObject["intDiff"] as? Int else { return nil }
//        self.intDiff = tempDiff
//        self.desc = tempDesc
//        self.type = typeInt == 1 ? .climb : .boulder
//        self.buffer = anyObject["buffer"] as? String
//        self.danger = anyObject["danger"] as? String
//    }

    private func getDanger(_ desc: String) -> String? {
        let chars = Array(desc)
        guard let i = chars.index(of: " ") else { return nil }
        var danger = ""
        for n in i..<chars.count {
            danger = "\(danger)\(chars[n])"
        }
        return danger.isEmpty ? nil : danger
    }

    private func getBuffer(_ desc: String) -> String? {
        let chars = Array(desc)
        var buff: String = ""
        for n in 1..<chars.count {
            if (chars[n] >= "0" && chars[n] <= "9") || chars[n] == "." {
                continue
            }
            if chars[n] == " " {
                break
            }
            buff = "\(buff)\(chars[n])"
        }
        return buff.isEmpty ? nil : buff
    }

//    private func getType(_ desc: String) -> RouteType {
//        let chars = Array(desc)
//        if chars[0] == "V" {
//            return .boulder
//        } else {
//            return .climb
//        }
//    }

//    private func getDiff(_ desc: String) -> Int {
//        let chars = Array(desc)
//        var diff = ""
//        var start = 1
//        if self.type == .climb {
//            start += 1
//        }
//        for n in start..<chars.count {
//            if chars[n] > "9" || chars[n] < "0" {
//                if let toReturn = Int(diff) {
//                    return toReturn
//                } else {
//                    return 0
//                }
//            }
//            diff = "\(diff)\(chars[n])"
//        }
//        if let toReturn = Int(diff) {
//            return toReturn
//        } else {
//            return 0
//        }
//    }

}
