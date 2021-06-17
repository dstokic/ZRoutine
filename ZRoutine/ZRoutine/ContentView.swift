//
//  ContentView.swift
//  ZRoutine
//
//  Created by Daniella Stokic on 1/25/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Activity.entity(), sortDescriptors: [])

    var activities: FetchedResults<Activity>
    
    @State var showActivitySheet = false
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(activities) { activity in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(activity.toDoItem!)")
                                .font(.headline)
                            Text("\(activity.descrip!)")
                                .font(.subheadline)
                        }
                        
                        NavigationLink(destination: SecondView(title: "\(activity.toDoItem!)", description: "\(activity.descrip!)")) {
                        }
                        
                    }.frame(height: 50)
                    
                }.onDelete { indexSet in
                        for index in indexSet {
                            viewContext.delete(activities[index])
                        }
                        do {
                            try viewContext.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }

            }.foregroundColor(.accentColor)
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("My Night Routine")
            .navigationBarItems(trailing: Button(action: {
                    showActivitySheet = true
                }, label: {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                }))
                .sheet(isPresented: $showActivitySheet) {
                    ActivitySheet()
                }
        }.foregroundColor(.purple)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}





struct ActivitySheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode

        
    //@State var time = Date()
    @State var descrip = "Enter description..."
    @State var toDoItem = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Activity Details")) {
                    
                    TextField("Enter activity...", text: $toDoItem)
                    }
                    
                
                Section(header: Text("")) {
                    TextEditor(text: $descrip)
                    
                }
                
                Button(action: {
                    let newActivity = Activity(context: viewContext)
                    newActivity.toDoItem = self.toDoItem
                    newActivity.descrip = self.descrip
                    newActivity.id = UUID()
                    
                    do {
                        try viewContext.save()
                        print("Activity saved.")
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                }) {
                    Text("Add Activity")
                }.accentColor(.purple)
            }
                .navigationTitle("Add Activity")
        }.foregroundColor(.accentColor)
    }
}

struct ActivitySheet_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySheet()
    }
}



struct SecondView: View {
    @State var title: String
    @State var description: String
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    @FetchRequest(entity: Activity.entity(), sortDescriptors: [])
    var activities: FetchedResults<Activity>
    
    var body: some View {
        List {
            TextEditor(text: $title)
            TextEditor(text: $description)
            
        }.foregroundColor(.accentColor)
        
    }
}

/*
struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView(description: $truth)
    }
}
 */

