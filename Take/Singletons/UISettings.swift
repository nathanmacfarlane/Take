import Foundation
import UIKit

class UISettings {
    static let shared = UISettings()
    let light = Light()
    let dark = Dark()
    var colorScheme: ColorScheme {
        return mode == .light ? light : dark
    }
    // set this variable to change the color scheme
    var mode: ColorMode = .dark
}

enum ColorMode {
    case light, dark
}

protocol ColorScheme {
    var backgroundPrimary: UIColor { get }
    var backgroundDarker: UIColor { get }
    var backgroundLighter: UIColor { get }
    var backgroundCell: UIColor { get }
    var textPrimary: UIColor { get }
    var textSecondary: UIColor { get }
    var accent: UIColor { get }
    var complimentary: UIColor { get }
    var gradeBubble: UIColor { get }
    var segmentColor: UIColor { get }
    var outlineButton: UIColor { get }
}

struct Dark: ColorScheme {
    let backgroundPrimary = #colorLiteral(red: 0.1137254902, green: 0.1176470588, blue: 0.1411764706, alpha: 1)
    let backgroundDarker = #colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)
    let backgroundLighter = #colorLiteral(red: 0.3060097098, green: 0.3057537675, blue: 0.3144521117, alpha: 1)
    let backgroundCell = #colorLiteral(red: 0.1715052911, green: 0.1874919698, blue: 0.2258787701, alpha: 1)
    let textPrimary = #colorLiteral(red: 0.6784313725, green: 0.6784313725, blue: 0.6784313725, alpha: 1)
    let textSecondary  = #colorLiteral(red: 0.6392156863, green: 0.6392156863, blue: 0.6392156863, alpha: 1)
    let accent = #colorLiteral(red: 0.9019607843, green: 0.5629953748, blue: 0.6269861983, alpha: 1)
    let complimentary = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    let gradeBubble = #colorLiteral(red: 0.1848252595, green: 0.3804076532, blue: 0.2946595092, alpha: 1)
    let outlineButton = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    let segmentColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
}

struct Light: ColorScheme {
    let backgroundPrimary = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
    let backgroundDarker = #colorLiteral(red: 0.4117647059, green: 0.4588235294, blue: 0.5450980392, alpha: 1)
    let backgroundLighter = #colorLiteral(red: 0.9999025464, green: 1, blue: 0.9998814464, alpha: 1)
    let backgroundCell = #colorLiteral(red: 0.9999025464, green: 1, blue: 0.9998814464, alpha: 1)
    let segmentColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    let textPrimary = #colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)
    let outlineButton = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    let textSecondary  = #colorLiteral(red: 0.1803921569, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
    let accent = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    let complimentary = #colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)
    let gradeBubble = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
}
