//
//  DataBase.swift
//  SQLITE_MUSIC
//
//  Created by Tuuu on 7/22/16.
//  Copyright © 2016 TuNguyen. All rights reserved.
//

import Foundation

class DataBase {
    
    var getPath = { () -> String in
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = NSString(string: dirPaths[0])
        return docsDir.appendingPathComponent("musicsLinggka.db")
    }
    
    var createDataBase = { (_ dataBasePath: String) -> Bool in
        let file = FileManager.default
        //kiểm tra xem file database đã có hay chưa
        //        print("createDataBase: \(dataBasePath)")
        //        print("createDataBase !file.fileExists(atPath: dataBasePath) : \(!file.fileExists(atPath: dataBasePath))")
        if(!file.fileExists(atPath: dataBasePath))
        {
            //khởi tạo Database với đường dẫn
            if let musicsDB = FMDatabase(path: dataBasePath) {
                if musicsDB.open()
                {
                    //các câu lệnh tạo table
                    let sql_Create_SONGS = "create table if not exists SONGS (ID integer primary key autoincrement, SongName text, UrlImg text)"
                    
                    let sql_Create_DetailPlayList = "create table if not exists DetailPlayList (SongID integer, PlayListID integer, foreign key (PlayListID) references PLAYLIST(ID), foreign key (SongID) references SONGS(ID), primary key (SongID, PlayListID))"
                    
                    let sql_Create_PlayList = "create table if not exists PLAYLIST (ID integer primary key autoincrement, PlaylistName text)"
                    
                    let sql_Create_ALBUMS = "create table if not exists ALBUMS (ID integer primary key autoincrement, Price text, AlbumName text, ReleaseDate text, UrlImg text)"
                    
                    let sql_Create_DetailAlbum = "create table if not exists DETAILALBUM (AlbumID integer, " +
                        "GenreID integer, " +
                        "ArtistID integer, " +
                        "SongID integer, " +
                        "foreign key (AlbumID) references ALBUMS(ID), " +
                        "foreign key (GenreID) references GENRES(ID), " +
                        "foreign key (ArtistID) references ARTISTS(ID), " +
                        "foreign key (SongID) references SONGS(ID), " +
                    "primary key (AlbumID, GenreID, ArtistID, SongID))"
                    
                    let sql_Create_ARTISTS = "create table if not exists ARTISTS (ID integer primary key autoincrement, ArtistName text, UrlImg text, Born text not null)"
                    
                    let sql_Create_GENRES = "create table if not exists GENRES (ID integer primary key autoincrement, GenreName text)"
                    
                    //tạo table
                    if !musicsDB.executeStatements(sql_Create_SONGS) {
                        print("Error: \(String(describing: musicsDB.lastErrorMessage()))")
                    }
                    if !musicsDB.executeStatements(sql_Create_DetailPlayList) {
                        print("Error: \(String(describing: musicsDB.lastErrorMessage()))")
                    }
                    if !musicsDB.executeStatements(sql_Create_PlayList) {
                        print("Error: \(String(describing: musicsDB.lastErrorMessage()))")
                    }
                    if !musicsDB.executeStatements(sql_Create_ALBUMS) {
                        print("Error: \(String(describing: musicsDB.lastErrorMessage()))")
                    }
                    if !musicsDB.executeStatements(sql_Create_DetailAlbum) {
                        print("Error: \(String(describing: musicsDB.lastErrorMessage()))")
                    }
                    if !musicsDB.executeStatements(sql_Create_ARTISTS) {
                        print("Error: \(String(describing: musicsDB.lastErrorMessage()))")
                    }
                    if !musicsDB.executeStatements(sql_Create_GENRES) {
                        print("Error: \(String(describing: musicsDB.lastErrorMessage()))")
                    }
                    
                    musicsDB.close()
                    return true
                }
                else
                {
                    print("Error: \(String(describing: musicsDB.lastErrorMessage()))")
                }
            } else {
                print("musicsDB is nil.")
            }
            
            
        }
        return false
    }
    
    var insertDatabase = { (_ nameTable: String, _ dict: NSDictionary, _ dataBasePath: String) in
        //tạo các biến chứa keys và values để chèn vào table
        var keys = String()
        var values = String()
        var first = true
        
        for key in dict.allKeys
        {
            if (first == true)
            {
                keys = "'" + (key as! String) + "'"
                values = "'" + (dict.object(forKey: key) as! String) + "'"
                first = false
                continue
            }
            //duyệt qua tất cả các phần tử và cộng vào biết keys và values
            keys = keys + "," + "'" + (key as! String) + "'"
            values = values + "," + "'" + (dict.object(forKey: key) as! String) + "'"
        }
        
        if let musicsDB = FMDatabase(path: dataBasePath) {
            if musicsDB.open()
            {
                if (!musicsDB.executeStatements("PRAGMA foreign_keys = ON"))
                {
                    print("Error: \(String(describing: musicsDB.lastErrorMessage()))")
                }
                //chèn values và keys vào table
                let insertSQL = "INSERT INTO \(nameTable) (\(keys)) VALUES (\(values))"
                let result = musicsDB.executeUpdate(insertSQL, withArgumentsIn: nil)
                if !result
                {
                    print("Error: \(String(describing: musicsDB.lastErrorMessage()))")
                }
            }
            musicsDB.close()
        } else {
            print("musicsDB is nil.")
        }
    }
    
