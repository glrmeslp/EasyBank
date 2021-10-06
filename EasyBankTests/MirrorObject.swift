class MirrorObject {
    let mirror: Mirror

    init(refrecting: Any) {
        self.mirror = Mirror(reflecting: refrecting)
    }

    func extract<T>(variableName: StaticString = #function) -> T? {
        return mirror.descendant("\(variableName)") as? T
    }
}
