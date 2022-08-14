//
//  DefaultLocalDataManager.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 13.8.22..
//

import Foundation


class DefaultLocalDataManager {
    
    private enum FileNames {
        static let mainDirectory = "LocalCachedDataDatabase"
    }
    
    enum SetupError: Swift.Error {
        case invalidDocumentsDirectory
        case noDatabaseFile
        case cantCreateDatabaseFile
    }
    
    static let userDefaultsFilePathKey = "main-file-path"
    
    private let fileManager : FileManager
    private var mainDirectoryUrl: URL
    
    init(fileManager: FileManager = FileManager.default) throws {
            self.fileManager = fileManager
            self.mainDirectoryUrl = try Self.setUp(fileManager: fileManager)
    }
    
   
    
    private static func setUp(fileManager: FileManager) throws -> URL {
        if let url = UserDefaults.standard.url(forKey: Self.userDefaultsFilePathKey) {
            if validateMainDirectory(url, fileManager: fileManager) == true {
                return url
            } else {
                return try createMainDirectory(fileManager: fileManager)
            }
        } else {
            return try createMainDirectory(fileManager: fileManager)
        }
    }
    
    private static func validateMainDirectory(_ url: URL, fileManager: FileManager) -> Bool {
        return fileManager.fileExists(atPath: url.path) 
    }
    
    private static func createMainDirectory(fileManager: FileManager) throws -> URL {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .allDomainsMask).first else {throw SetupError.invalidDocumentsDirectory}
        let mainDirectory = documentsDirectory.appendingPathComponent(FileNames.mainDirectory)
        if !fileManager.fileExists(atPath: mainDirectory.path) {
            try fileManager.createDirectory(at: mainDirectory, withIntermediateDirectories: false, attributes: nil)
        }
        UserDefaults.standard.set(mainDirectory, forKey: Self.userDefaultsFilePathKey)
        return mainDirectory
    }
    
}

extension DefaultLocalDataManager: LocalDataManager {
    func read(from url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let finalPath = self.mainDirectoryUrl.absoluteString + url
        guard let url = URL(string: finalPath) else {
            completion(.failure(SetupError.cantCreateDatabaseFile))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch { completion(.failure(error)) }
    }
    
    func write(data: Data, to url: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let finalPath = self.mainDirectoryUrl.path + url
         let url = URL(fileURLWithPath: finalPath)
        let directoryUrl = url.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: directoryUrl.path) {
            do {
                try fileManager.createDirectory(at: directoryUrl, withIntermediateDirectories: true)
                if !fileManager.fileExists(atPath: url.absoluteString) {
                    let result = fileManager.createFile(atPath: url.path, contents: nil)
                    if result == false {
                        completion(.failure(SetupError.cantCreateDatabaseFile))
                        return
                    }
                    
                    do {
                        try data.write(to: url)
                        completion(.success(()))
                    } catch let error {
                        completion(.failure(error)) }
                }
                
            } catch let error {
                completion(.failure(error))
                return
            }
        } else {
            let result = fileManager.createFile(atPath: url.path, contents: nil)
            if result == false {
                completion(.failure(SetupError.cantCreateDatabaseFile))
                return
            }
            
            do {
                try data.write(to: url)
                completion(.success(()))
            } catch let error {
                completion(.failure(error)) }
        }
        
    }
    
    func delete(at url: String, completion: @escaping (Result<Void, Error>) -> Void) {}
    
    
}
