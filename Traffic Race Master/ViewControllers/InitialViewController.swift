//
//  InitialViewController.swift
//  Traffic Race Master
//
//  Created by XE on 17.02.2024.
//

import SnapKit
import UIKit

protocol IInitialViewController {
    
}

final class InitialViewController: UIViewController {
    
    private var leaderboardViewController: LeaderboardViewController
    private var gameViewController: GameViewController
    private var dataForTableViewArray: [CustomTableViewCellModel]
    
    init(leaderboardViewController: LeaderboardViewController, gameViewController: GameViewController, dataForTableViewArray: [CustomTableViewCellModel] = [CustomTableViewCellModel]()) {
        self.leaderboardViewController = leaderboardViewController
        self.gameViewController = gameViewController
        self.dataForTableViewArray = dataForTableViewArray
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Spacing.defaultSpacing
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
        
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "WhityGray")
        initialize()
    }
    
    private func initialize() {
        
        gameViewController.delegate = self
        
        let gameStartButton = addButton(title: "Start")
        let settingButton = addButton(title: "Settings")
        let leaderboardButton = addButton(title: "Leaderboard")
        
        // MARK: - Retain Cycle
        /*
         В экшне, который присваивается переменной startGameAction, если передать как свойство метода pushViewController объект класса GameViewController(), ранее инициализированный в этом классе(InitialViewController), а затем перейти на GameViewController - при возвращении обратно на родительский контроллер GameViewController не деинициализируется и продолжает работать в фоне.
         Если же передать методу pushViewController просто GameViewController(), перейти на него и вернуться, то деинит произойдет, но из-за отсутствия привязки нельзя будет назначить делегата.
         Основная странность в понимании для меня заключается в том, что даже если GameViewController будет абсолютно пустым - при создании ссылки на него у InitialViewController, GameViewController не будет деинициализироваться
         Скрины с логами в консоли приложу
         */
        let startGameAction = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(self!.gameViewController, animated: true)
        }
        let settingsAction = UIAction { [ weak self ]_ in
            self?.navigationController?.pushViewController(SettingsViewController(), animated: true)
        }
        let leaderboardAction: UIAction = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(self!.leaderboardViewController, animated: true)
            self?.transferDataToAnotherViewController(self!.leaderboardViewController)
        }
        gameStartButton.addAction(startGameAction, for: .touchUpInside)
        settingButton.addAction(settingsAction, for: .touchUpInside)
        leaderboardButton.addAction(leaderboardAction, for: .touchUpInside)
    }
    
    
    private func transferDataToAnotherViewController(_ vc: ILeaderboardViewController) {
        vc.configureCellsDataArray(dataForTableViewArray)
    }
    
    private func addButton(title: String) -> UIButton{
        let button = UIButton()
        
        button.backgroundColor = .black
        button.setTitle(title, for: .normal)
        
        button.layer.cornerRadius = Radius.defaulrCornerRadius
        
        button.snp.makeConstraints { make in
            make.width.equalTo(ConstantSizes.defaultButtonWidth)
            make.height.equalTo(ConstantSizes.defaultButtonHeight)
        }

        stackView.addArrangedSubview(button)
        
        return button
    }
}

extension InitialViewController: GameControllerDelegate {
    func transferDataForHandling(data: CustomTableViewCellModel) {
        dataForTableViewArray.append(data)
        dataForTableViewArray.sort { $0.score > $1.score }
        PersistenceManager().save(from: dataForTableViewArray)
    }
}
