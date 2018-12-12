import Foundation

struct ForecastViewModel {
    private var forecast: Forecast!

    init(forecast: Forecast) {
        self.forecast = forecast
    }

    var tomorrow: [Date: Double] {
        var forecasts: [Date: Double] = [:]
        for forecast in forecast.list {
            if Calendar.current.isDateInTomorrow(forecast.date) {
                forecasts[forecast.date] = forecast.main.temp
            }
        }
        return forecasts
    }

    var weekend: [Date: Double] {
        var forecasts: [Date: Double] = [:]
        for forecast in forecast.list {
            if Calendar.current.isDateInWeekend(forecast.date) {
                forecasts[forecast.date] = forecast.main.temp
            }
        }
        return forecasts
    }
}
