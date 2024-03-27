//
//  GameViewController.swift
//  Traffic Race Master
//
//  Created by XE on 19.02.2024.
//

import SnapKit
import UIKit

private enum MoveDirection {
    case right
    case left
}

private extension String {
    static let identifierForPlayerCarCollision = "Player Car Collision"
    static let identifierForBottomEdge = "bottom edge reached"
    
    static let startAgainButtonText = "Start Again"
    static let backToMenuAlertButtonText = "Back to Menu"
    static let alertTitleText = "You Lose"
    
    static let dateFormat = "dd.MM.yyyy"
    
    static let backButtonText = "Back"
    
    static let rightButtonText = ">"
    static let leftButtonText = "<"
    
    static func scoreToString(for score: Int) -> String {
        return "Your Score is: \(score)"
    }
}

protocol GameControllerDelegate: AnyObject {
    func transferDataForHandling(data: CustomTableViewCellModel)
}

class GameViewController: UIViewController {
    
    weak var delegate: InitialViewController?
    
    private var infoForTable: CustomTableViewCellModel?
    private var firstContactWithCollision: Bool = true
    private var timer: Timer? = nil
    private var score: Int = NumericConstants.zero
    
    private var settings: SettingsService?
    private var animatorForLeftLine: AnimationEngine!
    private var animatorForRightLine: AnimationEngine!
    
    init(settings: SettingsService? = nil) {
        self.settings = settings
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle(.backButtonText, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Radius.defaulrCornerRadius
        
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle(.rightButtonText, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Radius.defaulrCornerRadius
        return button
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle(.leftButtonText, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Radius.defaulrCornerRadius
        return button
    }()
    
    private let wrapper: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let leftRoadsideImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .leftRoadside
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .green
        
        return imageView
    }()
    
    private let leftTrafficLaneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .trafficline
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .red
        
        return imageView
    }()
    
    private let rightTrafficLaneImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = .trafficline
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .blue
        
        return imageView
    }()
    
    private let carView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let rightRoadsideImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .rightRoadside
        imageView.contentMode = .scaleToFill
        
        imageView.backgroundColor = .yellow
        
