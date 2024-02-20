//
//  ContentView.swift
//  ToDoList
//
//  Created by gokulparmar on 16/02/24.
//

import SwiftUI

struct Task: Identifiable {
    var name: String
    var isDone: Bool = false
    var isSwiped: Bool = false
    let id = UUID()
}
struct TaskView: View {
    @Binding var task: Task
    
    var body: some View {
        HStack {
                Text(task.name)
                Spacer()
                if task.isDone {
                    Image(systemName: "checkmark.square")
                        .foregroundStyle(.green, .green)
                }
                else{
                    Image(systemName: "square")

                }
        }
        .cornerRadius(3)
        .onTapGesture {
            task.isDone.toggle()
        }
    }
}
struct ContentView: View {
    @State var datas = [Task]()
    @State private var newTask: String = ""
    @State private var isRowSwiped = [Bool]()
    
        var body: some View {
            NavigationView{
                
                VStack(alignment: .leading){
                    Spacer()
                    Text("TASK")
                        .font(.system(size: 18))
                        .padding(.leading,20)
                        .foregroundColor(.black)
                        .opacity(0.6)
                        .bold()
                    Spacer()
                    List  {
                        ForEach(datas.indices, id: \.self) { index in
                                    let task = datas[index]
                                    let isSwiped = isRowSwiped[index]
                                                
                                    TaskView(task: $datas[index])
                                    .swipeActions(edge: .trailing ,allowsFullSwipe: true) {
                                        
                                        Button("Delete"){
                                            if let index = datas.firstIndex(where: { $0.id == datas[index].id }) {
                                                    datas.remove(at: index)
                                                    isRowSwiped.remove(at: index)
                                            }
                                        }
                                        .tint(.red)
                                    }
                                .listRowBackground(isSwiped ? Color.red.opacity(0.3) : Color.white)
                                .listRowSpacing(10)
                                .cornerRadius(6)
                                .onAppear {
                                        if isRowSwiped.count <= index {
                                            isRowSwiped.append(false) // Initialize isRowSwiped array with false values
                                        }
                                }
                                .onChange(of: isRowSwiped[index]) { newValue in
                                            datas[index].isSwiped = newValue // Update Task's isSwiped property
                                }
                                
                            }
                        .onDelete(perform: delete)
                        }
                        .padding(.horizontal)
                        .listStyle(.plain)
                        .cornerRadius(10)
                        .navigationTitle("📝 To-Do List")
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            EditButton()
                        }
                    }
                    HStack{
                        Spacer()
                        TextField("New Task",text:$newTask)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.vertical,10)
                        Button("Add") {
                            
                            if newTask.count != 0 {
                                self.datas.append(Task(name: newTask , isDone: false))
                                self.isRowSwiped.append(false)
                            }
                            newTask = ""
                        }
                        .padding(.horizontal)
                        
                    }
                    .background(Color.white)
                }
                .background(Color.gray.opacity(0.3))
                
            }
            
            
        }
    
    func delete(at offsets: IndexSet) {
            datas.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
