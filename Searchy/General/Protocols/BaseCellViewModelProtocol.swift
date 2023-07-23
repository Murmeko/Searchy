//
//  BaseCellViewModelProtocol.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 22.07.2023.
//

import Foundation

protocol BaseCellViewModelProtocol {
  var type: CollectionViewCellTypable { get }

  func getSize() -> CGSize
}
