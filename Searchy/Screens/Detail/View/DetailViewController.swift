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
    view.backgroundColor = .secondarySystemBackground
    view.layer.cornerRadius = 24
    view.clipsToBounds = true
    return view
  }()

  lazy var sliderPillView: UIView = {
    let view = UIView()
    view.backgroundColor = .label
    view.layer.cornerRadius = 3
    return view
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 32)
    label.numberOfLines = 2
    return label
  }()

  lazy var genreLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  lazy var releaseDateLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  lazy var summaryLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()

  var viewModel: DetailViewModelProtocol

  private let dimmerAlpha: CGFloat = 0.4

  private var defaultHeight: CGFloat!
  private var dismissibleHeight: CGFloat!
  private var maximumContainerHeight: CGFloat!

  private var currentContainerHeight: CGFloat!

  private var containerViewHeightConstraint: NSLayoutConstraint?
  private var containerViewBottomConstraint: NSLayoutConstraint?

  init(viewModel: DetailViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    bindViewModel()
    viewModel.viewIsReady()
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
    setGeneralViewConstraints()
  }

  private func setDefaultViewHeight() {
    defaultHeight = 220
    dismissibleHeight = defaultHeight - 50
    maximumContainerHeight = UIScreen.main.bounds.height / 2
    currentContainerHeight = defaultHeight
  }

  private func setGeneralViewConstraints() {
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
    contentView.addSubview(sliderPillView)
    sliderPillView.translatesAutoresizingMaskIntoConstraints = false
    sliderPillView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
    sliderPillView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    sliderPillView.heightAnchor.constraint(equalToConstant: 6).isActive = true
    sliderPillView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

    contentView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor.constraint(equalTo: sliderPillView.bottomAnchor, constant: 24).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true

    contentView.addSubview(genreLabel)
    genreLabel.translatesAutoresizingMaskIntoConstraints = false
    genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
    genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true

    contentView.addSubview(releaseDateLabel)
    releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
    releaseDateLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 8).isActive = true
    releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true

    contentView.addSubview(summaryLabel)
    summaryLabel.translatesAutoresizingMaskIntoConstraints = false
    summaryLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 36).isActive = true
    summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
    summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
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
    viewModel.updateView = updateView()
    viewModel.router.pushViewController = pushViewController()
    viewModel.router.dismissViewController = dismissViewController()
  }

  private func updateView() -> () -> Void {
    return { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.titleLabel.text = self.viewModel.titleLabelText
        self.genreLabel.text = self.viewModel.genreLabelText
        self.releaseDateLabel.text = self.viewModel.releaseDateLabelText
        self.summaryLabel.text = self.viewModel.summaryLabelText
      }
    }
  }
}

extension DetailViewController {
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

    UIView.animate(withDuration: 0.5, animations: {
      self.dimmerView.alpha = 0
    }, completion: { _ in
      self.dismiss(animated: false)
    })

    UIView.animate(withDuration: 0.25) {
      self.containerViewBottomConstraint?.constant = self.defaultHeight
      self.view.layoutIfNeeded()
    }
  }
}
