import Foundation
import UIKit

extension UserProfileVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let planFB = plans[indexPath.row]
        MPService.shared.getRoutes(ids: [planFB.easy, planFB.medium, planFB.hard]) { routes in
            self.pushDetailView(easy: routes[0], medium: routes[1], hard: routes[2])
        }
    }

    func pushDetailView(easy: MPRoute, medium: MPRoute, hard: MPRoute) {
        let plan = DayPlan(easy: easy, medium: medium, hard: hard, distance: nil)
        let planTripDetailVC = PlanTripDetailVC()
        planTripDetailVC.plan = plan
        // this breaks it... 
//        self.present(planTripDetailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
