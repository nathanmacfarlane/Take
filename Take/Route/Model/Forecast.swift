import Foundation

struct ForecastWind: Decodable {
    let speed, deg: Double
}

struct ForecastMain: Decodable {
    let temp, pressure, sea_level, grnd_level: Double
    let humidity: Int
}

struct ForecastData: Decodable {
    let dt: Double
    let main: ForecastMain
    let weather: [WeatherDetail]
    let wind: ForecastWind
    var date: Date {
        return Date(timeIntervalSince1970: dt)
    }
}

struct Forecast: Decodable {
    let cnt: Int
    let message: Double
    let list: [ForecastData]
    let city: City
    let cod: String
}
