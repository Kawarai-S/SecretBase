//
//  ModelData.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/17.
//

import Foundation

public var titles:[String: Title] = load("TitleList.json")
public var users: [String: AppUser] = load("Users.json")


func load<T: Decodable>(_ filename: String) -> T {
    // ファイルから読み込んだデータを保持するための変数
    let data: Data
    
    // メインバンドルから指定したファイル名のリソースのURLを取得
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    // 取得したURL（file）からデータを読み込む
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    // 読み込んだデータ（data）を変換する
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
