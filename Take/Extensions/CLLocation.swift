import Foundation
import MapKit

extension CLLocation {
    func cityAndState(completion: @escaping (_ city: String?, _ state: String?, _ error: Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            CLGeocoder().reverseGeocodeLocation(self) { placemarks, error in
                completion(placemarks?.first?.locality, self.stateAbbrevToString(placemarks?.first?.administrativeArea), error)
            }
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func stateAbbrevToString(_ abbrev: String?) -> String {
        guard let abbrev = abbrev else { return "" }
        switch abbrev.uppercased() {
        case "AL":
            return "Alabama"
        case "AK":
            return "Alaska"
        case "AZ":
            return "Arizona"
        case "AR":
            return "Arkansas"
        case "CA":
            return "California"
        case "CO":
            return "Colorado"
        case "CT":
            return "Connecticut"
        case "DE":
            return "Deleware"
        case "FL":
            return "Florida"
        case "GA":
            return "Georgia"
        case "HI":
            return "Hawaii"
        case "ID":
            return "Idaha"
        case "IL":
            return "Illinois"
        case "IN":
            return "Indiana"
        case "IA":
            return "Iowa"
        case "KS":
            return "Kansas"
        case "KY":
            return "Kentucky"
        case "LA":
            return "Louisiana"
        case "ME":
            return "Maine"
        case "MD":
            return "Maryland"
        case "MA":
            return "Massachusetts"
        case "MI":
            return "Michigan"
        case "MN":
            return "Minnesota"
        case "MS":
            return "Mississippi"
        case "MO":
            return "Missouri"
        case "MT":
            return "Montana"
        case "NE":
            return "Nebraska"
        case "NV":
            return "Nevada"
        case "NH":
            return "New Hampshire"
        case "NJ":
            return "New Jersey"
        case "NM":
            return "New Mexico"
        case "NY":
            return "New York"
        case "NC":
            return "North Carolina"
        case "ND":
            return "North Dakota"
        case "OH":
            return "Ohio"
        case "OK":
            return "Oklahoma"
        case "OR":
            return "Oregon"
        case "PA":
            return "Pennsylvania"
        case "RI":
            return "Rhode Island"
        case "SC":
            return "South Carolina"
        case "SD":
            return "South Dakota"
        case "TN":
            return "Tennessee"
        case "TX":
            return "Texas"
        case "UT":
            return "Utah"
        case "VT":
            return "Vermont"
        case "VA":
            return "Virginia"
        case "WA":
            return "Washington"
        case "WV":
            return "West Virginia"
        case "WI":
            return "Wisconsin"
        case "WY":
            return "Wyoming"
        default:
            return abbrev
        }
    }
}
