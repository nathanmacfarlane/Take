import Foundation

struct Coordinate: Decodable {
    let lat, lon: Double
}
/// More on condition codes here: https://openweathermap.org/weather-conditions
struct WeatherDetail: Decodable {
    let id: Int
    let main, description, icon: String
}

struct Sys: Decodable {
    let type, id: Int
    let message: Double
    let country: String
}

struct Main: Decodable {
    let temp, temp_min, temp_max: Double
    let pressure, humidity: Int
}

struct Wind: Decodable {
    let speed: Double
}

struct Cloud: Decodable {
    let all: Int
}

struct Weather: Decodable {
    let coord: Coordinate
    let cod, visibility, id: Int
    let name: String
    let base: String
    let weather: [WeatherDetail]
    let sys: Sys
    let main: Main
    let wind: Wind
    let clouds: Cloud
    var dt: Double
}

struct City: Decodable {
    let id, population: Int
    let name, country: String
    let coord: Coordinate
}
