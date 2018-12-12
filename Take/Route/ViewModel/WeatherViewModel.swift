import Foundation

class WeatherViewModel {
    private var weather: Weather!

    init(weather: Weather) {
        self.weather = weather
    }

    var temperature: Double {
        return weather.main.temp
    }

    var temperatureString: String {
        return "\(weather.main.temp)° F"
    }

    var description: String {
        return weather.weather.first?.main ?? ""
    }

    var windSpeed: Double {
        return weather.wind.speed
    }

    var percentClouds: Int {
        return weather.clouds.all
    }
}
