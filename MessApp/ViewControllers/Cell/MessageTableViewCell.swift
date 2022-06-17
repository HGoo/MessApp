//
//  MessageTableViewCell.swift
//  MessApp
//
//  Created by Николай Петров on 16.06.2022.
//

import UIKit

//enum BubleType {
//    case incoming
//    case outgoing
//}

class MessageTableViewCell: UITableViewCell {
    
    private let messageLabel: EdgeInsetLabel = {
        let label = EdgeInsetLabel()
        label.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        label.font = UIFont.systemFont(ofSize: 20)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        
        //lable.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var messageStackView = UIStackView()

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        messageLabel.layer.cornerRadius = 10
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        
        self.backgroundColor = .white
        //self.selectionStyle = .none
        messageStackView = UIStackView(arrangedSubviews: [messageLabel],
                                       axis: .vertical,
                                       spacing: 0,
                                       distribution: .fill)
        
        self.addSubview(messageStackView)
        
        
        
        //messageStackView.addSubview(messageLabel)
       // self.addSubview(messageLabel)
        
        
        
    }
    
    public func configureMessageCell(with message: [[ String: String]],_ receiver: String) {

        let currentUser = UserDefaults().getUserLogin()
        if message[0][DBNames.source.rawValue] == currentUser {
       
            messageLabel.text = message[1][DBNames.message.rawValue]
            
            senderMessage()
            
        } else {
            messageLabel.text = message[1][DBNames.message.rawValue]
            receiverMessage()
        }
    }
    
    private func senderMessage() {
        messageLabel.backgroundColor = #colorLiteral(red: 0.6186313033, green: 0.6129645705, blue: 0.915372014, alpha: 1)
        messageLabel.textAlignment = .right
        messageStackView.alignment = .trailing
        //setConstraints2()
    }
    
    private func receiverMessage() {
        messageLabel.backgroundColor = #colorLiteral(red: 0.6803349853, green: 0.8783015609, blue: 0.8982681036, alpha: 1)
        messageStackView.alignment = .leading

        //setConstraints1()
    }
    
    private func setConstraints() {
                
        NSLayoutConstraint.activate([
            messageStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            messageStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            messageStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            messageStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width / 1.7),
           // messageLabel.topAnchor.constraint(equalTo: messageStackView.topAnchor, constant: 5),
            //messageLabel.bottomAnchor.constraint(equalTo: messageStackView.bottomAnchor, constant: -5),
//            messageLabel.leadingAnchor.constraint(equalTo: messageStackView.leadingAnchor, constant: 0),
//            messageLabel.trailingAnchor.constraint(equalTo: messageStackView.trailingAnchor, constant: 0)
        ])
    }
    
    private func setConstraints1() {
        
     
        messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        
        messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = false
        
        
    }
    
    private func setConstraints2() {
        messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = false
        messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
}


