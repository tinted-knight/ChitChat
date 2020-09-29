//
//  fake_data.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

private func hasUnread() -> Bool {
    return Bool.random()
}

let fakeChatList = [[ // MARK: -Online
    ConversationCellModel(
        name: "Ostap Bender",
        message: "Make New Vasiuky great again. An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.",
        date: fakeDate(),
        isOnline: true,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Анацкий Стас",
        message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis",
        date: fakeDate(),
        isOnline: true,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Курганова Саша",
        message: "",
        date: fakeDate(),
        isOnline: true,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Дмитрий Попов",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: true,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Алексей Кудряшов",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: true,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Александр Пересыпкин",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: true,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Aleksey Nikitin",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: true,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Nikita Gundorin",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: true,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Татьяна Тепаева",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: true,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Илья Дударенко",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: true,
        hasUnreadMessages: hasUnread()
    ),
], [ // MARK: -History
    ConversationCellModel(
        name: "Artem Rozanov",
        message: "",
        date: fakeDate(),
        isOnline: false,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Victoria Bunyaeva",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: false,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Maxim Matuzko",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: false,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Anna Vondrukhova",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: false,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Александр Саушев",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: false,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Anastasia Leonteva",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: false,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Maria Myamlina",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: false,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Влад Куликов",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: false,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Rudolf Oganesyan",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: false,
        hasUnreadMessages: hasUnread()
    ),
    ConversationCellModel(
        name: "Марат Джаныбаев",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: fakeDate(),
        isOnline: false,
        hasUnreadMessages: hasUnread()
    ),
    ]
]