        return imageView
    }()
    
    private let scoreLabel: UILabel = {
       let label = UILabel()
         return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstContactWithCollision = true
//        settings = SettingsService().load()
        let difficulty = settings?.difficulty
        addViews()
        setupLabel()
        setupConstraintsToViews()
        addActionToButtons()
        setupAnimationEngines()
        timer = Timer.scheduledTimer(withTimeInterval: Double(difficulty!), repeats: true) { [weak self] _ in
            self?.createObstacle(animatorArray: [self?.animatorForLeftLine, self?.animatorForRightLine])
        }
    }
    
    private func setupLabel() {
        scoreLabel.text = .scoreToString(for: score)
        scoreLabel.textColor = .white
        
        scoreLabel.numberOfLines = NumericConstants.zero
        scoreLabel.tintColor = .black
        scoreLabel.layer.cornerRadius = Radius.defaulrCornerRadius
    }
    
    private func addViews() {
        view.addSubview(wrapper)
        
        view.addSubview(leftRoadsideImageView)
        view.addSubview(rightRoadsideImageView)
        wrapper.addSubview(leftTrafficLaneImageView)
        wrapper.addSubview(rightTrafficLaneImageView)
        
        view.addSubview(backButton)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(scoreLabel)
        
        rightTrafficLaneImageView.addSubview(carView)
    }
    
    private func setupConstraintsToViews() {
        wrapper.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview()
            make.left.equalTo(leftRoadsideImageView.snp.right)
            make.right.equalTo(rightRoadsideImageView.snp.left)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ConstantOffsets.offsetFifty)
            make.left.equalToSuperview().offset(ConstantOffsets.offsetTwentyFour)
            make.width.equalTo(ConstantSizes.sizeSeventyFive)
            make.height.equalTo(ConstantSizes.sizeFifty)
        }
        leftButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(ConstantOffsets.offsetFifty)
            make.left.equalToSuperview().offset(ConstantOffsets.offsetTwentyFour)
            make.height.width.equalTo(ConstantSizes.sizeFifty)
        }
        rightButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(ConstantOffsets.offsetFifty)
            make.right.equalToSuperview().inset(ConstantOffsets.offsetTwentyFour)
            make.height.width.equalTo(ConstantSizes.sizeFifty)
        }
        leftRoadsideImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(leftTrafficLaneImageView.snp.width).dividedBy(NumericConstants.two)
        }
        leftTrafficLaneImageView.snp.makeConstraints { make in
            make.directionalVerticalEdges.left.equalToSuperview()
            make.right.equalTo(rightTrafficLaneImageView.snp.left)
        }
        rightTrafficLaneImageView.snp.makeConstraints { make in
            make.directionalVerticalEdges.right.equalToSuperview()
            make.width.equalTo(leftTrafficLaneImageView.snp.width)
        }
        rightRoadsideImageView.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview()
            make.width.equalTo(leftRoadsideImageView.snp.width)
            make.right.equalToSuperview()
        }
        scoreLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ConstantOffsets.offsetFifty)
            make.right.equalToSuperview().inset(ConstantOffsets.offsetTwentyFour)
            make.centerY.equalTo(backButton.snp.centerY)
        }
        carViewSetupConstraints()
    }
    
    private func setupAnimationEngines() {
        animatorForLeftLine = AnimationEngine(referenceView: leftTrafficLaneImageView)
        animatorForRightLine = AnimationEngine(referenceView: rightTrafficLaneImageView)
        animatorForLeftLine.collisionBehavior.collisionDelegate = self
        animatorForRightLine.collisionBehavior.collisionDelegate = self

        animatorForLeftLine.collisionBehavior.addBoundary(withIdentifier: String.identifierForBottomEdge as NSCopying, from: CGPoint(x: 0, y: leftTrafficLaneImageView.frame.maxY + carView.frame.height), to: CGPoint(x: leftTrafficLaneImageView.frame.maxX, y: leftTrafficLaneImageView.frame.maxY + carView.frame.height))
        animatorForRightLine.collisionBehavior.addBoundary(withIdentifier: String.identifierForBottomEdge as NSCopying, from: CGPoint(x: 0, y: rightTrafficLaneImageView.frame.maxY + carView.frame.height), to: CGPoint(x: rightTrafficLaneImageView.frame.maxX, y: rightTrafficLaneImageView.frame.maxY + carView.frame.height))
        addCollisionBoundary(collision: animatorForRightLine.collisionBehavior)
        
    }
    
    private func addActionToButtons() {
        let moveLeftAction = UIAction { [weak self] _ in
            self?.moveCarView(direction: .left)
        }
        let moveRightAction = UIAction { [weak self] _ in
            self?.moveCarView(direction: .right)
        }
        let backAction = UIAction { [weak self] _ in
            self?.timer?.invalidate()
            self?.timer = nil
            self?.navigationController?.popToRootViewController(animated: true)
        }
        backButton.addAction(backAction, for: .touchUpInside)
        
        leftButton.addAction(moveLeftAction, for: .touchUpInside)
        rightButton.addAction(moveRightAction, for: .touchUpInside)
    }

    private func moveCarView(direction: MoveDirection) {
        let indexOfSuperview = wrapper.subviews.firstIndex(of: carView.superview!)
        
        switch direction {
        case .left:
            guard indexOfSuperview != wrapper.subviews.startIndex else {
                return
            }
            let prevIndex = wrapper.subviews.index(before: indexOfSuperview!)

            carView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(-ConstantOffsets.offsetTen)
                make.bottom.equalToSuperview().inset(ConstantOffsets.offsetHundred)
                make.height.equalTo(ConstantSizes.sizeSeventyFive)
            }
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            
            moveTo(direction: direction, index: prevIndex)
            
            return
        case .right:
            guard indexOfSuperview != wrapper.subviews.endIndex - 1 else {
                return
            }
            let nextIndex = wrapper.subviews.index(after: indexOfSuperview!)
            
            carView.snp.remakeConstraints { make in
                make.right.equalToSuperview().offset(ConstantOffsets.offsetTen)
                make.bottom.equalToSuperview().inset(ConstantOffsets.offsetHundred)
                make.height.equalTo(ConstantSizes.sizeSeventyFive)
            }
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            
            moveTo(direction: direction, index: nextIndex)
            
            return
        }
    }
    
    private func carViewSetupConstraints() {
        carView.image = .loadImageFromFileManager(by: settings!.carImageName)
        
        carView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(ConstantOffsets.offsetFifteen)
                    make.right.equalToSuperview().inset(ConstantOffsets.offsetFifteen)
                    make.bottom.equalToSuperview().inset(ConstantOffsets.offsetHundred)
            make.height.equalTo(ConstantSizes.sizeSeventyFive)
                }
        view.layoutIfNeeded()
    }
    
    private func createObstacle(animatorArray: [AnimationEngine?]) {
        let randomIndex = Int.random(in: animatorArray.startIndex...animatorArray.count - 1)
        let animator = animatorArray[randomIndex]
        let obstacleView = UIImageView()
        
        obstacleView.image = .loadImageFromFileManager(by: settings!.obstacleImageName)
                
        animator?.addSubviewToReferenceView(obstacleView)
        
        obstacleView.snp.makeConstraints { [weak self] make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo((self?.view.snp.top)!)
            make.size.equalTo((self?.carView.snp.size)!)
        }
        view.layoutIfNeeded()
        
        animator?.addItem(obstacleView)
    }
    
    // MARK: strings
    private func callAlertAfterLose() {
        let alert = UIAlertController(title: .alertTitleText, message: .scoreToString(for: score), preferredStyle: .alert)
        
        let formatter = DateFormatter()
        formatter.dateFormat = .dateFormat
        let formattedDate = formatter.string(from: Date())
        
        let data = CustomTableViewCellModel(userName: settings!.name, userImageName: settings!.userImageName, score: score, date: formattedDate)
        delegate?.transferDataForHandling(data: data)
        
        let dismissAlertAction = UIAlertAction(title: .backToMenuAlertButtonText, style: .destructive) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        let repeatAlertAction = UIAlertAction(title: .startAgainButtonText, style: .default) { [weak self] _ in
            self?.viewDidLoad()
            self?.viewWillAppear(true)
        }
        
        alert.addAction(dismissAlertAction)
        alert.addAction(repeatAlertAction)
        
        
        // check invocation after dismiss VC
        present(alert, animated: true)
    }
    
    private func moveTo(direction: MoveDirection, index: Int) {
        carView.removeFromSuperview()
        
        wrapper.subviews[index].addSubview(carView)
        carViewSetupConstraints()
        
        switch direction {
        case .left:
            removeBoundary(collision: animatorForRightLine.collisionBehavior)
            addCollisionBoundary(collision: animatorForLeftLine.collisionBehavior)
        case.right:
            removeBoundary(collision: animatorForLeftLine.collisionBehavior)
            addCollisionBoundary(collision: animatorForRightLine.collisionBehavior)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        print("Game VC deinitialized")
    }
}

