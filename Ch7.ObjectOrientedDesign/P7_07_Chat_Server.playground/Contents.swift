import Foundation

func ==(lhs: User, rhs: User) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

class Message {
    private var content: String
    private var date: Date
    
    init(content: String, date: Date) {
        self.content = content
        self.date = date
    }
    
    func getContent() -> String {
        return content
    }
    
    func getDate() -> Date {
        return date
    }
    
}


class User: Equatable {
    private var id: Int
    private var status: UserStatus?
    private var privateChats = [Int: PrivateChat]()
    // private var groupChats = [Int: GroupChat]()
    // Could do groupChats as a dictionary too (from above) by using groupID as the key and the chat as the value.
    private var groupChats = [GroupChat]()
    private var receivedAddRequests = [Int: AddRequest]()
    private var sentAddRequests = [Int: AddRequest]()
    private var contacts = [Int: User]()
    private var accountName: String
    private var fullName: String
    
    init(id: Int, accountName: String, fullName: String) {
        self.id = id
        self.accountName = accountName
        self.fullName = fullName
    }
    
    func sendMessageToUser(toUser: User, content: String) -> Bool  {
        var chat = privateChats[toUser.getID()]
        if chat == nil {
            chat = PrivateChat(user1: self, user2: toUser)
            privateChats[toUser.getID()] = chat
        }
        let message = Message(content: content, date: Date())
        return chat!.addMessage(m: message)
    }
    
    func sendMessageToGroupChat(groupID: Int, content: String) -> Bool {
        guard groupID < groupChats.count && groupID >= 0 else { return false }
        let chat = groupChats[groupID]
        let message = Message(content: content, date: Date())
        return chat.addMessage(m: message)
    }
    
    func setStatus(status: UserStatus) {
        self.status = status
    }
    
    func getStatus() -> UserStatus? {
        return status
    }
    
    func addContact(user: User) -> Bool {
        if contacts[user.getID()] == nil {
            contacts[user.getID()] = user
            return true
        } else {
            return false
        }
    }
    
    func receivedAddRequest(req: AddRequest) {
        let senderID = req.getFromUser().getID()
        if receivedAddRequests[senderID] == nil {
            receivedAddRequests[senderID] = req
        }
    }
    
    func sentAddRequest(req: AddRequest) {
        let receiverID = req.getFromUser().getID()
        if sentAddRequests[receiverID] == nil {
            sentAddRequests[receiverID] = req
        }
    }
    
    func removeAddRequest(req: AddRequest) {
        if req.getToUser() == self {
            receivedAddRequests.removeValue(forKey: req.getToUser().getID())
        } else if req.getFromUser() == self {
            sentAddRequests.removeValue(forKey: req.getFromUser().getID())
        }
    }
    
    func requestAddUser(accountName: String) {
        UserManager.sharedInstance.addUser(fromUser: self, toAccountName: accountName)
    }
    
    func addConversation(conversation: PrivateChat) {
        if let otherUser = conversation.getOtherParticipants(primary: self) {
            privateChats[otherUser.getID()] = conversation
        }
    }
    
    func addConversation(conversation: GroupChat) {
        groupChats.append(conversation)
    }
    
    func getID() -> Int {
        return id
    }
    
    func getAccountName() -> String {
        return accountName
    }
    
    func getFullName() -> String {
        return fullName
    }
    
    func printContacts() {
        var rval = "\(self.getFullName())'s contacts are: ["
        for (_,v) in contacts {
            rval += v.fullName + ", "
        }
        print(rval + "]")
    }
    
    func printAddRequests() {
        var rval = "The user \(self.fullName) has sent out add requests to: ["
        for (_,v) in sentAddRequests {
            rval += "\(v.getToUser().fullName), "
        }
        print(rval + "]")
    }
    
    func printReceiveRequests() {
        var rval = "The user \(self.fullName) has requests from : ["
        for (_,v) in receivedAddRequests {
            rval += "\(v.getToUser().fullName), "
        }
        print(rval + "]")
    }
}

enum UserStatusType {
    case offline, away, idle, available, busy
}

class UserStatus {
    private var message: String
    private var statusType: UserStatusType
    init(message: String, statusType: UserStatusType) {
        self.message = message
        self.statusType = statusType
    }
    
    func getStatusType() -> UserStatusType {
        return statusType
    }
    
    func getMessage() -> String {
        return message
    }
}

class UserManager {
    static let sharedInstance = UserManager()
    private var usersByID = [Int: User]()
    private var usersByAccountName = [String: User]()
    private var onlineUsers = [Int: User]()
    
    
    func addUser(fromUser: User, toAccountName: String) {
        if let toUser = usersByAccountName[toAccountName] {
            let req = AddRequest(fromUser: fromUser, toUser: toUser, date: Date())
            toUser.receivedAddRequest(req: req)
            fromUser.sentAddRequest(req: req)
        }
    }
    
    func approveAddRequest(req: AddRequest) {
        req.requestStatus = .Accepted
        let from = req.getFromUser()
        let to = req.getToUser()
        from.addContact(user: to)
        to.addContact(user: from)
    }
    
    func rejectAddRequest(req: AddRequest) {
        req.requestStatus = .Rejected
        let from = req.getFromUser()
        let to = req.getToUser()
        from.removeAddRequest(req: req)
        to.removeAddRequest(req: req)
    }
    
