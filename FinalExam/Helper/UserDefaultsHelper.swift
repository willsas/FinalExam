import Foundation

struct UserDefaultsHelper {
    private let userDefault = UserDefaults.standard
    private let key: String
    
    init(key: String) {
        self.key = key
    }
    
    func saveArray<T: Codable>(_ array: [T]) {
        do {
            let data = try JSONEncoder().encode(array)
            userDefault.set(data, forKey: key)
        } catch {
            print("Error encoding array: \(error)")
        }
    }
    
    func appendArray<T: Codable>(_ newData: T) {
        if var data: [T] = retrieveArray() {
            data.append(newData)
            saveArray(data)
        } else {
            saveArray([newData])
        }
    }
    
    func retrieveArray<T: Codable>() -> [T]? {
        guard let data = userDefault.data(forKey: key) else { return nil }
        
        do {
            let array = try JSONDecoder().decode([T].self, from: data)
            return array
        } catch {
            print("Error decoding array: \(error)")
            return []
        }
    }
}
