//
//  MessageTableViewCell.swift
//  MessApp
//
//  Created by Николай Петров on 14.06.2022.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    private let messageLabel: EdgeInsetLabel = {
        let label = EdgeInsetLabel()
        label.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        label.font = UIFont.systemFont(ofSize: 20)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var messageStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        messageStackView = UIStackView(arrangedSubviews: [messageLabel],
                                       axis: .vertical,
                                       spacing: 0,
                                       distribution: .fill)
        addSubview(messageStackView)
    }
    
    private func outgoingMessage() {
        messageLabel.backgroundColor = #colorLiteral(red: 0.6648370624, green: 0.7158717513, blue: 1, alpha: 1)
        messageLabel.textAlignment = .right
        messageStackView.alignment = .trailing
    }
    
    private func incomingMessage() {
        messageLabel.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        messageStackView.alignment = .leading
    }
    
    public func configureMessageCell(with message: [[ String: String]]) {
        let currentUser = UserDefaults().getUserLogin()
        let text = DBMessageField.text.rawValue
        if message[DBMessageField.from.rawValue][DBNames.source.rawValue] == currentUser {
            messageLabel.text = message[text][DBNames.message.rawValue]
            outgoingMessage()
        } else {
            messageLabel.text = message[text][DBNames.message.rawValue]
            incomingMessage()
        }
    }
}

//MARK: - Set Constarins

extension MessageTableViewCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            messageStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            messageStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            messageStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            messageStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width / 1.7),
        ])
    }
}
