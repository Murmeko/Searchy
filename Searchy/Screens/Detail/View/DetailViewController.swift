//
//  DetailViewController.swift
//  Searchy
//
//  Created by Yiğit Erdinç on 21.07.2023.
//

import UIKit

protocol DetailViewControllerProtocol: BaseViewControllerProtocol {
  var viewModel: DetailViewModelProtocol { get }
}

class DetailViewController: UIViewController, DetailViewControllerProtocol {
  lazy var dimmerView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0
    return view
  }()

  lazy var contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBackground
    view.layer.cornerRadius = 20
    view.clipsToBounds = true
    return view
  }()

  lazy var sliderPillView: UIView = {
    let view = UIView()
    view.backgroundColor = .label
    view.layer.cornerRadius = 3
    return view
  }()

  var viewModel: DetailViewModelProtocol = DetailViewModel()

  private let dimmerAlpha: CGFloat = 0.4

  private var defaultHeight: CGFloat!
  private var dismissibleHeight: CGFloat!
  private var maximumContainerHeight: CGFloat!

  private var currentContainerHeight: CGFloat!

  private var containerViewHeightConstraint: NSLayoutConstraint?
  private var containerViewBottomConstraint: NSLayoutConstraint?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    bindViewModel()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateShowDimmedView()
    animatePresentContainer()
  }
}

// MARK: ViewController Setup
extension DetailViewController {
  internal func setupView() {
    view.backgroundColor = .clear

    setupDismissGesture()
    setupPanGesture()

    setDefaultViewHeight()
    setMultioptionViewConstraints()
  }

  private func setDefaultViewHeight() {
    let calculatedHeight = 193 + (48 * 4) + view.safeAreaInsets.bottom
    if calculatedHeight < UIScreen.main.bounds.height / 2 {
      defaultHeight = calculatedHeight
      if let window = UIApplication.shared.firstWindow() {
        defaultHeight += window.safeAreaInsets.bottom
      }
    } else {
      defaultHeight = (UIScreen.main.bounds.height / 2) + 50
    }
    dismissibleHeight = defaultHeight - 50
    maximumContainerHeight = defaultHeight
    currentContainerHeight = defaultHeight
  }

  private func setMultioptionViewConstraints() {
    var constraints: [NSLayoutConstraint] = []

    view.addSubview(dimmerView)
    dimmerView.translatesAutoresizingMaskIntoConstraints = false
    let dimmerViewConstraints: [NSLayoutConstraint] = [dimmerView.topAnchor.constraint(equalTo: view.topAnchor),
                                                       dimmerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                                       dimmerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                                       dimmerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
    constraints.append(contentsOf: dimmerViewConstraints)

    view.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    var contentViewConstraints: [NSLayoutConstraint] = []
    contentViewConstraints.append(contentsOf: [contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                               contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    constraints.append(contentsOf: contentViewConstraints)

    NSLayoutConstraint.activate(constraints)

    setContentViewConstraints()

    containerViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: defaultHeight)
    containerViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)

    containerViewHeightConstraint?.isActive = true
    containerViewBottomConstraint?.isActive = true
  }

  private func setContentViewConstraints() {
    var contentConstraints: [NSLayoutConstraint] = []

    contentView.addSubview(sliderPillView)
    sliderPillView.translatesAutoresizingMaskIntoConstraints = false
    let sliderPillImageViewConstraints: [NSLayoutConstraint] = [sliderPillView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                                                                sliderPillView.widthAnchor.constraint(equalToConstant: 50),
                                                                sliderPillView.heightAnchor.constraint(equalToConstant: 6),
                                                                sliderPillView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)]
    contentConstraints.append(contentsOf: sliderPillImageViewConstraints)

    NSLayoutConstraint.activate(contentConstraints)
  }

  private func setupDismissGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
    dimmerView.addGestureRecognizer(tapGesture)
  }

  private func setupPanGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
    panGesture.delaysTouchesBegan = false
    panGesture.delaysTouchesEnded = false
    view.addGestureRecognizer(panGesture)
  }
}

// MARK: - ViewModel Bindings
extension DetailViewController {
  internal func bindViewModel() {
    viewModel.router.pushViewController = pushViewController()
    viewModel.router.dismissViewController = dismissViewController()
  }

  @objc
  private func handlePanGesture(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
    let isDraggingDown = translation.y > 0
    let newHeight = currentContainerHeight - translation.y
    switch gesture.state {
    case .changed:
      if newHeight < maximumContainerHeight {
        containerViewHeightConstraint?.constant = newHeight
        view.layoutIfNeeded()
      }
    case .ended:
      if newHeight < dismissibleHeight {
        self.animateDismissView()
      } else if newHeight < defaultHeight {
        animateContainerHeight(defaultHeight)
      } else if newHeight < maximumContainerHeight && isDraggingDown {
        animateContainerHeight(defaultHeight)
      } else if newHeight > defaultHeight && !isDraggingDown {
        animateContainerHeight(maximumContainerHeight)
      }
    default:
      break
    }
  }

  @objc
  private func handleCloseAction() {
    animateDismissView()
  }

  private func animateContainerHeight(_ height: CGFloat) {
    UIView.animate(withDuration: 0.5) {
      self.containerViewHeightConstraint?.constant = height
      self.view.layoutIfNeeded()
    }
    currentContainerHeight = height
  }

  private func animatePresentContainer() {
    UIView.animate(withDuration: 0.5) {
      self.containerViewBottomConstraint?.constant = 50
      self.view.layoutIfNeeded()
    }
  }

  private func animateShowDimmedView() {
    dimmerView.alpha = 0
    UIView.animate(withDuration: 0.5) {
      self.dimmerView.alpha = self.dimmerAlpha
    }
  }

  @objc
  private func animateDismissView() {
    dimmerView.alpha = dimmerAlpha

    UIView.animate(withDuration: 0.5) { self.dimmerView.alpha = 0 } completion: { _ in
      self.dismiss(animated: false)
    }

    UIView.animate(withDuration: 0.25) {
      self.containerViewBottomConstraint?.constant = self.defaultHeight
      self.view.layoutIfNeeded()
    }
  }
}
