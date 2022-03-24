//
//  CitiesPresenter.swift
//  SeriusTest
//
//  Created by Nilesh Rathod on 03/23/2022.
//

import Foundation

protocol CitiesPresenterToViewProtocol: class {
    func startLoading()
    func stopLoading()
    func setFillteredCities(cities: [City])
    func setAllCities(cities: [City])
}

class CitiesPresenter {
    var viewDelegate: CitiesPresenterToViewProtocol!
    
}

extension CitiesPresenter: CitiesInteractorToPresenterProtocol {
    
    /// Interactor will call this method when cities data is ready
    func dataIsReady() {
        viewDelegate.stopLoading()
    }
    
    /// Interactor will call this method when search result is ready
    func citiesSearchResults(cities: [City]) {
        viewDelegate.setFillteredCities(cities: cities)
    }
    
    /// Interactor will call this method when search result is ready
    func citiesAllResults(cities: [City]) {
        viewDelegate.setAllCities(cities: cities)
    }
}
