import Foundation
import UIKit

struct MatchCriteria {
    var ageLow: CGFloat
    var ageHigh: CGFloat
    var sportGradeH: Int
    var trGradeH: Int
    var tradGradeH: Int
    var boulderGradeH: Int
    var sportGradeL: Int
    var trGradeL: Int
    var tradGradeL: Int
    var boulderGradeL: Int
    var sportLetter: String
    var trLetter: String
    var tradLetter: String
    init(ageL: CGFloat, ageH: CGFloat, sportGradeL: Int, sportGradeH: Int,
         trGradeL: Int, trGradeH: Int, tradGradeL: Int, tradGradeH: Int, boulderGradeH: Int, boulderGradeL: Int,
         sportLetter: String, trLetter: String, tradLetter: String) {
        self.ageLow = ageL
        self.ageHigh = ageH
        self.sportGradeL = sportGradeL
        self.sportGradeH = sportGradeH
        self.trGradeL = trGradeL
        self.trGradeH = trGradeH
        self.tradGradeL = tradGradeL
        self.tradGradeH = tradGradeH
        self.boulderGradeH = boulderGradeH
        self.boulderGradeL = boulderGradeL
        self.sportLetter = sportLetter
        self.trLetter = trLetter
        self.tradLetter = tradLetter
    }
}
