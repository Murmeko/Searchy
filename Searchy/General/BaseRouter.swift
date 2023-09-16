//
//  BaseRouter.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import UIKit

protocol BaseRouterProtocol {
    var pushViewController: ((UIViewController) -> Void)? { get set }
    var presentViewController: ((UIViewController) -> Void)? { get set }
    var dismissViewController: (() -> Void)? { get set }
}

class BaseRouter: BaseRouterProtocol {
    var pushViewController: ((UIViewController) -> Void)?
    var presentViewController: ((UIViewController) -> Void)?
    var dismissViewController: (() -> Void)?
}
