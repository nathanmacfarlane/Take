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
}

struct MPRouteArray: Decodable {
    var routes: [MPRoute]
}
