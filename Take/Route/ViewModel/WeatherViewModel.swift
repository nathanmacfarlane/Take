import Foundation
import UIKit

class WeatherViewModel {
    private var weather: Weather!

    init(weather: Weather) {
        self.weather = weather
    }

    var sunsetStrings: (String, String) {
        let sunsetDate = Date(timeIntervalSince1970: weather.sys.sunset)
        let hour = sunsetDate.getInt(type: .hour)
        let minute = (sunsetDate.getInt(type: .minute))
        return ("\(hour > 12 ? (hour - 12) : hour):\(minute)", (hour >= 12 ? "PM" : "AM"))
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

    var weatherIcon: UIImage? {
        guard let icon = weather.weather.first?.icon else { return nil }
        return UIImage(named: "\(icon.prefix(2))")
    }
}
