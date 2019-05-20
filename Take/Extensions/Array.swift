import Foundation

extension Array {
    func first(count: Int) -> [Element] {
        var new: [Element] = []
        var c = 0
        for e in self {
            if c >= count { break }
            c += 1
            new.append(e)
        }
        return new
    }
    func splitIntoParts(_ parts: Int) -> [[Element]] {
        var new: [[Element]] = []
        let subLength = Int((Float(self.count) / Float(parts)))
        var subArray: [Element] = []
        var count = 1
        for e in self {
            if count == subLength {
                subArray.append(e)
                new.append(subArray)
                subArray = []
                count = 1
            } else {
                count += 1
                subArray.append(e)
            }
        }
        if count != 1 {
            new[new.count - 1].append(contentsOf: subArray)
        }
        return new
    }
}
