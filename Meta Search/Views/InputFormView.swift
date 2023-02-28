//
//  InputFormView.swift
//  Meta Search
//
//  Created by Timo Wesselmann on 19.02.23.
//

import SwiftUI

struct InputFormView: View {
    @EnvironmentObject var fileListVM: FileListViewModel
    var body: some View {
        VStack {
            HStack {
                TextField("Name", text: $fileListVM.searchName)
                Toggle("Fuzzy Search", isOn: $fileListVM.isFuzzyName)
            }
            TextField("Extension", text: $fileListVM.searchExtension)
            TextField("Owner", text: $fileListVM.searchOwner)
            VStack(alignment: .leading) {
                Text("Size").font(.headline)
                HStack {
                    TextField("Min", text: $fileListVM.searchSizeStart)
                    Picker(selection: $fileListVM.selectedUnitMin) {
                        ForEach(SizeUnits.allCases) {
                            Text($0.rawValue.uppercased())
                        }
                    } label: {
                        EmptyView()
                    }
                    .frame(minWidth: 0, maxWidth: 50)
                    TextField("Max", text: $fileListVM.searchSizeEnd)
                    Picker(selection: $fileListVM.selectedUnitMax) {
                        ForEach(SizeUnits.allCases) {
                            Text($0.rawValue.uppercased())
                        }
                    } label: {
                        EmptyView()
                    }
                    .frame(minWidth: 0, maxWidth: 50)
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("Creation Date").font(.headline)
                    Toggle("", isOn: $fileListVM.checkCreationDate.animation())
                    Spacer()
                }
                if fileListVM.checkCreationDate {
                    VStack {
                        HStack {
                            DatePicker(
                                "From",
                                selection: $fileListVM.creationDateStart.animation(),
                                displayedComponents: [.date]
                            )
                            DatePicker(
                                "To",
                                selection: $fileListVM.creationDateEnd.animation(),
                                displayedComponents: [.date]
                            )
                        }
                        if fileListVM.creationDateStart >= fileListVM.creationDateEnd {
                            Text("'From' Date must be smaller than 'To' Date. Option will be discarded.").font(.footnote)
                        }
                    }
                }
            }
            .padding(.vertical)
            
            VStack(alignment: .leading) {
                HStack() {
                    Text("Modification Date").font(.headline)
                    Toggle("", isOn: $fileListVM.checkModificationDate.animation())
                    Spacer()
                }
                if fileListVM.checkModificationDate {
                    VStack {
                        HStack {
                            DatePicker(
                                "From",
                                selection: $fileListVM.modificationDateStart.animation(),
                                displayedComponents: [.date]
                            )
                            DatePicker(
                                "To",
                                selection: $fileListVM.modificationDateEnd.animation(),
                                displayedComponents: [.date]
                            )
                        }
                        if fileListVM.modificationDateStart >= fileListVM.modificationDateEnd {
                            Text("'From' Date must be smaller than 'To' Date. Option will be discarded.").font(.footnote)
                        }
                    }
                }
            }
        }
    }
}

struct InputFormView_Previews: PreviewProvider {
    static var previews: some View {
        InputFormView()
            .environmentObject(FileListViewModel.example)
    }
}
