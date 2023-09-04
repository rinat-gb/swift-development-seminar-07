//
//  FileCache.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

import CoreData
import Foundation

final class FileCache {
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                print(error)
            }
        })
        return persistentContainer
    }()

    func putFriendDate() {
        let date = FriendDateCoreData(context: persistentContainer.viewContext)
        date.date = Date()
    }

    func getFriendDate() -> Date? {
        let fetchRequest: NSFetchRequest<FriendDateCoreData> = FriendDateCoreData.fetchRequest()
        guard let data = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            return nil
        }
        return data.first?.date
    }

    func putFriends(friends: [Friend]) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendModelCoreData")
        for friend in friends {
            fetchRequest.predicate = NSPredicate(format: "id = %@", argumentArray: [friend.id])
            let result = try? persistentContainer.viewContext.fetch(fetchRequest)
            guard result?.first == nil else {
                continue
            }
            let friendModel = FriendModelCoreData(context: persistentContainer.viewContext)
            friendModel.id = Int64(friend.id)
            friendModel.online = Int16(friend.online)
            friendModel.firstName = friend.firstName
            friendModel.lastName = friend.lastName
            friendModel.photo = friend.photo
        }
        putFriendDate()
        flushCache()
    }

    func getFriends() -> FriendsModel? {
        let fetchRequest: NSFetchRequest<FriendModelCoreData> = FriendModelCoreData.fetchRequest()
        guard let friends = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            return nil
        }
        var newFriends: [Friend] = []
        for friend in friends {
            newFriends.append(Friend(
                id: Int(friend.id),
                online: Int8(friend.online),
                firstName: friend.firstName ?? "",
                lastName: friend.lastName ?? "",
                photo: friend.photo
            ))
        }
        let newModel = FriendsModel(response: FriendsResponse(count: newFriends.count, items: newFriends))
        return newModel
    }

    func putGroupDate() {
        let date = GroupDateCoreData(context: persistentContainer.viewContext)
        date.date = Date()
    }

    func getGroupDate() -> Date? {
        let fetchRequest: NSFetchRequest<GroupDateCoreData> = GroupDateCoreData.fetchRequest()
        guard let data = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            return nil
        }
        return data.first?.date
    }

    func putGroups(groups: [Group]) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GroupModelCoreData")
        for group in groups {
            fetchRequest.predicate = NSPredicate(format: "id = %@", argumentArray: [group.id])
            let result = try? persistentContainer.viewContext.fetch(fetchRequest)
            guard result?.first == nil else {
                continue
            }
            let groupModel = GroupModelCoreData(context: persistentContainer.viewContext)
            groupModel.id = Int64(group.id)
            groupModel.name = group.name
            groupModel.caption = group.description
            groupModel.photo = group.photo
        }
        putGroupDate()
        flushCache()
    }

    func getGroups() -> GroupsModel? {
        let fetchRequest: NSFetchRequest<GroupModelCoreData> = GroupModelCoreData.fetchRequest()
        guard let groups = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            return nil
        }
        var newGroups: [Group] = []
        for group in groups {
            newGroups.append(Group(
                id: Int(group.id),
                name: group.name ?? "",
                description: group.caption ?? "",
                photo: group.photo ?? ""
            ))
        }
        let newModel = GroupsModel(response: GroupsResponse(count: newGroups.count, items: newGroups))
        return newModel
    }

    private func flushCache() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                print(error)
            }
        }
    }
}
