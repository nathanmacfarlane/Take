import Foundation

struct MPUserStylesType: Codable {
    var lead: String
    var follow: String
}

struct MPUserStyles: Codable {
    var Trad: MPUserStylesType
    var Sport: MPUserStylesType
    var Aid: MPUserStylesType
    var Ice: MPUserStylesType
    var Mixed: MPUserStylesType
    var Boulders: MPUserStylesType
}

struct MPUser: Codable {
    var id: Int
    var name: String
    var memberSince: String
    var lastVisit_mtb: String
    var lastVisit_hike: String
    var lastVisit_ski: String
    var lastVisit_trailrun: String
    var lastVisit_climb: String
    var favoriteClimbs: String
    var otherInterests: String
    var postalCode: String
    var location: String
    var url: String
    var personalText: String
    var styles: MPUserStyles
    var pts_mtb: Int
    var pts_hike: Int
    var pts_ski: Int
    var pts_trailrun: Int
    var pts_climb: Int
}
