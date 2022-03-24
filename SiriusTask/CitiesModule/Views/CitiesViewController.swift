//
//  ViewController.swift
//  SeriusTest
//
//  Created by Nilesh Rathod on 03/23/2022.
//

import UIKit


/// This protocol is implemented by cities Interactor
/// View To Interactor
protocol CitiesViewToInteractorProtocol: class {
    func searchFor(userInput: String)
    func prepareCitiesData()
}

class CitiesViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    let seconds = 3.0
    // MARK: - Properties
    var interactorDelegate: CitiesViewToInteractorProtocol!
    var citiesRouter: citiesRouterProtocol!
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    var filtteredCities: [City] = []
    var allData: [City] = []
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactorDelegate.prepareCitiesData()
       // SetData()
    }
    
    /// setup views after view controller load
    func setupViews() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        activityIndicator?.startAnimating()
    }
}

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiyCellID", for: indexPath)
        cell.textLabel?.text = "\(filtteredCities[indexPath.row].name), \(filtteredCities[indexPath.row].country)"
        cell.detailTextLabel?.text = "lat: \(filtteredCities[indexPath.row].coord.lat)   lon: \(filtteredCities[indexPath.row].coord.lon)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        citiesRouter.navigateToLocationScreen(view: self, cityInfo: filtteredCities[indexPath.row])
    }
}

extension CitiesViewController: CitiesPresenterToViewProtocol {
    
    
    /// This method will set cities table view data source then reload its data
    /// - Parameter cities: Cities models to be displayed
    func setFillteredCities(cities: [City]) {
        filtteredCities = cities
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func setAllCities(cities: [City]) {
        allData = cities
        filtteredCities = cities
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    /// This method will start and show the activity indicator
    func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.startAnimating()
        }
    }
    
    /// this method will stop and hide the activity indicator
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.stopAnimating()
        }
    }
    
}

extension CitiesViewController: UISearchBarDelegate {
    
    // set Data
    /// called when text changes in search bar
    /// - Parameters:
    ///   - searchText: new typed text in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filtteredCities = allData
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            return
        }
        interactorDelegate.searchFor(userInput: searchText)
    }
}
