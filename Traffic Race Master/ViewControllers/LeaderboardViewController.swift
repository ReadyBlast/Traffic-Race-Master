//
//  ViewController.swift
//  Traffic Race Master
//
//  Created by XE on 20.03.2024.
//

import UIKit

protocol ILeaderboardViewController {
    func configureCellsDataArray(_ array: [CustomTableViewCellModel])
}

class LeaderboardViewController: UIViewController {

    private var dataForCellsArray: [CustomTableViewCellModel]?
    
    
    private var backButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle(.backButtonTitle, for: .normal)
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: .mainBgColorName)
        setupBackButton()
        initialize()
    }
    
    private func initialize() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(ConstantOffsets.offsetTwelwe)
            make.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ConstantOffsets.offsetFifty)
            make.left.equalToSuperview().offset(ConstantOffsets.offsetTwentyFour)
        }
        
        let dismissAction = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        backButton.addAction(dismissAction, for: .touchUpInside)
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
        print("Leaderboard deinit")
    }
}

extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForCellsArray!.count < NumericConstants.maximumOfRowsInTable ? dataForCellsArray!.count : NumericConstants.maximumOfRowsInTable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell,
              let cellsArray = dataForCellsArray else { return UITableViewCell() }
        
        cell.configureCell(with: cellsArray[indexPath.row])
        return cell
    }
}

extension LeaderboardViewController: ILeaderboardViewController {
    func configureCellsDataArray(_ array: [CustomTableViewCellModel]) {
        dataForCellsArray = array
        
        tableView.reloadData()
    }
}
