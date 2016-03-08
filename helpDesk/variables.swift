//
//  variables.swift
//  helpDesk
//
//  Created by Wybren Oppedijk on 25-02-16.
//  Copyright © 2016 Amerion IT. All rights reserved.
//

import Foundation

// MARK: Database URL variables
public let loginURL:String! = "https://www.amerion.nl/app/api/getLogin.php"
public let messageURL:String! = "https://www.amerion.nl/app/api/getData.php"

// MARK: Alert message variables
public let errorTitle:String! = "Inloggen mislukt"
public let errorMessages:[String] = ["Vul a.u.b. een gebruikersnaam en wachtwoord in.", "Er heeft zich een onbekende fout opgetreden.", "Er heeft zich een fout opgetreden. Heeft u een werkende internetverbinding?"]
public let savePasswordTitle = "Wachtwoord onthouden"
public let savePasswordMessage = "Wilt u uw gebruikersnaam en wachtwoord opslaan? De app zal dan automatisch inloggen wanneer deze wordt geopend."
public let registerTitle:String! = "Registreren"
public let registerMessage:String! = "Neem contact op met Amerion IT om te registreren."
public let changePasswordTitle:String! = "Wachtwoord wijzigen"
public let changePasswordMessage:String! = "Neem contact op met Amerion IT om uw wachtwoord te wijzigen."
public let deleteDataTitle:String! = "Gebruikersdata wissen"
public let deleteDataQuestionMessage:String! = "Weet u zeker dat u wilt uitloggen en alle gebruikersdata wissen?"
public let deleteDataYesMessage:String! = "Alle gebruikersdata op dit toestel is gewist en u bent uitgelogd."

// MARK: Cache variables
public let defaultData:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
public let dataUsername:String! = "Username"
public let dataPassword:String! = "Password"
public let dataCredentialsSaved:String! = "hasCredentialsSaved"
public let dataCompany:String! = "Company"
public let dataUser:String! = "ID"
public let dataOccupation:String! = "Occupation"
public let dataSystem:String! = "System"
public let dataMessages:String! = "Messages"
public let dataMessageToDisplay:String! = "MessageToDisplay"
public let dataMessagesDeleted:String! = "doesDeleteMessages"

// MARK: JSON Response constants (DO NOT CHANGE UNLESS CHANGED IN PHP)
public let responseCompany:String! = "company"
public let responseUser:String! = "id"
public let responseOccupation:String! = "occupation"
public let responseSystem:String! = "system"
public let responseError:String! = "error_message"
public let responseMessages:String! = "messages"
public let responseTitle:String! = "title"
public let responseMessage:String! = "message"

// MARK: Request constants (DO NOT CHANGE UNLESS CHANGED IN PHP)
public let requestUsername:String! = "username"
public let requestPassword:String! = "password"
public let requestCompany:String! = "companyID"
public let requestUser:String! = "userID"
public let requestOccupation:String! = "occupationID"
public let requestSystem:String! = "systemID"

// MARK: Segue name and entry point variables
public let gotoProtected:String! = "goto_protected"
public let gotoInbox:String! = "goto_messages"
public let entryProtected:String! = "protectedEntryPoint"
public let entryUnprotected:String! = "unprotectedEntryPoint"

//MARK: Functions
public func saveData(username:AnyObject, password:AnyObject, company:AnyObject, user:AnyObject, occupation:AnyObject, system:AnyObject) -> Void {
    defaultData.setValue(username, forKey: dataUsername)
    defaultData.setValue(password, forKey: dataPassword)
    
    defaultData.setValue(company, forKey: dataCompany)
    defaultData.setValue(user, forKey: dataUser)
    defaultData.setValue(occupation, forKey: dataOccupation)
    defaultData.setValue(system, forKey: dataSystem)
    
    defaultData.synchronize()
}

public func deleteData() -> Void {
    for key in Array(defaultData.dictionaryRepresentation().keys) {
        defaultData.removeObjectForKey(key)
    }
}
