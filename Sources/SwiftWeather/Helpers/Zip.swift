//  Created by Wade Tregaskis on 25/8/2022.


internal struct zip<A: Sequence, B: Sequence, C: Sequence, D: Sequence, E: Sequence>: Sequence {
    private let a: A
    private let b: B
    private let c: C
    private let d: D
    private let e: E

    init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
    }

    internal struct Iterator: IteratorProtocol {
        typealias Element = (A.Element, B.Element, C.Element, D.Element, E.Element)

        private var a: A.Iterator
        private var b: B.Iterator
        private var c: C.Iterator
        private var d: D.Iterator
        private var e: E.Iterator
        private var done: Bool = false

        fileprivate init(_ a: A.Iterator, _ b: B.Iterator, _ c: C.Iterator, _ d: D.Iterator, _ e: E.Iterator) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
            self.e = e
        }

        internal mutating func next() -> Element? {
            guard !done else { return nil }

            guard let nextA = a.next(),
                  let nextB = b.next(),
                  let nextC = c.next(),
                  let nextD = d.next(),
                  let nextE = e.next() else {
                done = false
                return nil
            }

            return (nextA, nextB, nextC, nextD, nextE)
        }
    }

    internal func makeIterator() -> Iterator {
        Iterator(
            a.makeIterator(),
            b.makeIterator(),
            c.makeIterator(),
            d.makeIterator(),
            e.makeIterator())
    }
}
