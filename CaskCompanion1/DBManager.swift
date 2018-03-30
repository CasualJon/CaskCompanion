//
//  DBManager.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 7/22/17.
//  Copyright © 2018 Jon Cyrus. All rights reserved.
//

import Foundation

class DBManager: NSObject {
    /////////////////////////////////////////////////////////////////////////////////////
    //  Making DBManager class a Singleton (lol)
    /////////////////////////////////////////////////////////////////////////////////////
    static let shared: DBManager = DBManager()
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Fields/Global Variables
    /////////////////////////////////////////////////////////////////////////////////////
    
    //  Declaring variables used by DBManager code for referencing the SQLiite DB
    let databaseFileName = "TESTCCDB2.db"
    let dbVersion = 2
    var pathToDB: String!
    var dbPath: URL!
    var database: FMDatabase!
    
    //  Setting fields as immutable variables for accuracy in later recall and use
    private let field_glossTerm = "term"
    private let field_glossDefinition = "definition"
    private let closeSQL = "%';"
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Initializer/Constructor
    /////////////////////////////////////////////////////////////////////////////////////
    override init() {
        super.init()

//TODO - implement a method to check for versioning of databases.  If a new version is released, it should copy
//the new database version into the documents directory, populate the UserStats from the old version into the new version
//then delete the old version from the documents directory
        
        //  Check for the db in the documents directory, move if required
        if copyDatabaseToDocumentsDir() {
            database = FMDatabase(path: dbPath.absoluteString)
        }
        //  If unable to find and unable to move db into documents directory, use from resource directory
        else {
            print("You will be able to use the application, but unable to persistently store any updates this session.")
            let resourcePath = Bundle.main.resourceURL!
            dbPath = resourcePath.appendingPathComponent(databaseFileName)
            database = FMDatabase(path: dbPath.absoluteString)
        }
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Methods/Functions
    /////////////////////////////////////////////////////////////////////////////////////
    
    //  NAME:   openDatabase()
    //  USAGE:  Check to see if the database connection is established for retrieving data and/or
    //          update operations by initalizing database object if not yet initialized and opening
    //          the connection to the database via open().
    //  PARAMS: None
    //  RETURN: Bool
    //  BUGS:   None known
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: dbPath.absoluteString) {
                database = FMDatabase(path: dbPath.absoluteString)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        return false
    }
    
    
    //  NAME:   closeDatabase()
    //  USAGE:  Checks to see if database is open. If open, this method closes the database
    //  PARAMS: None
    //  RETURN: Void
    //  BUGS:   None known
    func closeDatabase() {
        if database != nil {
            if database.open() {
                database.close()
            }
        }
    }
    
    
    //  NAME:   copyDatabaseToDocumentDir()
    //  USAGE:  To persistently store any user-made changes, the db must be operated upon from the Documents directory 
    //          rather than in the resources folder in which it resides.  This method checks location and moves it.
    //  PARAMS: None
    //  RETURN: Void
    //  BUGS:   None known
    func copyDatabaseToDocumentsDir() -> Bool {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        //  If cannot find documents URL
        guard documentsURL.count != 0
        else {
            print("The Documents directory cannot be located or reached.")
            return false
        }
        
        let finalDatabaseURL = documentsURL.first!.appendingPathComponent(databaseFileName)
        if !((try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("Database does not exist within the Documents folder.  Will attempt to copy from Resources to Documents.")
            
            let docsURL = Bundle.main.resourceURL?.appendingPathComponent(databaseFileName)
            
            do {
                try fileManager.copyItem(atPath: (docsURL?.path)!, toPath: finalDatabaseURL.path)
            }
            catch let error as NSError {
                print("Unable to copy database file to final location.  Error: \(error.description)")
            }
        }
        else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
        
        dbPath = finalDatabaseURL
        return true
    }
    
    
    //  NAME:   loadFullGlossary()
    //  USAGE:  With a little luck, this should build an array of glossary contents and return them 
    //          to the caller (primarily for full display of the glossary in table format).
    //  PARAMS: None
    //  RETURN: [glossaryTuple]
    //  BUGS:   None known
    func loadFullGlossary() -> [glossaryTuple]! {
        var entries: [glossaryTuple]!
        let sqlQuery = "SELECT * FROM TermsAndDefs ORDER BY \(field_glossTerm);"
        
        if openDatabase() {
            do {
                let results = try database.executeQuery(sqlQuery, values: nil)
                
                while results.next() {
                    let entry = glossaryTuple(glossaryTerm: results.string(forColumn: field_glossTerm), glossaryDefinition: results.string(forColumn: field_glossDefinition))
                    
                    if entries == nil {
                        entries = [glossaryTuple]()
                    }
                    
                    entries.append(entry)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        
            closeDatabase()
        }
        
        return entries
    }
    
    
    //  NAME:   getOrderedListSingleTable()
    //  USAGE:  Return an orderd list of values from a single attribute field of a single table
    //  PARAMS: field String, table String, orderBy String
    //  RETURN: [String]?
    //  BUGS:   I don't understand why using the ? as the placeholder value doesn't work.  When attempted
    //          .executeQuery(String, [ANY]?) with the array populated will crash.  This workaround works, though.
    func getOrderedListSingleTable(field: String, table: String, orderBy: String) -> [String]? {
        var resultValues:  [String]!
        let sqlQuery = "SELECT \(field) FROM \(table) GROUP BY \(field) ORDER BY \(orderBy) ASC;"
        
        if openDatabase() {
            do {
                let results = try database.executeQuery(sqlQuery, values: nil)
                
                while results.next() {
                    if resultValues == nil {
                        resultValues = [String]()
                    }
                    
                    resultValues.append(results.string(forColumn: field)!)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
        
        return resultValues
    }
    
    
    //  NAME:   getSingleFieldSingleTable()
    //  USAGE:  Return data from a single field for a given tuple identified by the parameters
    //  PARAMS: field String, table String, compareWhat String, compareHow String, compareAgainst
    //  RETURN: String?
    //  BUGS:   None aware of at this time
    func getSingleFieldSingleTable(field: String, table: String, compareWhat: String, compareHow: String, compareAgainst: String) -> String? {
        var resultValues: [String]!
        let sqlQuery = "SELECT \(field) FROM \(table) WHERE \(compareWhat) \(compareHow) '\(compareAgainst)';"
        
        if openDatabase() {
            do {
                let result = try database.executeQuery(sqlQuery, values: nil)
                
                while result.next() {
                    if resultValues == nil {
                        resultValues = [String]()
                    }
                    
                    resultValues.append(result.string(forColumn: field)!)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
        
        return resultValues[0]
    }
    
    
    //  NAME:   getAbstractColorCount()
    //  USAGE:  Return Integer value of the number of listed abstractGrouper Colors in the Color Table of the database.  
    //          Abstract Groupers are the colors for which representative color examples are available to show to the user.
    //  PARAMS: None
    //  RETURN: Integer
    //  BUGS:   None
    func getAbstractColorCount() -> Int {
        var resultValues: [Int]!
        let sqlQuery = "SELECT COUNT(abstractGrouper) num FROM (SELECT abstractGrouper FROM Color GROUP BY abstractGrouper);"
        
        if openDatabase() {
            do {
                let result = try database.executeQuery(sqlQuery, values: nil)

                while result.next() {
                    if resultValues == nil {
                        resultValues = [Int]()
                    }
                    else {
                        return 0
                    }
                    
                    resultValues.append(Int(result.int(forColumn: "num")))
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
        
        return resultValues![0]
    }
    
    
    //  NAME:   getAbstractColorTuples()
    //  USAGE:  Return abstractGrouper & colorExample values of distinct abstractGrouper types.
    //          Abstract Groupers are the colors for which representative color examples are available to show to the user.
    //  PARAMS: None
    //  RETURN: Integer
    //  BUGS:   None
    func getAbstractColorTuples() -> [aboutColorTuple]! {
        var resultValues: [aboutColorTuple]!
        let sqlQuery = "SELECT abstractGrouper, colorExample FROM Color GROUP BY abstractGrouper ORDER BY cartesianCoord ASC;"
        
        if openDatabase() {
            do {
                let result = try database.executeQuery(sqlQuery, values: nil)
                
                while result.next() {
                    let entry = aboutColorTuple(colorImg: result.string(forColumn: "colorExample"), colorName: result.string(forColumn: "abstractGrouper"))
                    
                    if resultValues == nil {
                        resultValues = [aboutColorTuple]()
                    }
                    
                    resultValues.append(entry)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
        
        return resultValues
    }

    
    //  NAME:   buildAdHocUserSearchArrays()
    //  USAGE:  Takes a User-supplied search phrase and finds relevant values for scotch, distiller, and owners appropriate to
    //          that phrase.  Each is built into a unique array (passed in from caller) and returned to the caller.
    //          Intent is to search Top > Down (Owner to Scotch) for the search tearm, and at each level the term is found, populate
    //          the owner, distiller, and scotch arrays with data from database tuples through their foreign key linkages...
    //          For example, searching "Spey" would search all owners for that sequence, and if found populate it in the owners array, 
    //          then fill all liked distilleries into the distillery array, and all scotches linked to those distilleries into the scotch
    //          array.  Next, the phrase would be run against the distillery table, and hits there would result in population of the 
    //          distillery array, as well as linked owners and scotches... and finally, the same for the scotches.
    //  PARAMS: srchPhrase phrase: String, scotches: inout [scotch]!, distilleries: inout [distillery]!, owners: inout [owner]!
    //  RETURN: Void
    //  BUGS:   None
    func buildAdHocUserSearchArrays(srchPhrase phrase: String, scotchArray scotches: inout [scotchTuple]!, distillerArray distilleries: inout [distilleryTuple]!, ownerArray owners: inout [ownerTuple]!) {
        let UNKNOWNSCOTCH = "UNKNOWN.png"
        let UNKNOWNDISTILLER = "DALLAS_DHU.jpg"
        
        var ownerIndx = 0
        var distillerIndx = 0
        var scotchIndx = 0
        
        if openDatabase() {

            //////////////////////////
            //  OWNER Pass Here
            //////////////////////////
            do {
                //  Query OWNER table with user phrase
                let primaryOwnerSrch = userSearchOwnerStr(term: phrase)
                let ownerResult = try database.executeQuery(primaryOwnerSrch, values: nil)

                while ownerResult.next() {
                    let ownerEntry = ownerTuple(ownerName: ownerResult.string(forColumn: "commonName"), ownerImg: ownerResult.string(forColumn: "logo"))
                    
                    if owners == nil  {
                        owners = [ownerTuple]()
                    }
                    
                    owners.append(ownerEntry)
                    ownerIndx += 1
                }
                
                //  Query DISTILLER table associated with owners found matching phrase
                if owners != nil {
                    for indivOwner in owners {
                        let secondaryDistillerSrch = ownerSearchDistillerStr(term: indivOwner.ownerName)
                        let distillerFromOwner = try database.executeQuery(secondaryDistillerSrch, values: nil)
                    
                        while distillerFromOwner.next() {
                            let distillerEntry = distilleryTuple(distillerName: distillerFromOwner.string(forColumn: "name"), distillerImg: distillerFromOwner.string(forColumn: "logo"), owner: distillerFromOwner.string(forColumn: "ownership"))
                        
                            if distilleries == nil {
                                distilleries = [distilleryTuple]()
                            }
                            
                            distilleries.append(distillerEntry)
                            distillerIndx += 1
                        }
                    }
                }
                
                //  Query SCOTCH table associated with distillers found from owners matching phrase
                if distilleries != nil {
                    for indivDistiller in distilleries {
                        let secondaryScotchSrch = distillerSearchScotchStr(term: indivDistiller.distillerName)
                        let scotchFromDistiller = try database.executeQuery(secondaryScotchSrch, values: nil)
                        
                        while scotchFromDistiller.next() {
                            let scotchEntry = scotchTuple(scotchName: scotchFromDistiller.string(forColumn: "name"), scotchImg: scotchFromDistiller.string(forColumn: "label"), distiller: scotchFromDistiller.string(forColumn: "distiller"), abv: Float(scotchFromDistiller.string(forColumn: "abv")!))
                                                        
                            if scotches == nil {
                                scotches = [scotchTuple]()
                            }
                            
                            scotches.append(scotchEntry)
                            scotchIndx += 1
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            //////////////////////////
            //  DISTILLER Pass Here
            //////////////////////////
            do {
                let startDistillerIndx = distillerIndx
                let primaryDistillerSrch = userSearchDistillerStr(term: phrase)
                let distillerResult = try database.executeQuery(primaryDistillerSrch, values: nil)
                
                while distillerResult.next() {
                    let distillerEntry = distilleryTuple(distillerName: distillerResult.string(forColumn: "name"), distillerImg: distillerResult.string(forColumn: "logo"), owner: distillerResult.string(forColumn: "ownership"))
                    
                    if distilleries == nil {
                        distilleries = [distilleryTuple]()
                    }
                    
                    //  Check to see if entry is already in the array
                    var inArray = false
                    for d in distilleries {
                        if distillerEntry.distillerName == d.distillerName {
                            inArray = true
                            break
                        }
                    }
                    
                    if !inArray {
                        distilleries.append(distillerEntry)
                        distillerIndx += 1
                    }
                }
                
                //  Query OWNER table associated with distillers found from matching phrase
                if distilleries != nil && (startDistillerIndx < distillerIndx) {
                    for d in startDistillerIndx ..< distillerIndx {
                        let secondaryOwnerSrch = userSearchOwnerStr(term: distilleries[d].owner)
                        let ownerFromDistiller = try database.executeQuery(secondaryOwnerSrch, values: nil)
                        
                        while ownerFromDistiller.next() {
                            let ownerEntry = ownerTuple(ownerName: ownerFromDistiller.string(forColumn: "commonName"), ownerImg: ownerFromDistiller.string(forColumn: "logo"))
                            
                            if owners == nil {
                                owners = [ownerTuple]()
                            }
                            
                            //  Check to see if entry is already in array
                            var inArray = false
                            for o in owners {
                                if ownerEntry.ownerName == o.ownerName {
                                    inArray = true
                                    break
                                }
                            }
                            
                            if !inArray {
                                owners.append(ownerEntry)
                                ownerIndx += 1
                            }
                        }
                    }
                }
                
                //  Query SCOTCH table associated with distillers found from matching phrase
                if distilleries != nil && (startDistillerIndx < distillerIndx) {
                    for d in startDistillerIndx ..< distillerIndx {
                        let secondaryScotchSrch = distillerSearchScotchStr(term: distilleries[d].distillerName)
                        let scotchFromDistiller = try database.executeQuery(secondaryScotchSrch, values: nil)
                        
                        while scotchFromDistiller.next() {
                            let scotchEntry = scotchTuple(scotchName: scotchFromDistiller.string(forColumn: "name"), scotchImg: scotchFromDistiller.string(forColumn: "label"), distiller: scotchFromDistiller.string(forColumn: "distiller"), abv: Float(scotchFromDistiller.string(forColumn: "abv")!))
                            
                            if scotches == nil {
                                scotches = [scotchTuple]()
                            }
                            
                            //  Check to see if entry is already in array
                            var inArray = false
                            for s in scotches {
                                if scotchEntry.scotchName == s.scotchName {
                                    inArray = true
                                    break
                                }
                            }
                            
                            if !inArray {
                                scotches.append(scotchEntry)
                                scotchIndx += 1
                            }
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }

            //////////////////////////
            //  SCOTCH Pass Here
            //////////////////////////
            do {
                let startDistillerIdx = distillerIndx
                let startScotchIndx = scotchIndx
                let primaryScotchSrch = userSearchScotchStr(term: phrase)
                let scotchResult = try database.executeQuery(primaryScotchSrch, values: nil)
                
                while scotchResult.next() {
                    let scotchEntry = scotchTuple(scotchName: scotchResult.string(forColumn: "name"), scotchImg: scotchResult.string(forColumn: "label"), distiller: scotchResult.string(forColumn: "distiller"), abv: Float(scotchResult.string(forColumn: "abv")!))
                    
                    if scotches == nil {
                        scotches = [scotchTuple]()
                    }
                    
                    //  Check to see if entry is already in array
                    var inArray = false
                    for s in scotches {
                        if scotchEntry.scotchName == s.scotchName {
                            inArray = true
                            break
                        }
                    }
                    
                    if !inArray {
                        scotches.append(scotchEntry)
                        scotchIndx += 1
                    }
                }
                
                //  Query DISTILLERS table for scotches just found from matching phrase
                if scotches != nil && (startScotchIndx < scotchIndx) {
                    for s in startScotchIndx ..< scotchIndx {
                        let secondaryDistillerSearch = userSearchDistillerStr(term: scotches[s].scotchName)
                        let distillerFromScotch = try database.executeQuery(secondaryDistillerSearch, values: nil)
                        
                        while distillerFromScotch.next() {
                            let distillerEntry = distilleryTuple(distillerName: distillerFromScotch.string(forColumn: "name"), distillerImg: distillerFromScotch.string(forColumn: "logo"), owner: distillerFromScotch.string(forColumn: "ownership"))
                            
                            if distilleries == nil {
                                distilleries = [distilleryTuple]()
                            }
                            
                            //  Check to see if entry is already in array
                            var inArray = false
                            for d in distilleries {
                                if distillerEntry.distillerName == d.distillerName {
                                    inArray = true
                                    break
                                }
                            }
                            
                            if !inArray {
                                distilleries.append(distillerEntry)
                                distillerIndx += 1
                            }
                        }
                    }
                }
                
                //  Query OWNERS table for distillers of scotches just found from matching phrase
                if distilleries != nil && (startDistillerIdx < distillerIndx) {
                    for d in startDistillerIdx ..< distillerIndx {
                        let secondaryOwnerSearch = userSearchDistillerStr(term: distilleries[d].owner)
                        let ownerFromDistiller = try database.executeQuery(secondaryOwnerSearch, values: nil)
                        
                        while ownerFromDistiller.next() {
                            let ownerEntry = ownerTuple(ownerName: ownerFromDistiller.string(forColumn: "commonName"), ownerImg: ownerFromDistiller.string(forColumn: "logo"))
                            
                            if owners == nil {
                                owners = [ownerTuple]()
                            }
                            
                            //  Check to see if entry is already in array
                            var inArray = false
                            for o in owners {
                                if ownerEntry.ownerName == o.ownerName {
                                    inArray = true
                                    break
                                }
                            }
                            
                            if !inArray {
                                owners.append(ownerEntry)
                                ownerIndx += 1
                            }
                        }
                    }
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
        
            closeDatabase()
        }
        
        //////////////////////////
        //  Sort & Prep Arrays
        //////////////////////////
        if scotches != nil && scotches.count > 0 {
           //  Sort array and populate blank images
            for i in 0 ..< scotches.count {
                if scotches[i].scotchImg == nil || scotches[i].scotchImg.isEmpty {
                    scotches[i].scotchImg = UNKNOWNSCOTCH
                }
                var tmpIndx = i
                
                for j in i ..< scotches.count {
                    if scotches[j].scotchName < scotches[tmpIndx].scotchName {
                        tmpIndx = j
                    }
                }
                
                if tmpIndx != i {
                    //JDC - Compiler error w/ Swift4 & XCode9: "Overlapping accesses to 'scotches', but modification requires exclusive access; consider calling MutableCollection.swapAt(_:_:)
                    //swap(&scotches[i], &scotches[tmpIndx])
                    scotches.swapAt(i, tmpIndx)
                }
            }
        }
        
        if distilleries != nil && distilleries.count > 0 {
            //  Sort array and populate blank images
            for i in 0 ..< distilleries.count {
                if distilleries[i].distillerImg == nil || distilleries[i].distillerImg.isEmpty {
                    distilleries[i].distillerImg = UNKNOWNDISTILLER
                }
                var tmpIndx = i
                
                for j in i ..< distilleries.count {
                    if distilleries[j].distillerName < distilleries[tmpIndx].distillerName {
                        tmpIndx = j
                    }
                }
                
                if tmpIndx != i {
                    //JDC - Compiler error w/ Swift4 & XCode9: "Overlapping accesses to 'distilleries', but modification requires exclusive access; consider calling MutableCollection.swapAt(_:_:)
                    //swap(&distilleries[i], &distilleries[tmpIndx])
                    distilleries.swapAt(i, tmpIndx)
                }
            }
        }
        
        if owners != nil && owners.count > 0 {
            //  Sort array (owner table image cannot be null/nil in db)
            for i in 0 ..< owners.count {
                var tmpIndx = i
                
                for j in i ..< owners.count {
                    if owners[j].ownerName < owners[tmpIndx].ownerName {
                        tmpIndx = j
                    }
                }
                
                if tmpIndx != i {
                    //JDC - Compiler error w/ Swift4 & XCode9: "Overlapping accesses to 'owners', but modification requires exclusive access; consider calling MutableCollection.swapAt(_:_:)
                    //swap(&owners[i], &owners[tmpIndx])
                    owners.swapAt(i, tmpIndx)
                }
            }
        }
    }
    
    
    //  NAME:   userSearchOwnerStr()
    //  USAGE:  Builds an SQL Query that incorporates the passed in parameter to return data necessary 
    //          for an ownerTuple to feed UITableView from SelectScotchFromVC
    //  PARAMS: term: String
    //  RETURN: String
    //  BUGS:   None aware of at this time
    func userSearchOwnerStr(term: String) -> String {
        var srchOwnerSQL = "SELECT commonName, logo FROM Owner WHERE commonName LIKE '%"
        srchOwnerSQL += "\(term)"
        srchOwnerSQL += closeSQL
        
        return srchOwnerSQL
    }
    
    
    //  NAME:   userSearchDistillerStr()
    //  USAGE:  Builds an SQL Query that incorporates the user's search string to return data necessary
    //          for an distilleryTuple to feed UITableView from SelectScotchFromVC
    //  PARAMS: term: String
    //  RETURN: String
    //  BUGS:   None aware of at this time
    func userSearchDistillerStr(term: String) -> String {
        var srchDistillerSQL = "SELECT name, logo, ownership FROM Distiller WHERE name LIKE '%"
        srchDistillerSQL += "\(term)"
        srchDistillerSQL += closeSQL
        
        return srchDistillerSQL
    }
    
    
    //  NAME:   ownerSearchDistillerStr()
    //  USAGE:  Builds an SQL Query that incorporates the user's search string to return data necessary
    //          for an distilleryTuple to feed UITableView from SelectScotchFromVC
    //  PARAMS: term: String
    //  RETURN: String
    //  BUGS:   None aware of at this time
    func ownerSearchDistillerStr(term: String) -> String {
        var srchDistillerSQL = "SELECT name, logo, ownership FROM Distiller WHERE ownership LIKE '%"
        srchDistillerSQL += "\(term)"
        srchDistillerSQL += closeSQL
        
        return srchDistillerSQL
    }
    
    
    //  NAME:   userSearchScotchStr()
    //  USAGE:  Builds an SQL Query that incorporates the passed in parameter to return data necessary
    //          for an scotchTuple to feed UITableView from SelectScotchFromVC (minus the image, which is pulled
    //          from an associated distiller relation)
    //  PARAMS: term: String
    //  RETURN: String
    //  BUGS:   None aware of at this time
    func userSearchScotchStr(term: String) -> String {
        var srchScotchSQL = "SELECT name, abv, distiller, label FROM Scotch WHERE name LIKE '%"
        srchScotchSQL += "\(term)"
        srchScotchSQL += closeSQL
        
        return srchScotchSQL
    }
    
    
    //  NAME:   distillerSearchScotchStr()
    //  USAGE:  Builds an SQL Query that incorporates the passed in parameter to return data necessary
    //          for an scotchTuple to feed UITableView from SelectScotchFromVC (minus the image, which is pulled
    //          from an associated distiller relation)
    //  PARAMS: term: String
    //  RETURN: String
    //  BUGS:   None aware of at this time
    func distillerSearchScotchStr(term: String) -> String {
        var srchScotchSQL = "SELECT name, abv, distiller, label FROM Scotch WHERE distiller LIKE '%"
        srchScotchSQL += "\(term)"
        srchScotchSQL += closeSQL
        
        return srchScotchSQL
    }


    
    
    //  NAME:   populateScotchDetail()
    //  USAGE:  Method intended to take a parameter (scotchName) and build a FULL_SCOTCH struct, passed as an
    //          inout parameter (singleMalt)
    //  PARAMS: scotchName: String, inout singleMalt: FULL_SCOTCH()
    //  RETURN: Void
    //  BUGS:   None aware of at this time
    func populateScotchDetail(whatScotch scotchName: String, whatStruct singleMalt: inout FULL_SCOTCH!) {
        var colorData: [String]!
        var noseData: [String]!
        var bodyData: [String]!
        var palateData: [String]!
        var finishData: [String]!
        
        let scotchSQL = "SELECT distiller, age, abv, mjScore, label, proText, proAudio, region, district FROM Scotch JOIN Distiller ON (Scotch.distiller = Distiller.name) JOIN Location ON Distiller.latitude = Location.latitude AND Distiller.longitude = Location.longitude WHERE Scotch.name = '\(scotchName)';"
        
        if openDatabase() {
            do {
                //  Base data from combining Scotch, Distiller, and Location tables
                let result = try database.executeQuery(scotchSQL, values: nil)
                if result.next() {
                    singleMalt.distiller = result.string(forColumn: "distiller")
                    singleMalt.age = result.string(forColumn: "age")
                    singleMalt.abv = result.string(forColumn: "abv")
                    singleMalt.mjScore = result.string(forColumn: "mjScore")
                    singleMalt.img = result.string(forColumn: "label")
                    singleMalt.distillerPhonetic = result.string(forColumn: "proText")
                    singleMalt.pronounce = result.string(forColumn: "proAudio")
                    singleMalt.region = result.string(forColumn: "region")
                    singleMalt.district = result.string(forColumn: "district")
                }
                //  Color
                let colorSQL = "SELECT colorName, colorExample FROM Scotch_Color JOIN Color ON (colorName = name) WHERE scotchName = '\(scotchName)';"
                let colorResult = try database.executeQuery(colorSQL, values: nil)
                while colorResult.next() {
                    //  Grab a copy of the first example color along with the name
                    if singleMalt.colorExample == nil {
                        singleMalt.colorExample = colorResult.string(forColumn: "colorExample")
                    }
                    if colorData == nil {
                        colorData = [String]()
                    }
                    
                    colorData.append(colorResult.string(forColumn: "colorName")!)
                }
                if colorData != nil {
                    singleMalt.colorChars = colorData
                }
                
                //  Nose
                let noseSQL = "SELECT noseName FROM Scotch_Nose WHERE scotchName = '\(scotchName)';"
                let noseResult = try database.executeQuery(noseSQL, values: nil)
                while noseResult.next() {
                    if noseData == nil {
                        noseData = [String]()
                    }
                    
                    noseData.append(noseResult.string(forColumn: "noseName")!)
                }
                if noseData != nil {
                    singleMalt.noseChars = noseData
                }
                
                //  Body
                let bodySQL = "SELECT bodyName FROM Scotch_Body WHERE scotchName = '\(scotchName)';"
                let bodyResult = try database.executeQuery(bodySQL, values: nil)
                while bodyResult.next() {
                    if bodyData == nil {
                        bodyData = [String]()
                    }
                    
                    bodyData.append(bodyResult.string(forColumn: "bodyName")!)
                }
                if bodyData != nil {
                    singleMalt.bodyChars = bodyData
                }
                
                //  Palate
                let palateSQL = "SELECT palateName FROM Scotch_Palate WHERE scotchName = '\(scotchName)';"
                let palateResult = try database.executeQuery(palateSQL, values: nil)
                while palateResult.next() {
                    if palateData == nil {
                        palateData = [String]()
                    }
                    
                    palateData.append(palateResult.string(forColumn: "palateName")!)
                }
                if palateData != nil {
                    singleMalt.palateChars = palateData
                }
                
                //  Finish
                let finishSQL = "SELECT finishName FROM Scotch_Finish WHERE scotchName = '\(scotchName)';"
                let finishResult = try database.executeQuery(finishSQL, values: nil)
                while finishResult.next() {
                    if finishData == nil {
                        finishData = [String]()
                    }
                    
                    finishData.append(finishResult.string(forColumn: "finishName")!)
                }
                if finishData != nil {
                    singleMalt.finishChars = finishData
                }
                
                //  My Score
                let userScoreSQL = "SELECT AVG(userScore) scr FROM UserStats WHERE scotchName = '\(scotchName)'"
                let scoreResult = try database.executeQuery(userScoreSQL, values: nil)
                var avgScrStr: String!
                if scoreResult.next() {
                    avgScrStr = scoreResult.string(forColumn: "scr")
                }
                //  Cast to float to get just a single digit precision after decimal
                var avgScrFlt: Float!
                if avgScrStr != nil {
                    avgScrFlt = Float(avgScrStr!)
                    singleMalt.myScore = String(format: "%.1f", avgScrFlt)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
    }
    
    
    //  NAME:   updateScotchAvgScore()
    //  USAGE:  Method intended to take a parameter (scotchName) and build a FULL_SCOTCH struct, passed as an
    //          inout parameter (singleMalt)
    //  PARAMS: scotchName: String, inout singleMalt: FULL_SCOTCH()
    //  RETURN: Void
    //  BUGS:   None aware of at this time
    func updateScotchAvgScore(singleMalt: inout FULL_SCOTCH) {
        let userAvgSQL = "SELECT AVG(userScore) scr FROM UserStats WHERE scotchName = '\(singleMalt.name!)'"
        //  Forcing nill to refresh score if all were deleted immediately prior to calling this method
        singleMalt.myScore = nil
        
        if openDatabase() {
            do {
                let scoreResult = try database.executeQuery(userAvgSQL, values: nil)
                var avgScrStr: String!
                if scoreResult.next() {
                    avgScrStr = scoreResult.string(forColumn: "scr")
                }
                //  Cast to float to get just a single digit precision after decimal
                var avgScrFlt: Float!
                if avgScrStr != nil {
                    avgScrFlt = Float(avgScrStr!)
                    singleMalt.myScore = String(format: "%.1f", avgScrFlt)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }

    
    //  NAME:   loadUserScoring()
    //  USAGE:  Method to pull scoring data for a specific scotch out of the UserStats table
    //  PARAMS: scotchName: String, inout scoringArray: FULL_SCOTCH()
    //  RETURN: Void
    //  BUGS:   None aware of at this time
    func loadUserScoring(scotchName: String, scoringArray: inout [userScotchScoring]!) {
        if scotchName.isEmpty {
            return
        }
        let userScoreSQL = "SELECT userScore, dateTried, transID FROM UserStats WHERE scotchName = '\(scotchName)' ORDER BY dateTried;"

        if openDatabase() {
            do {
                let scoringResult = try database.executeQuery(userScoreSQL, values: nil)
                while scoringResult.next() {
                    if scoringArray == nil {
                        scoringArray = [userScotchScoring]()
                    }
                    
                    let scr = Int(scoringResult.string(forColumn: "userScore")!)
                    let dateDbl = Double(scoringResult.string(forColumn: "dateTried")!)
                    let transaction = Int(scoringResult.string(forColumn: "transID")!)
                    
                    let entry = userScotchScoring(rating: scr, date: DateHandler.shared.getDateFromSeconds(seconds: dateDbl!), transID: transaction)
                    
                    scoringArray.append(entry)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
    }
    
    
    //  NAME:   deleteUserRating()
    //  USAGE:  Accepts a userScotchScoring struct to identify a tuple to be deleted from the database
    //  PARAMS: transactionToDel: Int
    //  RETURN: Bool
    //  BUGS:   None aware of at this time
    func deleteUserRating(transactionToDel: Int) -> Bool{
        var deleted = false
        let deleteRatingSQL = "DELETE FROM UserStats WHERE transID = \(transactionToDel);"

        if openDatabase() {
            do {
                try database.executeUpdate(deleteRatingSQL, values: nil)
                deleted = true
            }
            catch {
                print(error.localizedDescription)
            }

            closeDatabase()
        }
        
        return deleted
    }
    
    //  NAME:   saveUserRating()
    //  USAGE:  Accepts a scotch name and a score from a user to add a tuple into the database
    //  PARAMS: scotchName: String, userScore: String
    //  RETURN: Bool
    //  BUGS:   None aware of at this time
    func saveUserRating(scotchName: String, userScore: String) -> Bool{
        var added = false
        let currentDateTime = DateHandler.shared.getSecondsToStore()
        let intScr = Int(userScore)!
        let addRatingSQL = "INSERT INTO UserStats (scotchName, dateTried, userScore) VALUES ('\(scotchName)', \(currentDateTime), \(intScr));"
        
        if openDatabase() {
            do {
                try database.executeUpdate(addRatingSQL, values: nil)
                added = true
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
        
        return added
    }
    
    
    //  NAME:   populateDistillerDetail()
    //  USAGE:  Method intended to take a parameter (distillerName) and populate a FULL_DISTILLER struct array, passed as an
    //          inout parameter (theDistiller)
    //  PARAMS: theDistiller: inout FULL_DISTILLER()
    //  RETURN: Void
    //  BUGS:   None aware of at this time
    func populateDistillerDetail(theDistiller: inout FULL_DISTILLER!) {
        let distillerSQL = "SELECT * FROM Distiller JOIN Location USING (latitude, longitude) WHERE name = '\(theDistiller.name!)';"

        if openDatabase() {
            do {
                let result = try database.executeQuery(distillerSQL, values: nil)
                if result.next() {
                    theDistiller.image = result.string(forColumn: "logo")
                    theDistiller.founded = result.string(forColumn: "founded")
                    theDistiller.owner = result.string(forColumn: "ownership")
                    theDistiller.proText = result.string(forColumn: "proText")
                    theDistiller.proAudio = result.string(forColumn: "proAudio")
                    theDistiller.longitude = result.double(forColumn: "longitude")
                    theDistiller.latitude = result.double(forColumn: "latitude")
                    theDistiller.region = result.string(forColumn: "region")
                    theDistiller.district = result.string(forColumn: "district")
                    theDistiller.washStillCnt = result.string(forColumn: "washStills")
                    theDistiller.spiritStillCnt = result.string(forColumn: "spiritStills")
                    theDistiller.waterSource = result.string(forColumn: "waterSource")
                    theDistiller.capacity = result.string(forColumn: "capacity")
                    theDistiller.wikipediaLink = result.string(forColumn: "wikipediaLink")
                    theDistiller.websiteLink = result.string(forColumn: "websiteURL")
                    theDistiller.gaelicMeaning = result.string(forColumn: "gaelicMeaning")
                    theDistiller.historyNotes = result.string(forColumn: "historyNotes")
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
    }
    
    
    //  NAME:   loadDistillersScotches()
    //  USAGE:  Takes a distillerName value and populates the inout String array parameter with all Single Malt Scotches associated with that distiller
    //  PARAMS: distillerName: String, listScotches: inout [String]!
    //  RETURN: Void
    //  BUGS:   None aware of at this time
    func loadDistillersScotches(distillerName: String, listScotches: inout [String]!) {
        let distillerScotchesSQL = "SELECT name FROM Scotch WHERE distiller = '\(distillerName)' ORDER BY name ASC;"
        
        if openDatabase() {
            do {
                let results = try database.executeQuery(distillerScotchesSQL, values: nil)
                while results.next() {
                    let entry = results.string(forColumn: "name")!
                    if listScotches == nil {
                        listScotches = [String]()
                    }
                    
                    listScotches.append(entry)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            closeDatabase()
        }
    }
    
    
    //  NAME:   buildDistillerArrayFromRegion()
    //  USAGE:  Method intended to take a parameter (scotchRegion) and build a distilleryTuple array matching the region
    //  PARAMS: region: String!, distillerEntries: inout [distilleryTuple]
    //  RETURN: Void
    //  BUGS:   None aware of at this time
    func populateDistillerDetail(region: String!, distillerEntries: inout [distilleryTuple]!) {
        let distillerRegionSQL = "SELECT name, ownership, logo FROM Distiller JOIN Location USING (latitude, longitude) WHERE region = '\(region!)';"
        
        if openDatabase() {
            do {
                let results = try database.executeQuery(distillerRegionSQL, values: nil)
                while results.next() {
                    let entry = distilleryTuple(distillerName: results.string(forColumn: "name"), distillerImg: results.string(forColumn: "logo"), owner: results.string(forColumn: "ownership"))
                    if distillerEntries == nil {
                        distillerEntries = [distilleryTuple]()
                    }
                    
                    distillerEntries.append(entry)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
    }
    
    
    //  NAME:   numScotchesRated()
    //  USAGE:  Method that searches the UserStats table, counts, and returns the number of unique single
    //          malt scotches sampled by the user
    //  PARAMS: NA
    //  RETURN: String!
    //  BUGS:   None
    func numScotchesRated() -> String! {
        let numScotchesSQL = "SELECT COUNT (DISTINCT scotchName) cnt FROM UserStats;"
        var numFound: String!
        
        if openDatabase() {
            do {
                let result = try database.executeQuery(numScotchesSQL, values: nil)
                if result.next() {
                    numFound = result.string(forColumn: "cnt")
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
        
        return numFound
    }
    
    
    //  NAME:   numDistilleriesSampled()
    //  USAGE:  Method that searches the UserStats table, counts, and returns the number of unique
    //          distilleries sampled by the user
    //  PARAMS: NA
    //  RETURN: String!
    //  BUGS:   None
    func numDistilleriesSampled() -> String! {
        let numDistillersSQL = "SELECT COUNT (DISTINCT distiller) cnt FROM UserStats JOIN Scotch ON (name = scotchName);"
        var numFound: String!
        
        if openDatabase() {
            do {
                let result = try database.executeQuery(numDistillersSQL, values: nil)
                if result.next() {
                    numFound = result.string(forColumn: "cnt")
                }
            }
            catch {
                print(error.localizedDescription)
            }
        
            closeDatabase()
        }
        
        return numFound
    }
    
    
    //  NAME:   numRegionsSampled()
    //  USAGE:  Method that searches the UserStats table, counts, and returns the number of unique
    //          regions sampled by the user
    //  PARAMS: NA
    //  RETURN: String!
    //  BUGS:   None
    func numRegionsSampled() -> String! {
        let numDistillersSQL = "SELECT COUNT (DISTINCT region) cnt FROM Location JOIN (Distiller JOIN (UserStats JOIN Scotch ON (Scotch.name = UserStats.scotchName)) ON (Scotch.distiller = Distiller.name)) USING (latitude, longitude);"
        var numFound: String!
        if openDatabase() {
            do {
                let result = try database.executeQuery(numDistillersSQL, values: nil)
                if result.next() {
                    numFound = result.string(forColumn: "cnt")
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
        
        return numFound
    }
    
    
    //  NAME:   mostSampledItems()
    //  USAGE:  Method that searches the UserStats table, counts, and returns the most sampled
    //          scotches, distilleries, and regions
    //  PARAMS: scotchCount: inout [pairsOfStrings]!, distillerCount: inout [pairsOfStrings]!, 
    //          regionCount: inout [pairsOfStrings]!
    //  RETURN: Void
    //  BUGS:   None
    func mostSampledItems(scotchCount: inout [pairsOfStrings]!, distillerCount: inout [pairsOfStrings]!,regionCount: inout [pairsOfStrings]!) {
        var scotchTop: Int!
        var distillerTop: Int!
        var regionTop: Int!
        
        let scotchSQL = "SELECT scotchName, COUNT(scotchName) cnt FROM UserStats GROUP BY scotchName ORDER BY cnt DESC;"
        let distillerSQL = "SELECT distiller, COUNT(scotchName) cnt FROM UserStats JOIN Scotch ON (Scotch.name = UserStats.scotchName) GROUP BY Scotch.distiller ORDER BY cnt DESC;"
        let regionSQL = "SELECT region, COUNT(scotchName) cnt FROM UserStats JOIN (Scotch JOIN (Distiller JOIN Location USING (latitude, longitude)) ON (Scotch.distiller = Distiller.name)) ON (Scotch.name = UserStats.scotchName) GROUP BY region ORDER BY cnt DESC;"
        
        if openDatabase() {
            do {
                let scotchResults = try database.executeQuery(scotchSQL, values: nil)
                while scotchResults.next() {
                    if scotchCount == nil {
                        scotchCount = [pairsOfStrings]()
                    }
                    
                    let entry = pairsOfStrings(firstStr: scotchResults.string(forColumn: "cnt"), secondStr: scotchResults.string(forColumn: "scotchName"))
                    
                    if scotchTop == nil {
                        scotchTop = Int(entry.firstStr)
                    }
                    else {
                        if Int(entry.firstStr)! < scotchTop {
                            break
                        }
                    }
                    
                    scotchCount.append(entry)
                }
                
                let distillerResults = try database.executeQuery(distillerSQL, values: nil)
                while distillerResults.next() {
                    if distillerCount == nil {
                        distillerCount = [pairsOfStrings]()
                    }
                    
                    let entry = pairsOfStrings(firstStr: distillerResults.string(forColumn: "cnt"), secondStr: distillerResults.string(forColumn: "distiller"))
                    
                    if distillerTop == nil {
                        distillerTop = Int(entry.firstStr)
                    }
                    else {
                        if Int(entry.firstStr)! < distillerTop {
                            break
                        }
                    }
                    
                    distillerCount.append(entry)
                }
                
                let regionResults = try database.executeQuery(regionSQL, values: nil)
                while regionResults.next() {
                    if regionCount == nil {
                        regionCount = [pairsOfStrings]()
                    }
                    
                    let entry = pairsOfStrings(firstStr: regionResults.string(forColumn: "cnt"), secondStr: regionResults.string(forColumn: "region"))
                    
                    if regionTop == nil {
                        regionTop = Int(entry.firstStr)
                    }
                    else {
                        if Int(entry.firstStr)! < regionTop {
                            break
                        }
                    }
                    
                    regionCount.append(entry)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
    }
    
    
    //  NAME:   populateTops()
    //  USAGE:  Method that searches the UserStats table, counts, and returns the highest rated scotch and distiller with score
    //  PARAMS: topScotch: inout pairsOfStrings!, topDistiller inout pairsOfStrings!
    //  RETURN: Void
    //  BUGS:   None
    func populateTops(topScotch: inout pairsOfStrings!, topDistiller: inout pairsOfStrings!) {
        let topScotchSQL = "SELECT scotchName, distiller, AVG(userScore) maxScore FROM UserStats JOIN Scotch ON (scotchName = name) GROUP BY name ORDER BY maxScore DESC LIMIT 1;"
        let topDistillerSQL = "SELECT distiller, ownership, AVG(userScore) maxScore FROM UserStats JOIN (Scotch JOIN Distiller ON (Scotch.distiller = Distiller.name)) ON (UserStats.scotchName = Scotch.name) GROUP BY distiller ORDER BY maxScore DESC LIMIT 1;"
        
        if openDatabase() {
            do {
                let scotchResult = try database.executeQuery(topScotchSQL, values: nil)
                if scotchResult.next() {
                    if topScotch == nil {
                        topScotch = pairsOfStrings()
                    }
                    
                    topScotch.firstStr = scotchResult.string(forColumn: "maxScore")
                    var scotchWithDistiller = scotchResult.string(forColumn: "scotchName")!
                    scotchWithDistiller += " ("
                    scotchWithDistiller += scotchResult.string(forColumn: "distiller")!
                    scotchWithDistiller += ")"
                    topScotch.secondStr = scotchWithDistiller
                }
                
                let distillerResult = try database.executeQuery(topDistillerSQL, values: nil)
                if distillerResult.next() {
                    if topDistiller == nil {
                        topDistiller = pairsOfStrings()
                    }
                    
                    topDistiller.firstStr = distillerResult.string(forColumn: "maxScore")
                    var distillerWithOwner = distillerResult.string(forColumn: "distiller")!
                    distillerWithOwner += " ("
                    distillerWithOwner += distillerResult.string(forColumn: "ownership")!
                    distillerWithOwner += ")"
                    topDistiller.secondStr = distillerWithOwner
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
    }
    
    
    
    //  NAME:   preferredPalateChar()
    //  USAGE:  Method that searches the UserStats table, counts, and returns the highest rated palate characteristics for matching
    //  PARAMS: topPalate: inout pairsOfStrings!
    //  RETURN: Void
    //  BUGS:   None
    func preferredPalateChar(topPalate: inout pairsOfStrings!) {
        let topPalateSQL = "SELECT P1.name, MAX(list.mjAvg), MAX(list.usAvg) me FROM Palate P1, (SELECT P.name, AVG(S1.mjScore) mjAvg, AVG(US.userScore) usAvg FROM Distiller D JOIN Scotch S1 ON (D.name = S1.distiller), Scotch S2 JOIN Scotch_Palate SP ON (S2.name = SP.scotchName), Scotch_Palate SP2 JOIN Palate P ON (SP2.palateName = P.name), UserStats US WHERE S1.name = S2.name AND S1.name = US.scotchName AND SP.palateName = SP2.palateName GROUP BY P.name) list;"
        
        if openDatabase() {
            do {
                let palateResult = try database.executeQuery(topPalateSQL, values: nil)
                if palateResult.next() {
                    if topPalate == nil {
                        topPalate = pairsOfStrings()
                    }
                    
                    topPalate.firstStr = palateResult.string(forColumn: "me")
                    topPalate.secondStr = palateResult.string(forColumn: "name")
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
            
            closeDatabase()
        }
    }

}
