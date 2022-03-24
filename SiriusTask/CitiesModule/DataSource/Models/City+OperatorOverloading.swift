//
//  City+OperatorOverloading.swift
//  SeriusTest
//
//  Created by Nilesh Rathod on 03/23/2022
//

import Foundation

func ==(lhs: City, rhs: String) -> Bool {
    return lhs.name.lowercased().hasPrefix(rhs.lowercased())
}

func <(lhs: City, rhs: String) -> Bool {
    return lhs.name.lowercased() < rhs.lowercased()
}

func >(lhs: City, rhs: String) -> Bool {
    return lhs.name.lowercased() > rhs.lowercased()
}
