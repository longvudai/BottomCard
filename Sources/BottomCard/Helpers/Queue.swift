//
//  Queue.swift
//
//
//  Created by longvu on 25/05/2022.
//

import Foundation

struct Queue<T> {
    private var array = [T?]()
    private var head = 0

    init() {}

    var isEmpty: Bool {
        return count == 0
    }

    var count: Int {
        return array.count - head
    }

    mutating func enqueue(_ element: T) {
        array.append(element)
    }

    mutating func dequeue() -> T? {
        guard let element = array[guarded: head] else { return nil }

        array[head] = nil
        head += 1

        let percentage = Double(head) / Double(array.count)
        if array.count > 50, percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }

        return element
    }

    var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}

extension Array {
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex ..< endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}
