//
//  CitiesService.swift
//  SeriusTest
//
//  Created by Nilesh Rathod on 03/23/2022.
//

import Foundation

protocol CitiesInteractorToPresenterProtocol: class {
    func citiesSearchResults(cities: [City])
    func dataIsReady()
}

class CitiesInteractor {
    
    // MARK: - Properties
    var presenterDelegate: CitiesInteractorToPresenterProtocol?

    var citiesDistributedData: [String: [City]] = [:]

    /// - Returns: cities json data
    func loadCitiesFileData() -> Data? {
        if let url = Bundle.main.url(forResource: "cities", withExtension: "json") {
            do {
                return try Data(contentsOf: url)
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    // MARK: - Methodsc
    /// This method used to map json data to array of City models
    /// - Parameter data: json cities data
    /// - Returns: array of Cities Model
    func mapCitiesJsonData(from data: Data?) -> [City] {
        guard let citiesData = data else {return [City]()}
        do {
            let citiesJsonData = try JSONDecoder().decode([City].self, from: citiesData)
            return citiesJsonData
        } catch {
            print("error:\(error)")
        }
        return [City]()
    }

    /// - Parameter cities: all cities models non sorted
    func addCitiesToDataSourceBasedOnFirstChar(cities: [City]) {
        for city in cities {
            let firstChar = String(city.name.prefix(1).lowercased())
            if citiesDistributedData[firstChar] != nil {
                citiesDistributedData[firstChar]?.append(city)
            } else {
                citiesDistributedData[firstChar] = [City]()
                citiesDistributedData[firstChar]?.append(city)
            }
        }
    }
    
    func sortCitiesAlphabetically() {
        for (cityFirstCarshKey, _) in citiesDistributedData {
            citiesDistributedData[cityFirstCarshKey] = citiesDistributedData[cityFirstCarshKey]?.sorted { $0 < $1 }
        }
    }
    
    /// - Parameters:
    ///   - citiesArray: array that will search in it
    ///   - searchedText: user typed text
    /// - Returns: Filtered array of type City which its prefix match with user typed string
    func binarySearch(in citiesArray: [City], for searchedText: String) -> [City] {
        var leftStartIndex = 0
        var rightEndIndex = citiesArray.count - 1
        var finalArray = [City]()
        while leftStartIndex <= rightEndIndex {
            let middleIndex = (leftStartIndex + rightEndIndex) / 2
            if citiesArray[middleIndex] == searchedText {
                for index in (leftStartIndex..<middleIndex).reversed() {
                    if citiesArray[index].name.lowercased().hasPrefix(searchedText.lowercased()) {
                        finalArray.insert(citiesArray[index], at: 0)
                    } else {break}
                }
                for index in middleIndex...rightEndIndex {
                    if citiesArray[index].name.lowercased().hasPrefix(searchedText.lowercased()) {
                        finalArray.append(citiesArray[index])
                    } else {break}
                }
                return finalArray
            } else if citiesArray[middleIndex] < searchedText {
                leftStartIndex = middleIndex + 1
            } else if citiesArray[middleIndex] > searchedText {
                rightEndIndex = middleIndex - 1
            }
        }
        
        return [City]()
    }
}

extension CitiesInteractor: CitiesViewToInteractorProtocol {
    
    /// This is the first method that will run after ViewLoad
    func prepareCitiesData() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let weakSelf = self else {return}
            let loadedData = weakSelf.loadCitiesFileData()
            let citiesModels = weakSelf.mapCitiesJsonData(from: loadedData)
            weakSelf.addCitiesToDataSourceBasedOnFirstChar(cities: citiesModels)
            weakSelf.sortCitiesAlphabetically()
            weakSelf.presenterDelegate?.dataIsReady()
        }
    }
    
    
    /// - Parameter userInput: String that user typed in search bar
    func searchFor(userInput: String) {
        let firstChar = String(userInput.prefix(1)).lowercased()
        let fiteredCities = binarySearch(in: citiesDistributedData[firstChar] ?? [City](), for: userInput.lowercased())
        presenterDelegate?.citiesSearchResults(cities: fiteredCities)
    }
}
