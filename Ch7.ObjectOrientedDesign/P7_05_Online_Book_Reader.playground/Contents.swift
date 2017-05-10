import Foundation

class BookPage {
    private var pageNumber: Int
    private var content: String
    
    init(pageNumber: Int, content: String) {
        self.pageNumber = pageNumber
        self.content = content
    }
    
    func getPageNumber() -> Int {
        return pageNumber
    }
    func getContent() -> String {
        return content
    }
    
}

class Book {
    private var bookId: Int
    private var details: String
    private var bookPages = [Int: BookPage]()
    
    
    init(bookId: Int, details: String, pages: [BookPage]) {
        self.bookId = bookId
        self.details = details
        for page in pages {
            let pageNumber = page.getPageNumber()
            bookPages[pageNumber] = page
        }
    }
    
    
    func update() { }
    
    func getID() -> Int {
        return bookId
    }
    
    func setID(id: Int) {
        bookId = id
    }
    
    func getDetails() -> String {
        return details
    }
    
    func setDetails(details: String) {
        self.details = details
    }
    
    func getBookPage(n: Int) -> BookPage? {
        return bookPages[n]
    }
}

class Library {
    private var books = [Int: Book]()
    
    func addBook(id: Int, details: String, pages: [BookPage]) -> Book? {
        if books[id] != nil {
            return nil
        }
        let book = Book(bookId: id, details: details, pages: pages)
        books[id] = book
        return book
    }
    
    func removeBook(id: Int) -> Bool {
        if books[id] == nil { return false }
        books.removeValue(forKey: id)
        return true
    }
    
    func removeBook(book: Book) -> Bool {
        return removeBook(id: book.getID())
    }
    
    func findBook(id: Int) -> Book? {
        return books[id]
    }
}

class Display {
    private var activeBook: Book?
    private var activeUser: User?
    private var activePage: BookPage?
    
    
    func openPageNumber(n: Int) -> BookPage? {
        if activeBook == nil {
            print("No book selected to open page")
            return nil
        } else {
            let page = activeBook?.getBookPage(n: n)
            activePage = page
            return page
        }
    }
    
    func turnPageForward() -> BookPage? {
        if activePage == nil {
            print("No Page has been selected yet")
            return nil
        } else {
            var currentPageNumber = activePage!.getPageNumber()
            currentPageNumber += 1
            activePage = openPageNumber(n: currentPageNumber)
            return activePage
        }
    }
    
    func turnPageBackWard() -> BookPage? {
        if activePage == nil {
            print("No Page has been selected yet")
            return nil
        } else {
            var currentPageNumber = activePage!.getPageNumber()
            currentPageNumber -= 1
            activePage = openPageNumber(n: currentPageNumber)
            return activePage
        }
    }
    
    
    func printOutUserName(user: User) {
        print("User name is: \(user.getDetails()) and ID is: \(user.getID())")
    }
    
    func displayUser(user: User) {
        activeUser = user
        printOutUserName(user: user)
        print("")
    }
    
    func printBook(book: Book) {
        print("Book name is: \(book.getDetails()), book ID is: \(book.getID())")
        print("Currently you're on page number: \(activePage?.getPageNumber())")
    }
    func displayBook(book: Book?) {
        if book == nil {
            print("Book does not exist")
            return
        }
        let pageNumber = 0
        activeBook = book
        activePage = openPageNumber(n: pageNumber)
        printBook(book: book!)
        print("")
    }
    
    func displayCurrentPage() {
        if activePage == nil {
            print("Not on a page at the moment")
        } else {
            print("Currently on: \(activePage!.getContent())")
        }
    }
}

class User {
    private var userId: Int
    private var details: String
    private var accountType: Int
    
    init(userId: Int, details: String, accountType: Int) {
        self.userId = userId
        self.details = details
        self.accountType = accountType
    }
    
    func getID() -> Int {
        return userId
    }
    
    func setID(id: Int) {
        userId = id
    }
    
    func getDetails() -> String {
        return details
    }
    
    func setDetails(details: String) {
        self.details = details
    }
    
    func getAccountType() -> Int {
        return accountType
    }
    
    func setAccountType(accountType: Int) {
        self.accountType = accountType
    }
}

class UserManager {
    
    private var users = [Int: User]()
    
    func addUser(id: Int, details: String, accountType: Int) -> User? {
        if users[id] != nil { return nil }
        let user = User(userId: id, details: details, accountType: accountType)
        users[id] = user
        return user
    }
    
    func remove(id: Int) -> Bool {
        if users[id] == nil { return false }
        users.removeValue(forKey: id)
        return true
    }
    
    func remove(user: User) -> Bool {
        return remove(id: user.getID())
    }
    
    func findUser(id: Int) -> User? {
        return users[id]
    }
    
}

class OnlineReaderSystem {
    private var library = Library()
    private var userManager = UserManager()
    private var display = Display()
    
    private var activeBook: Book?
    private var activeUser: User?
    
    func getLibrary() -> Library {
        return library
    }
    
    func getUserManager() -> UserManager {
        return userManager
    }
    
    func getDisplay() -> Display {
        return display
    }
    
    func getActiveBook() -> Book? {
        return activeBook
    }
    
    func setActiveBook(book: Book) {
        display.displayBook(book: book)
        activeBook = book
    }
    
    func getActiveUser() -> User? {
        return activeUser
    }
    
    func setActiveUser(user: User) {
        activeUser = user
        display.displayUser(user: user)
    }
}


class Test {
    
    func startTest() {
        let userManager = UserManager()
        userManager.addUser(id: 1, details: "Anh", accountType: 1)
        userManager.addUser(id: 2, details: "Off", accountType: 2)
        let page1 = BookPage(pageNumber: 1, content: "Page 1: How does it feel to be a damn loser?")
        let page2 = BookPage(pageNumber: 2, content: "Page 2: Hard to say, like to think I'm not a loser")
        let page3 = BookPage(pageNumber: 3, content: "Page 3: Positive thinkings would make you into a cool kid, foo")
        let page4 = BookPage(pageNumber: 4, content: "Page 4: Extremely good point, going to turn Anh off so he can be cool")
        let page5 = BookPage(pageNumber: 5, content: "Page 5: Anh or Off, whatever you prefer, is cool as hell")
        let library = Library()
        library.addBook(id: 1, details: "The Life of Loser Programmer Anh", pages: [page1, page2, page3, page4, page5])
        let onlineBookReader = OnlineReaderSystem()
        let book = library.findBook(id: 1)
        if book != nil {
            onlineBookReader.setActiveBook(book: book!)
        }
        if let user = userManager.findUser(id: 1) {
            onlineBookReader.setActiveUser(user: user)
        }
        let display = onlineBookReader.getDisplay()
        display.displayBook(book: book)
        if let page = display.openPageNumber(n: 3) {
            print("Page number is: \(page.getPageNumber()) and Content is: \(page.getContent())")
        }
        display.displayCurrentPage()
        display.turnPageForward()
        display.displayCurrentPage()
        display.openPageNumber(n: 2)
        display.displayCurrentPage()
        display.turnPageBackWard()
        display.displayCurrentPage()
    }
    
    
    
}

let test = Test()
test.startTest()

























