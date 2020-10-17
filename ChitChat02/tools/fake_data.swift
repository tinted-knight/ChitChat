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
// MARK: Online
let fakeChatList = [[
    // today, has unread
    ConversationCellModel(
        name: "Ostap Bender",
        message: "Make New Vasiuky great again. An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.",
        date: Date(timeIntervalSinceNow: -60 * 60),
        isOnline: true,
        hasUnreadMessages: true
    ),
    // today, no unread
    ConversationCellModel(
        name: "Анацкий Стас",
        message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis",
        date: Date(timeIntervalSinceNow: -60 * 60),
        isOnline: true,
        hasUnreadMessages: false
    ),
    // yesterday, has unread
    ConversationCellModel(
        name: "Курганова Саша",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: Date(timeIntervalSinceNow: -60 * 60 * 36),
        isOnline: true,
        hasUnreadMessages: true
    ),
    // yesterday, no unread
    ConversationCellModel(
        name: "Дмитрий Попов",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: Date(timeIntervalSinceNow: -60 * 60 * 36),
        isOnline: true,
        hasUnreadMessages: false
    ),
    // no last message
    ConversationCellModel(
        name: "Алексей Кудряшов",
        message: "",
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
    )
], [ // MARK: History
    // today, has unread
    ConversationCellModel(
        name: "Artem Rozanov",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: Date(timeIntervalSinceNow: -60 * 60),
        isOnline: false,
        hasUnreadMessages: true
    ),
    // today, no unread
    ConversationCellModel(
        name: "Victoria Bunyaeva",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: Date(timeIntervalSinceNow: -60 * 60),
        isOnline: false,
        hasUnreadMessages: false
    ),
    // yesterday, has unread
    ConversationCellModel(
        name: "Maxim Matuzko",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: Date(timeIntervalSinceNow: -60 * 60 * 36),
        isOnline: false,
        hasUnreadMessages: true
    ),
    // yesterday, no unread
    ConversationCellModel(
        name: "Anna Vondrukhova",
        message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
        date: Date(timeIntervalSinceNow: -60 * 60 * 36),
        isOnline: false,
        hasUnreadMessages: false
    ),
    // no last message - show not be visible
    ConversationCellModel(
        name: "Александр Саушев",
        message: "",
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
    )
    ]
]
