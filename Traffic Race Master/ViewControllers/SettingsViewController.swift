//
//  SettingsViewController.swift
//  Traffic Race Master
//
//  Created by XE on 19.02.2024.
//

import Kingfisher
import SnapKit
import UIKit

private extension UIButton {
    func createImageButton(image: UIImage) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.setTitle(.emptyString, for: .normal)
        button.layer.cornerRadius = Radius.defaulrCornerRadius
        button.isUserInteractionEnabled = true
        
        button.snp.makeConstraints { make in
            make.size.equalTo(ConstantSizes.sizeHundred)
        }
        
        return button
    }
}

private extension String {
    static let setCarLabel: String = "Choose Your Car"
    
    static let setObstacleLabel = "Choose Obstacle"
    
    static let setDifficultyLabelText = "Choose your difficulty"
}

private struct DifficultyPicker {
    let easy: String = "Easy"
    let normal: String = "Normal"
    let hard: String = "Hard"
}

class SettingsViewController: UIViewController {
    
    private var userSettings: SettingsService?
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle(.backButtonTitle, for: .normal)
        
        return button
    }()
    
    private let userImageButton: UIButton = {
        
        let button = UIButton()
        button.setImage(.pug, for: .normal)
        button.layer.cornerRadius = 12
        button.setTitleColor(.black, for: .normal)
        button.setTitle(.emptyString, for: .normal)
        
        return button
    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        
        return label
    }()
    
    private var userChangeNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let selectCarLabel: UILabel = {
        let label = UILabel()
        label.text = .setCarLabel
        label.textColor = .black
        
         return label
     }()
    
    private let selectObstacleLabel: UILabel = {
        let label = UILabel()
        label.text = .setObstacleLabel
        label.textColor = .black
        
         return label
     }()
    
    private let leftCarButton: UIButton = {
        let button = UIButton().createImageButton(image: .car)
        
        return button
    }()
    
    private let middleCarButton: UIButton = {
        let button = UIButton().createImageButton(image: .blackViper)
        
        return button
    }()
    
    private let rightCarButton: UIButton = {
        let button = UIButton().createImageButton(image: .audi)
        
        return button
    }()
    
    private let leftObstacleButton: UIButton = {
        let button = UIButton().createImageButton(image: .miniTruck)
        return button
    }()
    
    private let middleObstacleButton: UIButton = {
        let button = UIButton().createImageButton(image: .miniVan)
        return button
    }()
    
    private let rightObstacleButton: UIButton = {
        let button = UIButton().createImageButton(image: .taxi)
        return button
    }()
    
    private let difficultyChangeLabel: UILabel = {
        let label = UILabel()
        label.text = .setDifficultyLabelText
        
        return label
    }()
    
    private let easyButton: UIButton = {
        let button = UIButton()
        button.setTitle(DifficultyPicker().easy, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Radius.defaulrCornerRadius
        
        button.snp.makeConstraints { make in
            make.size.equalTo(ConstantSizes.sizeHundred)
        }
        return button
    }()
    
    private let normalButton: UIButton = {
        let button = UIButton()
        button.setTitle(DifficultyPicker().normal, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Radius.defaulrCornerRadius
        
        button.snp.makeConstraints { make in
            make.size.equalTo(ConstantSizes.sizeHundred)
        }
        return button

    }()
    
    private let hardButton: UIButton = {
        let button = UIButton()
        button.setTitle(DifficultyPicker().hard, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = Radius.defaulrCornerRadius
        
        button.snp.makeConstraints { make in
            make.size.equalTo(ConstantSizes.sizeHundred)
        }
        return button

    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: .mainBgColorName)
        userChangeNameTextField.delegate = self
        
        initialize()
    }
    
    private func initialize() {
        initValues()

        view.addSubview(userImageButton)
        view.addSubview(userNameLabel)
        view.addSubview(userChangeNameTextField)
        
        setupBackButton()
        
        userImageButton.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(ConstantOffsets.offsetTwentyFour)
            make.left.equalToSuperview().offset(ConstantOffsets.offsetTwentyFour)
            make.size.equalTo(ConstantSizes.sizeHundredAndFifty)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userImageButton.snp.centerY)
            make.right.equalToSuperview().inset(ConstantOffsets.offsetTwentyFour)
        }
        
        userChangeNameTextField.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(ConstantOffsets.offsetTwentyFour)
            make.left.equalTo(userImageButton.snp.right).offset(ConstantOffsets.offsetTwentyFour)
            make.right.equalToSuperview().inset(ConstantOffsets.offsetTwentyFour)
        }
        
        addViewWithWrapper(items: [leftCarButton, middleCarButton, rightCarButton], label: selectCarLabel, previousView: userImageButton)
        addViewWithWrapper(items: [leftObstacleButton, middleObstacleButton, rightObstacleButton], label: selectObstacleLabel, previousView: leftCarButton)
        addViewWithWrapper(items: [easyButton, normalButton, hardButton], label: difficultyChangeLabel, previousView: leftObstacleButton)
        
        addActions()
    }
    
    private func initValues() {
        
        userSettings = SettingsService().load()
        userNameLabel.text = userSettings?.name
    }
    
    
    
    private func addViewWithWrapper(items: [UIButton], label: UILabel, previousView: UIView) {
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(ConstantOffsets.offsetTwentyFour)
            make.centerX.equalToSuperview()
        }
        
        let wrapper = UIView()

        view.addSubview(wrapper)
        
        wrapper.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(ConstantOffsets.offsetTwentyFour)
            make.left.equalToSuperview().offset(ConstantOffsets.offsetTwentyFour)
            make.right.equalToSuperview().inset(ConstantOffsets.offsetTwentyFour)
        }
        
        
        for (index, item) in items.enumerated() {
            wrapper.addSubview(item)
            
            switch index{
            case 0:
                item.snp.makeConstraints { make in
                    make.top.left.height.equalToSuperview()
                }
            case 1:
                item.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.centerX.equalToSuperview()
                }
            case 2:
                item.snp.makeConstraints { make in
                    make.top.right.equalToSuperview()
                }
            default:
                return
            }
        }
        
    }

    private func setupBackButton() {
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ConstantOffsets.offsetFifty)
            make.left.equalToSuperview().offset(ConstantOffsets.offsetTwentyFour)
        }
        
        let dismissAction = UIAction { [weak self] _ in
    
            self?.userSettings?.save(from: (self?.userSettings)!)
            self?.navigationController?.popViewController(animated: true)
        }
        backButton.addAction(dismissAction, for: .touchUpInside)
    }
    
    
    private func addActions() {
        let userImageButtonAction = UIAction { [weak self] _ in
            self!.userSettings?.userImageName = try! .saveImageToFileManager(self!.userImageButton.currentImage)!
        }
        userImageButton.addAction(userImageButtonAction, for: .touchUpInside)
        
        let leftCarButtonAction = UIAction { [weak self] _ in
            self!.userSettings?.carImageName = try! .saveImageToFileManager(self!.leftCarButton.currentImage)!
        }
        leftCarButton.addAction(leftCarButtonAction, for: .touchUpInside)

        let middleCarButtonAction = UIAction { [weak self] _ in
            self!.userSettings?.carImageName = try! .saveImageToFileManager(self!.middleCarButton.currentImage)!
        }
        middleCarButton.addAction(middleCarButtonAction, for: .touchUpInside)

        let rightCarButtonAction = UIAction { [weak self] _ in
            self!.userSettings?.carImageName = try! .saveImageToFileManager(self!.rightCarButton.currentImage)!
        }
        rightCarButton.addAction(rightCarButtonAction, for: .touchUpInside)

        let leftObstacleButtonAction = UIAction { [weak self] _ in
            self!.userSettings?.obstacleImageName = try! .saveImageToFileManager(self!.leftObstacleButton.currentImage)!
        }
        leftObstacleButton.addAction(leftObstacleButtonAction, for: .touchUpInside)

        let middleObstacleButtonAction = UIAction { [weak self] _ in
            self!.userSettings?.obstacleImageName = try! .saveImageToFileManager(self!.middleObstacleButton.currentImage)!
        }
        middleObstacleButton.addAction(middleObstacleButtonAction, for: .touchUpInside)

        let rightObstacleButtonAction = UIAction { [weak self] _ in
            self!.userSettings?.obstacleImageName = try! .saveImageToFileManager(self!.rightObstacleButton.currentImage)!
        }
        rightObstacleButton.addAction(rightObstacleButtonAction, for: .touchUpInside)

        let easyButtonAction = UIAction {[weak self] _ in
            self?.userSettings?.difficulty = Difficulty.easy.rawValue

        }
        easyButton.addAction(easyButtonAction, for: .touchUpInside)

        let normalButtonAction = UIAction { [weak self] _ in
            self?.userSettings?.difficulty = Difficulty.normal.rawValue
        }
        normalButton.addAction(normalButtonAction, for: .touchUpInside)

        let hardButtonAction = UIAction { [weak self] _ in
            self?.userSettings?.difficulty = Difficulty.hard.rawValue
        }
        hardButton.addAction(hardButtonAction, for: .touchUpInside)
    }
        /*
         // MARK: - Navigation
         
         // In a storyxboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
    deinit {
        print("Setting VC Deinit")
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameLabel.text = userChangeNameTextField.text
        userSettings?.name = userChangeNameTextField.text!
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
