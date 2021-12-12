//
//  Dictionary.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 12/12/21.
//

import SwiftUI
import CoreData

struct Dictionary: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: SavedWord.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \SavedWord.word, ascending: true)
        ]
    ) var words: FetchedResults<SavedWord>

    @State private var searchQuery: String = ""

    var body: some View {
        NavigationView {
            Group {
                if words.isEmpty { emptyView }
                else { dictionaryList }
            }
            .navigationTitle("saved.title.long")
        }
    }

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

    var dictionaryList: some View {
        List {
            ForEach(filteredWords(), id: \.self) { word in
                NavigationLink(destination: DictionaryEntryView(entry: word)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(word.word ?? "")
                            .font(.system(.title2, design: .serif))
                            .bold()
                        Text("Confidence: \(word.confidence.asPercentage())%")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical)
                }
            }
            .onDelete(perform: removeEntries)
        }
        .searchable(text: $searchQuery)
        .toolbar {
            EditButton()
        }
    }

    func removeEntries(at offsets: IndexSet) {
        for index in offsets {
            managedObjectContext.delete(words[index])
        }
        DBController.shared.save()
    }

    func filteredWords() -> [SavedWord] {
        if searchQuery.isEmpty { return words.map { entry in entry } }
        return words.filter { entry in
            entry.word?.contains(searchQuery.lowercased()) == true
        }
    }
}

struct DictionaryEntryView: View {
    @AppStorage("allowClipboard") var tapToCopy: Bool = true
    @ObservedObject var entry: SavedWord
    @State var showDetails: Bool = false
    @State var definition: String = ""

    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    if tapToCopy {
                        Button(action: { UIPasteboard.general.string = entry.word ?? "" }) {
                            GeneratorResultText(word: entry.word ?? "")
                                .listRowSeparator(.hidden, edges: .bottom)
                        }
                        .buttonStyle(.plain)
                        Text("generator.copy.prompt")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    } else {
                        GeneratorResultText(word: entry.word ?? "")
                            .listRowSeparator(.hidden, edges: .bottom)
                    }
                    GeneratorConfidence(confidence: entry.confidence) {
                        showDetails.toggle()
                    }
                }
            }
            .listRowInsets(.init(top: 16, leading: 0, bottom: 16, trailing: 0))
            .listRowBackground(Color.secondary.opacity(0))

            Section("Definition") {
                TextEditor(text: $definition)
                    .font(.system(.body, design: .serif))
                    .lineSpacing(1.5)
            }
        }
        .navigationTitle("saved.detail.title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !tapToCopy {
                Button(action: { UIPasteboard.general.string = entry.word ?? "" }) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
            }
        }
        .onAppear { definition = entry.note ?? "" }
        .onChange(of: definition) { _ in
            entry.note = definition
            DBController.shared.save()
        }
        .sheet(isPresented: $showDetails) {
            GeneratorExplanation {
                showDetails.toggle()
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
            NavigationView {
                DictionaryEntryView(entry: previewCtx.singleEntry())
            }
            .previewDevice("iPhone 13")
        }

    }
}
