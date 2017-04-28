//: Playground - noun: a place where people can play

import UIKit

//  Call Center: Imagine you have a call center with three levels of employees: respondent, manager, and director. An incoming telephone call must be first allocated to a respondent who is free. If the respondent can't handle the call, he or she must escalate the call to a manager. If the manager is not free or not able to handle it, then the call should be escalated to a director. Design the classes and data structures for this problem. Implement a method dispatchCall() which assigns a call to the first available employee.

//: Playground - noun: a place where people can play

import UIKit

enum Rank: Int {
    case responder = 0, manager, director
}

class Call {
    private var rank: Rank
    private var caller: Caller
    private var handler: Employee?
    
    init(caller: Caller) {
        rank = .responder
        self.caller = caller
    }
    
    func setHandler(emp: Employee) {
        handler = emp
    }
    
    func reply(message: String) {
        print(message)
    }
    
    func getRank() -> Rank {
        return rank
    }
    
    func incrementRank() -> Rank {
        if rank == .responder {
            rank = .manager
        } else if rank == .manager {
            rank = .director
        }
        return rank
    }
    
    func disconnect() {
        reply(message: "Thank you for calling")
    }
    
    func getCaller() -> Caller {
        return caller
    }
}

class Caller {
    private var name: String
    private var userId: Int
    init(name: String, userId: Int) {
        self.name = name
        self.userId = userId
    }
    func getName() -> String {
        return name
    }
}

class CallHandler {
    
    private final var levels = 3
    
    private final var num_respondents = 10
    private final var num_managers = 4
    private final var num_directors = 2
    
    var employeeLevels = [[Employee]]()
    var callQueues = [[Call]]()
    
    init() {
        var respondents = [Employee]()
        for i in 0 ..< num_respondents {
            respondents.append(Respondent(callHandler: self, name: "Respondent \(i + 1)"))
        }
        
        var managers = [Employee]()
        for i in 0 ..< num_managers {
            managers.append(Manager(callHandler: self, name: "Manager \(i + 1)"))
        }
        
        var directors = [Employee]()
        for i in 0 ..< num_directors {
            directors.append(Director(callHandler: self, name: "Director \(i + 1)"))
        }
        employeeLevels.append(respondents)
        employeeLevels.append(managers)
        employeeLevels.append(directors)
    }
    
    func addCalls(calls: [Call]) {
        for call in calls {
            if call.getRank().rawValue == 0 {
                callQueues[0].append(call)
            } else if call.getRank().rawValue == 1 {
                callQueues[1].append(call)
            } else if call.getRank().rawValue == 2 {
                callQueues[2].append(call)
            }
        }
    }
    
    func getHandlerForCall(call: Call) -> Employee? {
        let level = call.getRank().rawValue
        for l in level ... levels - 1 {
            let employeeLevel = employeeLevels[l]
            for emp in employeeLevel {
                if emp.isFree() {
                    return emp
                }
            }
        }
        return nil
    }
    
    func dispatchToCaller(caller: Caller) {
        let call = Call(caller: caller)
        dispatchCall(call: call)
    }
    
    func dispatchCall(call: Call) -> Employee? {
        let emp = getHandlerForCall(call: call)
        if emp != nil {
            emp?.receiveCall(call: call)
            call.setHandler(emp: emp!)
            return emp
        } else {
            call.reply(message: "Please wait for free employee to reply")
            callQueues[call.getRank().rawValue].append(call)
            return nil
        }
    }
    
    func assignCall(emp: Employee) -> Bool {
        let rank = emp.getRank()?.rawValue
        for rank in stride(from: rank! , through: 0, by: -1) {
            var que = callQueues[rank]
            if que.count > 0 {
                let call = que.removeFirst() // This is better as a linkedlist because removing at head will be much more efficient! :)
                emp.receiveCall(call: call)
                return true
            }
        }
        return false
    }
    
}

class Employee {
    private var currentCall: Call?
    internal var rank: Rank?
    private var callHandler: CallHandler
    private var name: String
    
    init(callHandler: CallHandler, name: String) {
        self.callHandler = callHandler
        self.name = name
    }
    
    func receiveCall(call: Call) {
        print("\(name) received the call from \(call.getCaller().getName())")
        currentCall = call
    }
    
    func callCompleted() {
        if currentCall != nil {
            currentCall?.disconnect()
            currentCall = nil
        }
        assignNewCall()
    }
    
    func assignNewCall() -> Bool {
        if !isFree() {
            return false
        }
        return callHandler.assignCall(emp: self)
    }
    
    func escalateAndReassign() {
        if currentCall != nil {
            currentCall?.incrementRank()
            callHandler.dispatchCall(call: currentCall!)
            currentCall == nil
        }
        assignNewCall()
    }
    
    func isFree() -> Bool {
        return currentCall == nil
    }
    
    func getRank() -> Rank? {
        return rank
    }
    
    func getEmployeeName() -> String {
        return name
    }
    
}

class Respondent: Employee {
    override init(callHandler: CallHandler, name: String) {
        super.init(callHandler: callHandler, name: name)
        rank = .responder
    }
}

class Manager: Employee {
    override init(callHandler: CallHandler, name: String) {
        super.init(callHandler: callHandler, name: name)
        rank = .manager
    }
}

class Director: Employee {
    override init(callHandler: CallHandler, name: String) {
        super.init(callHandler: callHandler, name: name)
        rank = .director
    }
}

class CallCenter {
    
    func beginCalls() {
        let callHandler = CallHandler()
        let caller1 = Caller(name: "C1", userId: 1)
        let caller2 = Caller(name: "C2", userId: 2)
        let caller3 = Caller(name: "C3", userId: 3)
        let caller4 = Caller(name: "C4", userId: 4)
        let caller5 = Caller(name: "C5", userId: 5)
        let call1 = Call(caller: caller1)
        let call2 = Call(caller: caller2)
        let call3 = Call(caller: caller3)
        let call4 = Call(caller: caller4)
        let call5 = Call(caller: caller5)
        let respondent1 = callHandler.dispatchCall(call: call1)
        let respondent2 = callHandler.dispatchCall(call: call2)
        let respondent3 = callHandler.dispatchCall(call: call3)
        let respondent4 = callHandler.dispatchCall(call: call4)
        let respondent5 = callHandler.dispatchCall(call: call5)
        respondent1?.escalateAndReassign()
        respondent2?.escalateAndReassign()
        respondent3?.escalateAndReassign()
        respondent4?.escalateAndReassign()
        respondent5?.escalateAndReassign() // Since no more managers, we go to director :). Remember we initialized 10 respondents, 4 managers, and 2 directors.
    }
    
}

let callCenter = CallCenter()
callCenter.beginCalls()





