//
//  ScrollEngineError.swift
//  ImagesScrollEngine
//
//  Created by sumofighter666 on 13.04.18.
//  Copyright © 2018 sumofighter666. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case scroll(String)
    
    static func printError(error: ServiceError) {
        
        switch error {
            
        case .scroll(let description):
            print("Scrolling error: \(description)")
            
        }
    }
}
