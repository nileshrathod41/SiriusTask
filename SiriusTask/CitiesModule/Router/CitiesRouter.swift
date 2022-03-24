//
//  CitiesRouter.swift
//  SeriusTest
//
//  Created by Nilesh Rathod on 03/23/2022.
//

import UIKit

protocol citiesRouterProtocol {
    func navigateToLocationScreen(view: CitiesViewController, cityInfo: City)
}

class CitiesRouter {
    
    /// Create Cities Module
    /// - Returns: CitiesViewController impeded in UINavigationController
    static func createCitiesModule() -> UINavigationController {
        let citiesPresenter = CitiesPresenter()
        let citiesInteractor = CitiesInteractor()
        let citiesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CitiesViewController") as! CitiesViewController
        citiesVC.citiesRouter = CitiesRouter()
        citiesVC.interactorDelegate = citiesInteractor
        citiesInteractor.presenterDelegate = citiesPresenter
        citiesPresenter.viewDelegate
 = citiesVC
        return UINavigationController(rootViewController: citiesVC)
    }
}

extension CitiesRouter: citiesRouterProtocol {
    
    /// - Parameters:
    ///   - view: View which location view controller will be pushed over
    ///   - cityInfo: City model which its coordinates will be add on the map
    func navigateToLocationScreen(view: CitiesViewController, cityInfo: City) {
        let locationViewController = CityLocationViewController(nibName: "LocationViewController", bundle: nil)
        locationViewController.city = cityInfo
        view.navigationController?.pushViewController(locationViewController, animated: false)
    }
}
