import Foundation
import UIKit

struct MatchCriteria {
    var ageLow: CGFloat
    var ageHigh: CGFloat
    var sportGrade: Float
    var trGrade: Float
    var tradGrade: Float
    var boulderGrade: Int
    var sportLetter: String
    var trLetter: String
    var tradLetter: String
    init(ageL: CGFloat, ageH: CGFloat, sportGrade: Float,
         trGrade: Float, tradGrade: Float, boulderGrade: Int,
         sportLetter: String, trLetter: String, tradLetter: String) {
        self.ageLow = ageL
        self.ageHigh = ageH
        self.sportGrade = sportGrade
        self.trGrade = trGrade
        self.tradGrade = tradGrade
        self.boulderGrade = boulderGrade
        self.sportLetter = sportLetter
        self.trLetter = trLetter
        self.tradLetter = tradLetter
    }
}
