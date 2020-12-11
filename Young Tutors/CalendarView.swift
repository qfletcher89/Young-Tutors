//
//  CalendarView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/25/20.
//

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject var model: StudentModel
    @ObservedObject var tutorsModel: TutorsModel
    @State var detailTutor = Tutor(id: "not-found", grade: nil, email: nil, bio: nil, awards: nil, strengths: nil, pronouns: nil, gradient: "watermelon-magenta", times: nil, classes: nil)
    @State var tutorIsPresented = false
    @State var upcomingSelected = true
    
    var body: some View {
        
        GeometryReader {reader in
            
            ScrollView{
                VStack {
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation{
                                upcomingSelected = true
                            }
                            
                        }, label: {
                            Text("Upcoming")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(self.cs().watermelon)
                        })
                        .opacity(0.75)
                        .frame(width: reader.size.width * 0.45)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                upcomingSelected = false
                            }
                            
                        }, label: {
                            Text("Past")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(self.cs().watermelon)
                        })
                        .opacity(0.75)
                        .frame(width: reader.size.width * 0.45)
                        
                        Spacer()
                        
                    }.padding(.top)
                    
                    HStack {
                        if !upcomingSelected {
                            Spacer()
                        }
                        Rectangle()
                            .frame(width: reader.size.width * 0.45, height: 2)
                            .foregroundColor(self.cs().watermelon)
                        if upcomingSelected {
                            Spacer()
                        }
                        
                    }.padding([.horizontal, .bottom])
                    
                    if upcomingSelected {
                        
                        VStack {
                            
                            if !decideData().isEmpty {
                                ForEach(decideData()) {event in
                                    
                                    VStack(alignment: .leading) {
                                        Text(getCompleteDate(date: event.time))
                                            .font(.title2)
                                            .bold()
                                            .padding(.bottom, 20)
                                        
                                        Text(getClassName(course: event.course))
                                            .padding(.bottom, 10)
                                        
                                        if !tutorsModel.tutors.isEmpty {
                                            if let tutor = getTutorObjectFor(teacher: event.tutor) {
                                                if let email = tutor.email {
                                                    Text(event.tutor + " • " + email)
                                                        .foregroundColor(Color(UIColor.secondaryLabel))
                                                        .padding(.bottom, 20)
                                                } else {
                                                    Text(event.tutor)
                                                        .foregroundColor(Color(UIColor.secondaryLabel))
                                                        .padding(.bottom, 20)
                                                }
                                            } else {
                                                Text(event.tutor)
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
                                                self.detailTutor = getTutorObjectFor(teacher: event.tutor)
                                                
                                                self.tutorIsPresented = true
                                                
                                            } label: {
                                                
                                                Text("View Profile")
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal, 40)
                                                    .background(RoundedRectangle(cornerRadius: 30)
                                                                    .foregroundColor(self.cs().watermelon))
                                                
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
                                Text("You don't have any sessions yet!\nTo get started, go make one now!")
                                    .italic()
                            }
                            
                            
                        }.background(Text(String(detailTutor.id)).foregroundColor(.clear))
                        .sheet(isPresented: $tutorIsPresented) {
                            TutorDetailView(tutor: self.detailTutor, isFromModal: true)
                        }
                        
                        
                    } else {
                        Text("second")
                    }
                }
            }.customNavBar(proxy: reader,
                           title: "Sessions", trailing:
                            Button(action: {
                                model.getEvents()
                            }, label: {
                                AnyView(Image("reload"))
                            }))
        }
    }
}

extension CalendarView {
    
    func decideData() -> [Event] {
        
        let day = Calendar.current.component(.weekday, from: Date())
        var hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        
        hour = hour - 12
        
        if hour < 0 {
            hour = 0
        }
        
        var time = "\(day)\(hour)\(minute)"
        
        if minute < 10 {
            time = "\(day)\(hour)0\(minute)"
        }
        
        print(time)
        var eventArray = [Event]()
        
        if upcomingSelected {
            
            for event in model.events {
                if event.time >= time {
                    eventArray.append(event)
                }
            }
            
        } else {
            
            for event in model.events {
                if event.time < time {
                    eventArray.append(event)
                }
            }
        }
        
        return eventArray
        
    }
    
    func getTutorObjectFor(teacher: String) -> Tutor {
        
        var funcTutor = Tutor(id: "", grade: nil, email: nil, bio: nil, awards: nil, strengths: nil, pronouns: nil, gradient: "watermelon-magenta", times: nil, classes: nil)
        
        for tutor in tutorsModel.tutors {
            
            if tutor.id == teacher {
                funcTutor = tutor
            }
            
        }
        
        return funcTutor
        
    }
    
    func getCompleteDate(date: String) -> String {
        
        let day = date[0]
        let time = date.substring(fromIndex: 1)
        
        var formattedDay = Calendar.current.weekdaySymbols[Int(day)! - 1]
        
        let todayInt = Calendar.current.component(.weekday, from: Date())
        if day == String(todayInt) {
            formattedDay = "Today"
        }
        
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
