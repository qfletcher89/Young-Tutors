//
//  EventsView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 12/2/20.
//

import SwiftUI

struct EventsView: View {
    
    @EnvironmentObject var model: TutorDataModel
    
    var body: some View {
        
        GeometryReader {reader in
            
            ScrollView {
                VStack {
                    
                    if !model.events.isEmpty {
                        ForEach(model.events) {event in
                            
                            VStack(alignment: .leading) {
                                Text(getCompleteDate(date: event.time))
                                    .font(.title2)
                                    .bold()
                                    .padding(.bottom, 20)
                                
                                Text(getClassName(course: event.course))
                                    .padding(.bottom, 10)
                                
                                if event.student != "not-found" {
                                    if event.email != "not-found" {
                                        Text(event.student + " • " + event.email)
                                            .foregroundColor(Color(UIColor.secondaryLabel))
                                            .padding(.bottom, 20)
                                    } else {
                                        Text(event.student)
                                            .foregroundColor(Color(UIColor.secondaryLabel))
                                            .padding(.bottom, 20)
                                    }
                                }
                                
                                
                                HStack {
                                    
                                    
                                    Button {
                                        print("cancel event")
                                        //cancel
                                    } label: {
                                        
                                        Text("Cancel")
                                            .fontWeight(.semibold)
                                            //                                    .foregroundColor(Color(UIColor.label))
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 40)
                                            .background(RoundedRectangle(cornerRadius: 30)
                                                            .stroke()
                                                        //                                                    .foregroundColor(Color(UIColor.label)))
                                            )
                                        
                                    }.accentColor(Color(UIColor.label))
                                    
                                    Spacer()
                                    
                                    Button {
                                          
                                        if event.email != "not-found" {
                                            let url = URL(string: "mailto:\(event.email)")
                                            
                                            UIApplication.shared.open(url!) { (result) in
                                                if result {
                                                   print("successful")
                                                }
                                            }
                                        }
                                    } label: {
                                        Text("Email")
                                            .fontWeight(.semibold)
                                            .foregroundColor(event.email == "not-found" ? Color(UIColor.quaternaryLabel) : .white)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 40)
                                            .background(RoundedRectangle(cornerRadius: 30)
                                                            .foregroundColor(event.email != "not-found" ? self.cs().watermelon  : Color(UIColor.quaternarySystemFill)))
                                    }
                                    
                                }
                                
                            }.padding(.vertical, 30)
                            .padding(.horizontal, 30)
                            .frame(width: reader.size.width - 30, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 30)
                                            .foregroundColor(Color(UIColor.secondarySystemBackground)))
                            .padding(.vertical, 15)
                        }
                    } else {
                        Text("You don't have any sessions yet...\nTo get started, go make one now!")
                            .fontWeight(.semibold)
                            .italic()
                            .lineSpacing(2.0)
                            .font(.title2)
                            
                    }
                    
                }
            }
            .customNavBar(proxy: reader,
                          title: "Upcoming Sessions", nil,
                          Button(action: {
                            model.getBookedTimes()
                          }, label: {
                            AnyView(Image("reload"))
                          }))
            
            
            
        }
        
        
    }
}

extension EventsView {
    
    func getCompleteDate(date: String) -> String {
        
        let day = date[0]
        let time = date.substring(fromIndex: 1)
        
        let formattedDay = Calendar.current.weekdaySymbols[Int(day)! - 1]
        
        let hour = time[0]
        let minute = time.substring(fromIndex: 1)
        
        let formattedTime = hour + ":" + minute
        
        let formattedDate = formattedDay + " - " + formattedTime
        return formattedDate
        
    }
    
    func getClassName(course: String) -> String {
        
        let id = course.split(separator: "-").last!
        
        if id.starts(with: "RH") {
            
            let name = id.replacingOccurrences(of: "RH", with: "")
            
            return name.capitalized
            
        } else if id.starts(with: "AP") {
            
            let name = id.replacingOccurrences(of: "AP", with: "")
            
            return name.capitalized
            
        } else if id.starts(with: "H") {
            
            let name = id.replacingOccurrences(of: "H", with: "")
            
            return name.capitalized
        } else if id.starts(with: "KAMI") {
            
            let name = id.replacingOccurrences(of: "KAMI", with: "")
            
            return name.capitalized
        } else if id.starts(with: "KAMII") {
            
            let name = id.replacingOccurrences(of: "KAMII", with: "")
            
            return name.capitalized
        } else {
            return String(id)
        }
        
    }
}
