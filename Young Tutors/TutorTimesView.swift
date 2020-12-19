//
//  TutorTimesView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/27/20.
//

import SwiftUI

struct TutorTimesView: View {
    
    @Environment (\.self.presentationMode) var presentationMode
    @State var deletedTimes = [String]()
    @State var addedTimes = [String]()
    @EnvironmentObject var model: TutorDataModel
    
    var possibleTimes = ["330",
                         "400",
                         "430",
                         "500",
                         "530",
                         "600",
                         "630",
                         "700",
                         "730"]
    
    
    var body: some View {
        
        GeometryReader {reader in
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("Select times that you wish to tutor for each day.")
                        .font(.footnote)
                    
                    ForEach(1..<8) {day in
                        HStack {
                            Text(Calendar.current.weekdaySymbols[day - 1])
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            Spacer()
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(possibleTimes, id:\.self) {time in
                                    if model.times.contains("\(day)"+time) {
                                        TimeSelector(addedTimes: $addedTimes,
                                                     deletedTimes: $deletedTimes,
                                                     selection: true,
                                                     initalSelection: true,
                                                     time: "\(day)\(time)",
                                                     isDisabled: timeIsBooked(time: "\(day)\(time)"))
                                    } else {
                                        TimeSelector(addedTimes: $addedTimes,
                                                     deletedTimes: $deletedTimes,
                                                     selection: false,
                                                     initalSelection: false,
                                                     time: "\(day)\(time)",
                                                     isDisabled: timeIsBooked(time: "\(day)\(time)"))
                                    }
                                }
                            }.padding(.vertical, 5)
                            .padding(.horizontal)
                        }
                    }
                }
            }.padding(.vertical)
            .onAppear {
                model.getBookedTimes()
            }
            .customNavBar(proxy: reader,
                           title: "Times",
                           Button(action: {
                            model.saveTimes(times: addedTimes)
                            model.removeTimes(times: deletedTimes)
                            model.getData()
                            self.presentationMode.wrappedValue.dismiss()
                           }, label: {
                            AnyView(
                                HStack(spacing: 0) {
                                    Image("left")
                                    Text("Save")
                                        .foregroundColor(self.cs().watermelon)
                                }
                            )
                           }), Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                           }, label: {
                            AnyView(Text("Cancel")
                                        .foregroundColor(self.cs().watermelon))
                           }))
        }
    }
    
    func timeIsBooked(time: String) -> Bool {
        
        var isBooked = false
        
        for event in model.events {
            print(time)
            print(event.time)
            if event.time == time {
                isBooked = true
            }
        }
        
        return isBooked
        
    }
    
}

struct TimeSelector: View {
    
    @Binding var addedTimes: [String]
    @Binding var deletedTimes: [String]
    @State var selection: Bool
    var initalSelection: Bool
    var time: String
    var isDisabled: Bool
    
    var body: some View {
        
        Button {
            self.selection.toggle()
            update()
        } label: {
            
            if !isDisabled {
                
                HStack {
                    
                    Text(formatTime())
                        .foregroundColor(selection ? Color(UIColor.systemBackground) : self.cs().watermelon)
                        
                    Image("check-plain")
                        .renderingMode(.template)
                        .foregroundColor(selection ? Color(UIColor.systemBackground) : self.cs().watermelon)
                    
                }.padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(selection ?
                    AnyView(RoundedRectangle(cornerRadius: 30).foregroundColor(self.cs().watermelon)) :
                                AnyView(RoundedRectangle(cornerRadius: 30).stroke(lineWidth: 2).foregroundColor(self.cs().watermelon)))
                
            } else {
                
                HStack {
                    
                    Text(formatTime())
                        .foregroundColor(selection ? Color(UIColor.systemBackground) : Color(UIColor.quaternaryLabel))
                        
                    Image("check-plain")
                        .renderingMode(.template)
                        .foregroundColor(selection ? Color(UIColor.systemBackground) : Color(UIColor.quaternaryLabel))
                    
                }.padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(selection ?
                    AnyView(RoundedRectangle(cornerRadius: 30).foregroundColor(Color(UIColor.quaternaryLabel))) :
                                AnyView(RoundedRectangle(cornerRadius: 30).stroke(lineWidth: 2).foregroundColor(Color(UIColor.quaternaryLabel))))
                
            }
            
            

        }.disabled(isDisabled)
    }
    
    
    
    func formatTime() -> String {
        
        let funcTime = time.substring(fromIndex: 1)
        let time1 = funcTime[0]
        let time2 = funcTime.substring(fromIndex: 1)
        
        let formattedTime = time1 + ":" + time2
        return formattedTime
        
    }
}

extension TimeSelector {
    
    func update() {
        print("update was called")
        if initalSelection == true {
            //it was orignally set to true
            print("original selection was true")
            if selection == initalSelection {
                
                if let index = deletedTimes.firstIndex(of: time) {
                    deletedTimes.remove(at: index)
                }
                
            } else {
                //else if it wasn't different, then remove it from the removed
                print("selection was the same as the original")
                //if the new value is difffernt than the original, it is not in any array. that means that we can add it to the removed.
                
                deletedTimes.append(time)
            }
            
        } else {
            //it was orignally set to true
            print("original selection was not true")
            if selection == initalSelection {
                
                if let index = addedTimes.firstIndex(of: time) {
                    addedTimes.remove(at: index)
                }
                
            } else {
                //else if it wasn't different, then remove it from the removed
                print("selection was the same as the original")
                //if the new value is difffernt than the original, it is not in any array. that means that we can add it to the removed.
                
                addedTimes.append(time)
            }
        }
    }
}

//have the times disabled if they've already been booked then
//when I set or remove an avaiable time, inject or take out those times from all the classes. Also update to our object in tutors firebase
//in this veiw did appear, we do a call to get all the events.
//do NOT have multiple views for each day. Have each seperated in its own SPACED OUT scroll view, where you arrange it. You save when you exit. The back button is intentionally called SAVE. You can also have a cancel button to the top right of your custom nav bar and it will say cancel.
//keep a list of all the classes that you've deselected and selected. When you hit the save button, put all the newly selected ones into the save function, and the deselected ones into the delete function
