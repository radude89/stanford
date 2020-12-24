//
//  Array+Only.swift
//  Memorize
//
//  Created by Radu Dan on 23.12.2020.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
