//
//  LocalDataManager.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 13.8.22..
//

import Foundation


protocol LocalDataManager {
    func read(from at: URL, completion: @escaping (Result<Data,Error>) -> Void)
    func write(data: Data, to url: URL, completion: @escaping (Result<Void,Error>) -> Void)
    func delete(at url: URL, completion: @escaping (Result<Void,Error>) -> Void)
}

class DefaultFileManager {
    
    private enum FileNames {
        static let mainDirectory = "LocalCachedDataDatabase"
    }
    
    enum Errors: Error {
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
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .allDomainsMask).first else {throw Errors.invalidDocumentsDirectory}
        let mainDirectory = documentsDirectory.appendingPathComponent(FileNames.mainDirectory)
        if !fileManager.fileExists(atPath: mainDirectory.path) {
            try fileManager.createDirectory(at: mainDirectory, withIntermediateDirectories: false, attributes: nil)
        }
        UserDefaults.standard.set(mainDirectory, forKey: Self.userDefaultsFilePathKey)
        return mainDirectory
    }
    
}
