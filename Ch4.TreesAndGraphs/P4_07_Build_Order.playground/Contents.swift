//: Playground - noun: a place where people can play

import UIKit
// Build Order: You are given a list of projects and a list of dependencies (which is a list of pairs of projects, where the second project is dependent on the first project). All of a project's dependencies must be built before the project is. Find a build order that will allow the projects to be built. If there is no valid build order, return an error.
// Example: 
// projects: a, b, c, d, e, f
// dependencies: (a,d), (f,b), (b, d), (f,a), (d,c)
// Output: f, e, a, b, d, c.

class Project {
    private var name: String
    private var children = [Project]()
    private var dependencies = 0
    private var map = [String: Project]() // We create this dictionary to prevent duplicates of dependencies.
    
    init(name: String) {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
    
    func addDependency(childProject: Project) {
        if map[childProject.name] == nil { // If only dictionary is nil, then we will add in the children.
            children.append(childProject)
            map[childProject.name] = childProject
            childProject.dependencies += 1
        }
    }
    
    func getChildren() -> [Project] {
        return children
    }
    
    func decrementDependencies() {
        dependencies -= 1
    }
    
    func getDependencies() -> Int {
        return dependencies
    }
    
    // Solution 2 Variables
    enum State {
        case blank
        case partial
        case completed
    }
    private var state = State.blank
    
    func getState() -> State {
        return state
    }
    
    func setState(state: State) {
        self.state = state
    }
}

class Graph {
    
    private var nodes = [Project]()
    private var map = [String: Project]()
    
    func getOrCreateNode(name: String) -> Project {
        if map[name] == nil {
            let node = Project(name: name)
            map[name] = node
            nodes.append(node)
        }
        return map[name]!
    }
    
    func addDependency(parent: String, child: String) {
        let parentNode = getOrCreateNode(name: parent)
        let childNode = getOrCreateNode(name: child)
        parentNode.addDependency(childProject: childNode)
    }
    
    func getProjects() -> [Project] {
        return nodes
    }
    
}

class Result {
    
    // Solution 1
    private func buildGraph(projects: [String], dependencies: [[String]]) -> Graph {
        let graph = Graph()
        for project in projects {
            graph.getOrCreateNode(name: project)
        }
        for dependency in dependencies {
            if dependency.isEmpty { continue }
            let parent = dependency[0]
            let child = dependency[1]
            graph.addDependency(parent: parent, child: child)
        }
        return graph
    }
    
    // Add NonDependencies Projects and keep track of index of the projects we have added already.
    private func buildNonDependent(result: inout [Project?], projects: [Project], index: Int) -> Int {
        var index = index
        for project in projects {
            if project.getDependencies() == 0 {
                result[index] = project
                index += 1
            }
        }
        return index
    }
    
    private func findBuildOrderHelper(projects: [Project]) -> [Project?]? {
        var result = [Project?](repeatElement(nil, count: projects.count))
        var currentIndex = buildNonDependent(result: &result, projects: projects, index: 0)
        
        var projectToBeProcessedIndex = 0
        while projectToBeProcessedIndex < result.count {
            let currentProject = result[projectToBeProcessedIndex]
            // circular dependencies since there are no remaining projects with zero dependencies, thus we return nil.
            if currentProject?.getName() == nil {
                return nil
            }
            if let children = currentProject?.getChildren() {
                for child in children {
                    child.decrementDependencies()
                }
                currentIndex = buildNonDependent(result: &result, projects: children, index: currentIndex)
                projectToBeProcessedIndex += 1
            }
        }
        
        return result
    }
    
    private func convertResultToString(projects: [Project?]) -> [String] {
        var result = [String]()
        for project in projects {
            if let name = project?.getName() {
                result.append(name)
            }
        }
        return result
    }

    private func findBuildOrder(projects: [String], dependencies: [[String]]) -> [Project?]? {
        let graph = buildGraph(projects: projects, dependencies: dependencies)
        return findBuildOrderHelper(projects: graph.getProjects())
    }
    
    func buildOrder(projects: [String], dependencies: [[String]]) -> [String]? {
        let build = findBuildOrder(projects: projects, dependencies: dependencies)
        return build == nil ? nil : convertResultToString(projects: build!)

    }
    
    
    
    // Solution 2: DFS
    private func dFS(project: Project, stack: inout [Project]) -> Bool {
        if project.getState() == .partial {
            return false
        }
        if project.getState() == .blank {
            project.setState(state: .partial)
            let children = project.getChildren()
            for child in children {
                if !dFS(project: child, stack: &stack) {
                    return false
                }
            }
            project.setState(state: .completed)
            stack.append(project)
        }
        return true
    }
    private func buildOrderDFS(projects: [Project]) -> [Project]? {
        var stack = [Project]()
        for project in projects {
            if project.getState() == .blank {
                if !dFS(project: project, stack: &stack) {
                    return nil
                }
            }
        }
        return stack
    }
    
    func getBuildOrderDFS(projects: [String], dependencies: [[String]]) -> [String]? {
        let graph = buildGraph(projects: projects, dependencies: dependencies)
        var result = [String]()
        var buildOrder = buildOrderDFS(projects: graph.getProjects())
        if buildOrder == nil {
            return nil
        } else {
            while buildOrder!.count > 0 {
                result.append(buildOrder!.removeLast().getName())
            }
        }
        return result
    }
    
}



let projects = ["a", "b", "c", "d", "e", "f"]
let dependencies = [
    ["f", "b"],
    ["f", "c"],
    ["f", "a"],
    ["c", "a"],
    ["b", "a"],
    ["a", "e"],
    ["d", "g"],
    ["d", "g"] // Still works for duplicate dependencies! :)
//    ["e", "f"] // has detected a cycle - should return nil.
]

let result = Result()
result.buildOrder(projects: projects, dependencies: dependencies)
result.getBuildOrderDFS(projects: projects, dependencies: dependencies)

let projectsTwo = ["a", "b", "c", "d", "e", "f"]
let dependenciesTwo = [
    ["a", "d"],
    ["f", "b"],
    ["b", "d"],
    ["f", "a"],
    ["d", "c"]
]
result.buildOrder(projects: projectsTwo, dependencies: dependenciesTwo)
result.getBuildOrderDFS(projects: projectsTwo, dependencies: dependenciesTwo)