    var viewDataBase = {(_ tableName:String, _ columns:[String], _ statement: String, _ dataBasePath: String) -> [NSDictionary] in
        var items = [NSDictionary]()
        if let musicsDB = FMDatabase(path: dataBasePath as String) {
            if musicsDB.open()
            {
                //                ["name", "id"]
                var allColumns = ""
                for column in columns
                {
                    //giống như hàm insert
                    if (allColumns == "")
                    {
                        allColumns = column
                    }
                    else
                    {
                        allColumns = allColumns + "," + column
                    }
                }
                //câu lệnh query
                let querySQL = "Select DISTINCT \(allColumns) From \(tableName) \(statement)"
                let results: FMResultSet? = musicsDB.executeQuery(querySQL, withArgumentsIn: nil)
                //results.next có nghĩa là có bản ghi tiếp theo đâu
                while ((results?.next()) == true) {
                    items.append((results?.resultDictionary())! as NSDictionary)
                }
            }
            musicsDB.close()
        }
        return items
    }
    
    var insertData = { (_ controller: DataBase, _ path: String) in
        //ALBUMS
        
        controller.insertDatabase("ALBUMS", ["Price":"200.000", "AlbumName":"Anh Bỏ Thuốc Em Sẽ Yêu", "ReleaseDate":"11/1/2015", "UrlImg":"Anh Bỏ Thuốc Em Sẽ Yêu - Lyna Thùy Linh.jpg"], path)
        controller.insertDatabase("ALBUMS", ["Price":"350.000", "AlbumName":"Anh Cứ Đi Đi", "ReleaseDate":"3/4/2015", "UrlImg":"Anh Cứ Đi Đi.jpg"], path)
        controller.insertDatabase("ALBUMS", ["Price":"400.000", "AlbumName":"Bí Mật Bị Thời Gian Vùi Lấp", "ReleaseDate":"6/9/2015", "UrlImg":"Bí Mật Bị Thời Gian Vùi Lấp.jpg"], path)
        controller.insertDatabase("ALBUMS", ["Price":"700.000", "AlbumName":"Đếm Ngày Xa Em - Lou Hoàng,OnlyC", "ReleaseDate":"30/1/2014", "UrlImg":"Đếm Ngày Xa Em - Lou Hoàng,OnlyC.jpg"], path)
        controller.insertDatabase("ALBUMS", ["Price":"150.000", "AlbumName":"Yêu Một Người Không Sai", "ReleaseDate":"19/5/2016", "UrlImg":"Yêu Một Người Không Sai.jpg"], path)
        
        //ARTISTS
        controller.insertDatabase("ARTISTS", ["ArtistName":"Linh Ka", "Born":"10/9/2003", "UrlImg":"Tình Yêu Nhạt Màu (Bí Mật Bị Thời Gian Vùi Lấp OST).jpg"], path)
        controller.insertDatabase("ARTISTS", ["ArtistName":"HariWon", "Born":"20/11/1983", "UrlImg":"Anh Cứ Đi Đi - Hari Won.jpg"], path)
        controller.insertDatabase("ARTISTS", ["ArtistName":"LOU HOÀNG", "Born":"19/1/1990", "UrlImg":"LOUHOANG.jpg"], path)
        controller.insertDatabase("ARTISTS", ["ArtistName":"LYNA THUỲ LINH", "Born":"27/8/1992", "UrlImg":"LYNA THÙY LINH.jpg"], path)
        controller.insertDatabase("ARTISTS", ["ArtistName":"MAI FIN", "Born":"19/5/1993", "UrlImg":"Chủ Nhật Buồn .jpg"], path)
        //Genres
        controller.insertDatabase("GENRES", ["GenreName":"Nhạc Trẻ"], path)
        controller.insertDatabase("GENRES", ["GenreName":"Trữ Tình"], path)
        
        //PlayList
        controller.insertDatabase("PLAYLIST", ["PlaylistName":"Nhạc Nghe Lúc Buồn"], path)
        controller.insertDatabase("PLAYLIST", ["PlaylistName":"Nhạc Thất Tình"], path)
        
        //Song
        controller.insertDatabase("SONGS", ["SongName":"Em Gái Mưa - Linh Ka Cover", "UrlImg":"Anh Bỏ Thuốc Em Sẽ Yêu.jpg"], path)
        controller.insertDatabase("SONGS", ["SongName":"Chưa bao giờ mẹ kể - Linh Ka Cover", "UrlImg":"Gái Nhà Lành.jpg"], path)
        controller.insertDatabase("SONGS", ["SongName":"Từ hôm nay - Linh Ka Cover", "UrlImg":"Anh Cứ Đi Đi - Hari Won.jpg"], path)
        controller.insertDatabase("SONGS", ["SongName":"Đẹp nhất là em - Linh Ka, Long Hoang", "UrlImg":"Điệp Khúc Mùa Xuân.jpg"], path)
        controller.insertDatabase("SONGS", ["SongName":"Ánh nắng của em - Linh Ka Cover", "UrlImg":"Chỉ Mong Trái Tim Người.jpg"], path)
        controller.insertDatabase("SONGS", ["SongName":"Nơi này có em - Linh Ka Cover", "UrlImg":"Tình Yêu Nhạt Màu (Bí Mật Bị Thời Gian Vùi Lấp OST).jpg"], path)
        controller.insertDatabase("SONGS", ["SongName":"Muốn yêu ai đó cả cuộc đời - Linh Ka Cover", "UrlImg":"Đếm Ngày Xa Em.jpg"], path)
        controller.insertDatabase("SONGS", ["SongName":"Có em chờ - Linh Ka Cover", "UrlImg":"Yêu Một Người Có Lẽ.jpg"], path)
        controller.insertDatabase("SONGS", ["SongName":"Hong kong 1 - Linh Ka Cover", "UrlImg":"Chủ Nhật Buồn .jpg"], path)
        controller.insertDatabase("SONGS", ["SongName":"Cho anh hỏi - Linh Ka Cover", "UrlImg":"Yêu Một Người Không Sai.jpg"], path)
        
        //DetailPlaylist
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"1", "PlayListID":"1"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"2", "PlayListID":"1"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"3", "PlayListID":"1"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"4", "PlayListID":"1"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"5", "PlayListID":"1"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"6", "PlayListID":"1"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"7", "PlayListID":"1"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"8", "PlayListID":"1"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"9", "PlayListID":"1"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"10", "PlayListID":"1"], path)
        
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"6", "PlayListID":"2"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"7", "PlayListID":"2"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"8", "PlayListID":"2"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"9", "PlayListID":"2"], path)
        controller.insertDatabase("DETAILPLAYLIST", ["SongID":"10", "PlayListID":"2"], path)
        
        //DetailAlbum
        
        controller.insertDatabase("DETAILALBUM", ["AlbumID":"1", "GenreID":"1", "ArtistID":"1", "SongID":"1"], path)
        controller.insertDatabase("DETAILALBUM", ["AlbumID":"1", "GenreID":"1", "ArtistID":"1", "SongID":"2"], path)
        controller.insertDatabase("DETAILALBUM", ["AlbumID":"2", "GenreID":"1", "ArtistID":"1", "SongID":"3"], path)
        controller.insertDatabase("DETAILALBUM", ["AlbumID":"2", "GenreID":"1", "ArtistID":"1", "SongID":"4"], path)
        
        controller.insertDatabase("DETAILALBUM", ["AlbumID":"3", "GenreID":"1", "ArtistID":"1", "SongID":"5"], path)
        controller.insertDatabase("DETAILALBUM", ["AlbumID":"3", "GenreID":"1", "ArtistID":"1", "SongID":"6"], path)
        
        controller.insertDatabase("DETAILALBUM", ["AlbumID":"4", "GenreID":"1", "ArtistID":"1", "SongID":"7"], path)
        controller.insertDatabase("DETAILALBUM", ["AlbumID":"4", "GenreID":"1", "ArtistID":"1", "SongID":"8"], path)
        
        controller.insertDatabase("DETAILALBUM", ["AlbumID":"5", "GenreID":"1", "ArtistID":"1", "SongID":"9"], path)
        controller.insertDatabase("DETAILALBUM", ["AlbumID":"5", "GenreID":"1", "ArtistID":"1", "SongID":"10"], path)
    }
    
    
    
    
    init()
    {
        let path = getPath()
        //        print("dataBasePath: \(dataBasePath)")
        if createDataBase(path) {
            insertData(self, path)
        }
//        albums
//        artists
//        genres
//        playlist
//        songs
//        detailplaylist
//        detailalbum
//        print(viewDataBase("ALBUMS", ["*"], "", path))
//        print(viewDataBase("artists", ["*"], "", path))
//        print(viewDataBase("genres", ["*"], "", path))
//        print(viewDataBase("playlist", ["*"], "", path))
//        print(viewDataBase("songs", ["*"], "", path))
//        print(viewDataBase("detailplaylist", ["*"], "", path))
//        print(viewDataBase("detailalbum", ["*"], "", path))
        
//        insertDatabase("ALBUMS", ["Price":"200.000", "AlbumName":"Anh Bỏ Thuốc Em Sẽ Yêu", "ReleaseDate":"11/1/2015", "UrlImg":"Anh Bỏ Thuốc Em Sẽ Yêu - Lyna Thùy Linh.jpg"], dataBasePath)
//        print(viewDataBase("ALBUMS", ["*"], "", dataBasePath))
    }
    
}