extension GameViewController: UICollisionBehaviorDelegate {
    
    private func addCollisionBoundary(collision: UICollisionBehavior) {
        collision.addBoundary(withIdentifier: String.identifierForPlayerCarCollision as NSCopying, for: UIBezierPath(rect: carView.frame))
    }
    private func removeBoundary(collision: UICollisionBehavior) {
        collision.removeBoundary(withIdentifier: String.identifierForPlayerCarCollision as NSCopying)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
        let boundary = identifier as! String

        let view = item as! UIView
        if boundary == .identifierForBottomEdge {
            score += NumericConstants.one
            scoreLabel.text = .scoreToString(for: score)
            if (animatorForLeftLine.items.contains { $0 as! UIView == view }) {
                animatorForLeftLine.removeItem(item)
                view.removeFromSuperview()
            } else if (animatorForRightLine.items.contains { $0 as! UIView ==  item as! UIView }) {
                animatorForRightLine.removeItem(item)
                view.removeFromSuperview()
            }
        }
        
        if boundary == .identifierForPlayerCarCollision {
            if firstContactWithCollision {
                firstContactWithCollision.toggle()
                timer?.invalidate()
                timer = nil
                callAlertAfterLose()
            }
            view.subviews.forEach { $0.removeFromSuperview()}
            animatorForLeftLine.removeAllBehaviors()
            animatorForRightLine.removeAllBehaviors()
        }
    }
    
}
