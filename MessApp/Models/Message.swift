//
//  Message.swift
//  MessApp
//
//  Created by Николай Петров on 08.06.2022.
//

import Foundation

struct Message {
    let sender: SenderTupe
    let messageId: String
    let message: String
}

struct SenderTupe {
    let inMessage: Bool
}
