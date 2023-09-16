//
//  CollectionViewCellTypable.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 23.07.2023.
//

import Foundation

protocol CollectionViewCellTypable {
    var identifier: String { get }
    var cellClass: BaseCollectionViewCellProtocol.Type { get }
}
