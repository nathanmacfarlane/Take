import Foundation

enum IntorString: Decodable {

    case int(Int), string(String)

    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }

        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }

        throw PitchesValue.missingValue
    }

    enum PitchesValue: Error {
        case missingValue
    }
}

struct MPRoute: Decodable {
    var id: Int
    var name: String
    var type: String?
    var rating: String?
    var stars: Double?
    var starVotes: IntorString
    var pitches: IntorString
    var location: [String]
    var url: String
    var latitude: Double
    var longitude: Double

    var takeRating: (Int?, Int?) {
        return ratingAndBuffer()
    }

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case type
        case rating
        case stars
        case starVotes
        case pitches
        case location
        case url
        case latitude
        case longitude
    }

    let d: [String: Int] = ["3rd": 800,
                            "4th": 900,
                            "Easy 5th": 950,
                            "5.0": 1000,
                            "5.1": 1100,
                            "5.2": 1200,
                            "5.3": 1300,
                            "5.4": 1400,
                            "5.5": 1500,
                            "5.6": 1600,
                            "5.7": 1800,
                            "5.7+": 1900,
                            "5.8-": 2000,
                            "5.8": 2100,
                            "5.8+": 2200,
                            "5.9-": 2300,
                            "5.9": 2400,
                            "5.9+": 2500,
                            "5.10a": 2600,
                            "5.10-": 2700,
                            "5.10a/b": 2800,
                            "5.10b": 2900,
                            "5.10": 3000,
                            "5.10b/c": 3100,
                            "5.10c": 3200,
                            "5.10+": 3300,
                            "5.10c/d": 3400,
                            "5.10d": 3500,
                            "5.11a": 4600,
                            "5.11-": 4700,
                            "5.11a/b": 4800,
                            "5.11b": 4900,
                            "5.11": 5000,
                            "5.11b/c": 5100,
                            "5.11c": 5200,
                            "5.11+": 5300,
                            "5.11c/d": 5400,
                            "5.11d": 5500,
                            "5.12a": 6600,
                            "5.12-": 6700,
                            "5.12a/b": 6800,
                            "5.12b": 6900,
                            "5.12": 7000,
                            "5.12b/c": 7100,
                            "5.12c": 7200,
                            "5.12+": 7300,
                            "5.12c/d": 7400,
                            "5.12d": 7500,
                            "5.13a": 8600,
                            "5.13-": 8700,
                            "5.13a/b": 8800,
                            "5.13b": 8900,
                            "5.13": 9000,
                            "5.13b/c": 9100,
                            "5.13c": 9200,
                            "5.13+": 9300,
                            "5.13c/d": 9400,
                            "5.13d": 9500,
                            "5.14a": 10500,
                            "5.14-": 10600,
                            "5.14a/b": 10700,
                            "5.14b": 10900,
                            "5.14": 11100,
                            "5.14b/c": 11150,
                            "5.14c": 11200,
                            "5.14+": 11300,
                            "5.14c/d": 11400,
                            "5.14d": 11500,
                            "5.15a": 11600,
                            "5.15-": 11700,
                            "5.15a/b": 11800,
                            "5.15b": 11900,
                            "5.15": 12000,
                            "5.15+": 12100,
                            "5.15c/d": 12200,
                            "5.15d": 12300,
                            "V-easy": 20000,
                            "V0": 20008,
                            "V0+": 20010,
                            "V0-1": 20050,
                            "V1-": 20075,
                            "V1": 20100,
                            "V1+": 20110,
                            "V1-2": 20150,
                            "V2-": 20170,
                            "V2": 20200,
                            "V2+": 20210,
                            "V2-3": 20250,
                            "V3-": 20270,
                            "V3": 20300,
                            "V3+": 20310,
                            "V3-4": 20350,
                            "V4-": 20370,
                            "V4": 20400,
                            "V4+": 20410,
                            "V4-5": 20450,
                            "V5-": 20470,
                            "V5": 20500,
                            "V5+": 20510,
                            "V5-6": 20550,
                            "V6-": 20570,
                            "V6": 20600,
                            "V6+": 20610,
                            "V6-7": 20650,
                            "V7-": 20670,
                            "V7": 20700,
                            "V7+": 20710,
                            "V7-8": 20750,
                            "V8-": 20770,
                            "V8": 20800,
                            "V8+": 20810,
                            "V8-9": 20850,
                            "V9-": 20870,
                            "V9": 20900,
                            "V9+": 20910,
                            "V9-10": 20950,
                            "V10-": 20970,
                            "V10": 21000,
                            "V10+": 21010,
                            "V10-11": 21050,
                            "V11-": 21070,
                            "V11": 21100,
                            "V11+": 21110,
                            "V11-12": 21150,
                            "V12-": 21170,
                            "V12": 21200,
                            "V12+": 21210,
                            "V12-13": 21250,
                            "V13-": 21270,
                            "V13": 21300,
                            "V13+": 21310,
                            "V13-14": 21350,
                            "V14-": 21370,
                            "V14": 21400,
                            "V14+": 21410,
                            "V14-15": 21450,
                            "V15-": 21470,
                            "V15": 21500,
                            "V15+": 21510,
                            "V15-16": 21550,
                            "V16-": 21570,
                            "V16": 21600]

    private func get8And9(x: Int, value: Int?) -> (Int?, Int?) {
        switch x {
        case 2000:
            return (value, 1)
        case 2100:
            return (value, nil)
        case 2200:
            return (value, 2)
        default:
            return (nil, nil)
        }
    }

    private func get10To13(x: Int, value: Int?) -> (Int?, Int?) {
        switch x {
        case 2600:
            return (value, 0)
        case 2700...2900:
            return (value, 1)
        case 3000:
            return (value, nil)
        case 3100...3300:
            return (value, 2)
        case 3400...3500:
            return (value, 3)
        default:
            return (nil, nil)
        }
    }

    func get14s(x: Int) -> (Int?, Int?) {
        switch x {
        case 10500:
            return (14, 0)
        case 10600...10900:
            return (14, 1)
        case 11100:
            return (14, nil)
        case 11150...11300:
            return (14, 2)
        case 11400...11500:
            return (14, 3)
        default:
            return (nil, nil)
        }
    }

    func get15s(x: Int) -> (Int?, Int?) {
        switch x {
        case 11600:
            return (15, 0)
        case 11700...11900:
            return (15, 1)
        case 12000:
            return (15, nil)
        case 12100:
            return (15, 2)
        case 12200...12300:
            return (15, 3)
        default:
            return (nil, nil)
        }
    }

    private func ratingAndBuffer() -> (Int?, Int?) {
        guard let rating = rating, let first = Array(rating.split(separator: " ")).first else { return (nil, nil) }
        let ratingString = "\(first)"

        guard let code = d[ratingString] else { return (nil, nil) }
        switch code {
        case let x where x >= 1000 && x <= 1800:
            return ((x - 1000) / 100, nil)
        // 7+
        case 1900:
            return (7, 3)
        // 8s
        case let x where x >= 2000 && x <= 2200:
            return get8And9(x: x, value: 8)
        // 9s
        case let x where x >= 2300 && x <= 2500:
            return get8And9(x: x - 300, value: 9)
        // 10s
        case let x where x >= 2600 && x <= 3500:
            return get10To13(x: x, value: 10)
        // 11s
        case let x where x >= 4600 && x <= 5500:
            return get10To13(x: x - 2000, value: 11)
        // 12s
        case let x where x >= 6600 && x <= 7500:
            return get10To13(x: x - 4000, value: 12)
        // 13s
        case let x where x >= 8600 && x <= 9500:
            return get10To13(x: x - 6000, value: 13)
        // 14s
        case let x where x >= 10500 && x <= 11500:
            return get14s(x: x)
        // 15s
        case let x where x >= 11600 && x <= 12300:
            return get15s(x: x)
        default:
            return (nil, nil)
        }
    }
}

struct MPRouteArray: Decodable {
    var routes: [MPRoute]
}
