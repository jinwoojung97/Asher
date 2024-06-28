//
//  ContentView.swift
//  Asher
//
//  Created by chuchu on 6/7/24.
//

import SwiftUI
import SwiftData

//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        if let mood = item.mood {
//                            Text(mood.emoji)
//                        }
//                    } label: {
//                        Text(item.date)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: {
//                        addItem(date: .now)
//                    }, label: {
//                        Label("Add Item", systemImage: "plus")
//                    })
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem(date: Date) {
//        let dayString = date.toDayString()
//        let fetchPredicate = #Predicate<Item> { $0.date == dayString }
//        let descriptor = FetchDescriptor(predicate: fetchPredicate)
//        do {
//            if let date = try modelContext.fetch(descriptor).first {
//                date.mood = .sad
//            } else {
//                let newItem = Item(date: dayString, mood: .happy)
//                modelContext.insert(newItem)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
