//
//  Dictionary.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 12/12/21.
//

import SwiftUI
import CoreData


/// A view that represents the Dictionary page in the application.
struct Dictionary: View {

    /// The managed object context from the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    /// The horizontal size class of the app: either compact or standard.
    /// This is used to determine whether the device is in landscape or if running on iPadOS and/or macOS.
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// The fetch request that stores the saved sniglets.
    @FetchRequest(
        entity: SavedWord.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \SavedWord.word, ascending: true)
        ]
    )
    var words: FetchedResults<SavedWord>

    /// The search query that will be used to filter the request results.
    @State private var searchQuery: String = ""

    /// The primary body for the view.
    var body: some View {
        NavigationView {
            Group {
                if words.isEmpty {
                    if horizontalSizeClass == .compact {
                        emptyView
                    } else {
                        EmptyView()
                    }
                }
                else { dictionaryList }
            }
            .navigationTitle("saved.title.long")

            if words.isEmpty && horizontalSizeClass == .regular { emptyView }
            else if horizontalSizeClass == .regular {
                VStack {
                    Image(systemName: "character.book.closed")
                        .font(.system(size: 56))
                        .foregroundColor(.secondary)
                    Text("saved.select.prompt")
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    /// The view to display when there are no saved sniglets.
    var emptyView: some View {
        VStack(spacing: 4) {
            Image(systemName: "character.book.closed")
                .font(.system(size: 56))
            Text("saved.empty.title")
                .font(.title)
            Text("saved.empty.prompt")
        }
        .foregroundColor(.secondary)
        .padding()
    }

    /// The list of saved sniglets in the database.
    var dictionaryList: some View {
        List {
            ForEach(filteredWords(), id: \.self) { word in
                DictionaryLink(entry: word)
            }
            .onDelete(perform: removeEntries)
        }
        .searchable(text: $searchQuery)
        .toolbar {
            EditButton()
        }
    }

    /// Remove entries from the database at the specified offsets.
    /// This is used to handle delete gestures when the list is in editing mode.
    func removeEntries(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                managedObjectContext.delete(words[index])
            }
            DBController.shared.save()
        }
    }

    /// Returns a list of saved sniglets that contain the search query text.
    /// This is needed to get the search functionality working.
    func filteredWords() -> [SavedWord] {
        if searchQuery.isEmpty { return words.map { entry in entry } }
        return words.filter { entry in
            entry.word?.contains(searchQuery.lowercased()) == true
        }
    }
}

/// A view that represents a link in the dictionary list.
struct DictionaryLink: View {

    /// The managed object context from the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    /// The corresponding entry this link works with.
    @State var entry: SavedWord

    var body: some View {
        NavigationLink(destination: DictionaryEntryView(entry: entry)) {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.word ?? "")
                    .font(.system(.title2, design: .serif))
                    .bold()
                Text("Confidence: \(entry.confidence.asPercentage())%")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical)
        }
        .contextMenu {
            Button {
                entry.word!.speak()
            } label: {
                Label("sound.button.prompt", systemImage: "speaker.wave.3")
            }
            Button {
                withAnimation {
                    managedObjectContext.delete(entry)
                    DBController.shared.save()
                }
            } label: {
                Label("Delete...", systemImage: "trash")
            }
        }
    }
}


struct Dictionary_Previews: PreviewProvider {
    static let previewCtx = DBController.preview

    static var previews: some View {
        Group {
            Dictionary()
                .environment(\.managedObjectContext, previewCtx.container.viewContext)
                .previewDevice("iPhone 13")
        }

    }
}