    func userSignedOn(accountName: String) {
        if let user = usersByAccountName[accountName] {
            user.setStatus(status: UserStatus(message: "", statusType: .available))
            onlineUsers[user.getID()] = user
        }
    }
    
    func userSignedOff(accountName: String) {
        if let user = usersByAccountName[accountName] {
            user.setStatus(status: UserStatus(message: "", statusType: .offline))
            onlineUsers.removeValue(forKey: user.getID())
        }
    }
    
    func addUsersToDatabase(users: [User]) {
        for user in users {
            let accountName = user.getAccountName()
            usersByAccountName[accountName] = user
        }
    }
}

enum RequestStatus {
    case UnRead, Read, Accepted, Rejected
}

class AddRequest {
    private var fromUser: User
    private var toUser: User
    private var date: Date
    internal var requestStatus: RequestStatus
    
    init(fromUser: User, toUser: User, date: Date) {
        self.fromUser = fromUser
        self.toUser = toUser
        self.date = date
        requestStatus = .UnRead
    }
    
    func getStatus() -> RequestStatus {
        return requestStatus
    }
    
    func getFromUser() -> User {
        return fromUser
    }
    
    func getToUser() -> User {
        return toUser
    }
    
    func getDate() -> Date {
        return date
    }
}

class Conversation {
    internal var participants = [User]()
    private var id: Int
    private var messages = [Message]()
    
    init(id: Int) {
        self.id = id
    }
    
    func getMessages() -> [Message] {
        return messages
    }
    
    func addMessage(m: Message) -> Bool {
        messages.append(m)
        return true
    }
    
    func getID() -> Int {
        return id
    }
    
    func printParticipants() {
        var rval = "The people in this conversation are: ["
        for p in participants {
            rval += p.getFullName() + ", "
        }
        print(rval + "]")
    }
}

class PrivateChat: Conversation {
    init(user1: User, user2: User) {
        super.init(id: 0)
        participants.append(user1)
        participants.append(user2)
    }
    
    func getOtherParticipants(primary: User) -> User? {
        if participants[0] == primary {
            return participants[1]
        } else if participants[1] == primary {
            return participants[0]
        } else {
            return nil
        }
    }
    
}

class GroupChat: Conversation {
    func removeParticipant(user: User) {
        if let index = participants.index(of: user) {
            participants.remove(at: index)
        }
    }
    
    func addParticipant(user: User) {
        participants.append(user)
    }
}

class Test {
    
    func startTest() {
        let user1 = User(id: 1, accountName: "Anhtastic", fullName: "Anh Doan")
        let user2 = User(id: 2, accountName: "Cathastic", fullName: "Cathy Doan")
        let user3 = User(id: 3, accountName: "Dantastic", fullName: "Dan Doan")
        let user4 = User(id: 4, accountName: "Edtastic", fullName: "Ed Doan")
        let user5 = User(id: 5, accountName: "Fatastic", fullName: "Fat Doan")
        let user6 = User(id: 6, accountName: "Mantastic", fullName: "Man Doan")
        UserManager.sharedInstance.addUsersToDatabase(users: [user1, user2, user3, user4, user5, user6])
        
        user1.addContact(user: user2)
        user1.addContact(user: user3)
        user4.addContact(user: user5)
        user5.addContact(user: user6)
        user1.printContacts()
        user2.printContacts()
        user3.printContacts()
        user4.printContacts()
        user5.printContacts()
        user6.printContacts()
        print("")
        
        user1.requestAddUser(accountName: "Cathastic")
        user3.requestAddUser(accountName: "Cathastic")
        user2.requestAddUser(accountName: "Mantastic")
        user1.printAddRequests()
        user1.printReceiveRequests()
        user2.printAddRequests()
        user2.printReceiveRequests()
        user3.printAddRequests()
        user3.printReceiveRequests()
        print("")
        
        let privateChat = PrivateChat(user1: user1, user2: user2)
        user1.addConversation(conversation: privateChat)
        user1.sendMessageToUser(toUser: user2, content: "Hello Cathy, I'm Anh")
        privateChat.printParticipants()
        let privateMessages = privateChat.getMessages()
        for message in privateMessages {
            print("The date of this message is: \(message.getDate()) and the message is \(message.getContent())")
        }
        print("")
        
        let privateChat2 = PrivateChat(user1: user2, user2: user3)
        user2.addConversation(conversation: privateChat2)
        user2.sendMessageToUser(toUser: user3, content: "Hello Dan, I'm Cathy")
        privateChat2.printParticipants()
        let privateMessages2 = privateChat2.getMessages()
        for message in privateMessages2 {
            print("The date of this message is: \(message.getDate()) and the message is \(message.getContent())")
        }
        print("")
        
        let groupConversation = GroupChat(id: 0)
        groupConversation.addParticipant(user: user4)
        groupConversation.addParticipant(user: user5)
        groupConversation.addParticipant(user: user6)
        user3.addConversation(conversation: groupConversation)
        user3.sendMessageToGroupChat(groupID: 0, content: "Hello Ya'll, I'm Dan")
        user4.addConversation(conversation: groupConversation)
        user4.sendMessageToGroupChat(groupID: 0, content: "Yo, I'm Ed like sleeping in your BED")
        groupConversation.printParticipants()
        let messages = groupConversation.getMessages()
        for message in messages {
            print("The date of this message is: \(message.getDate()) and the message is \(message.getContent())")
        }
    }
    
    
    
}
let test = Test()
test.startTest()




























