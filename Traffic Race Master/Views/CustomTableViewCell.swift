//
//  CustomTableViewCell.swift
//  Traffic Race Master
//
//  Created by XE on 20.03.2024.
//

import Foundation
import UIKit

final class CustomTableViewCell: UITableViewCell {
    
    static var identifier: String {"\(Self.self)"}
    
    private var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var userNameLabel: UILabel = {
       let label = UILabel()
        
        label.textAlignment = .center
        label.numberOfLines = NumericConstants.zero
        label.textColor = .black
        
        return label
    }()
    
    private var scoreLabel: UILabel = {
       let label = UILabel()
        
        label.textAlignment = .right
        label.numberOfLines = NumericConstants.zero
        label.textColor = .black
        
        return label
    }()
    
    private var dateLabel: UILabel = {
       let label = UILabel()

        label.numberOfLines = NumericConstants.zero
        label.textColor = .black
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = nil
        userImageView.image = nil
        scoreLabel.text = nil
        dateLabel.text = nil
    }
    
    private func addViews() {
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(dateLabel)
        
        userImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(ConstantSizes.sizeSeventyFive)
            make.centerY.equalToSuperview()
        }
        userNameLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(ConstantOffsets.offsetTwelwe)
            make.left.equalTo(userImageView.snp.right).offset(ConstantOffsets.offsetTwelwe)
        }
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(ConstantOffsets.offsetTwentyFour)
            make.right.bottom.equalToSuperview().inset(ConstantOffsets.offsetTwelwe)
            make.width.equalTo(dateLabel.snp.width)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(ConstantOffsets.offsetTwentyFour)
            make.bottom.equalToSuperview().inset(ConstantOffsets.offsetTwelwe)
            make.left.equalTo(userImageView.snp.right).offset(ConstantOffsets.offsetTwelwe)
        }
    }
    
    func configureCell(with item: CustomTableViewCellModel) {
        userNameLabel.text = item.userName
        userImageView.image = .loadImageFromFileManager(by: item.userImageName)
        scoreLabel.text = "\(item.score)"
        dateLabel.text = "\(item.date)"
    }
}
