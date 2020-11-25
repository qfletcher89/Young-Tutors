//
//  SessionView.swift
//  Young Tutors
//
//  Created by Kendall Easterly on 11/18/20.
//

import SwiftUI

struct SessionView: View {
    
    @State var calendarSelection = Calendar.current.component(.weekday, from: Date())
    @State var session = Session(id: "", day: "", time: "", tutors: [""])
    @State var isShowingTutors = false
    var course: Class
    var model = ClassModel()
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 15) {
//            Text("Your Session Info")
//                .font(.system(size: 28, weight: .bold, design: .rounded))
//                .centered()
//                .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Subject")
                    .opacity(0.5)
                
                Text(course.levels + " " + course.name.capitalized)
                
            }.font(.system(size: 22.4, weight: .bold, design: .rounded))
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Date")
                    .opacity(0.5)
                
                Text(Calendar.current.weekdaySymbols[self.calendarSelection - 1])
                
            }.font(.system(size: 22.4, weight: .bold, design: .rounded))
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Time")
                    .opacity(0.5)
                
                Text(session.time)
                
            }.font(.system(size: 22.4, weight: .bold, design: .rounded))
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Tutor")
                    .opacity(0.5)
                if session.tutors.first! != "" {
                    HStack {
                        
                        Button {
                            print("navigate to tutor view")
                        } label: {
                            Text(session.selectedTutor)
                                .foregroundColor(self.cs().watermelon)
                        }
                        
                        Spacer()
                        
                        if session.tutors.count != 1 {
                            Button {
                                withAnimation {
                                    self.isShowingTutors.toggle()
                                }
                            } label: {
                                Image("switch")
                            }
                        }
                    }
                }
                
                if session.tutors.count != 1 {
                    if isShowingTutors {
                        
                        ForEach(session.tutors, id: \.self) {tutor in
                            if tutor != session.selectedTutor {
                                HStack {
                                    Button {
                                        //navigate to bio
                                        
                                    } label: {
                                        Text(tutor)
                                            .foregroundColor(self.cs().watermelon)
                                            .padding(.vertical, 5)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        withAnimation {
                                            self.session.selectedTutor = tutor
                                            self.isShowingTutors = false
                                        }
                                    } label: {
                                        Image("check")
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }.font(.system(size: 22.4, weight: .bold, design: .rounded))
            
            Spacer()
            
            //selector
            VStack {
                
                VStack {
                    
                    Text(getMonthAndYear())
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollViewReader { reader in
                            
                            HStack {
                                
                                ForEach(getDaysInWeek()) {day in
                                    
                                    VStack {
                                        
                                        Text(day.weekday)
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                        
                                        Button {
                                            withAnimation {
                                                self.calendarSelection = day.dayOfWeek
                                            }
                                        } label: {
                                            Text(String(day.id))
                                                .foregroundColor(day.id < getDayNumber() ? Color.white.opacity(0.5) : .white )
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .background(Circle().frame(width: 28, height: 28)
                                                                .foregroundColor(calendarSelection == day.dayOfWeek ? self.cs().watermelon : .clear))
                                        }.padding(.vertical, 5)
                                    }.padding(.horizontal, 10)
                                    .disabled(day.id < getDayNumber())
                                }
                            }.onAppear {
                                reader.scrollTo(getDayNumber())
                            }
                        }
                    }.centered()
                    
                    Divider()
                        .padding(.vertical)
                    
                    if !getSessionsForSelectedDate().isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack {
                                
                                ForEach(getSessionsForSelectedDate()) {session in
                                    
                                    Button {
                                        withAnimation {
                                            self.session = session
                                        }
                                    } label: {
                                        if self.session.id == session.id {
                                            Text(session.time)
                                                .foregroundColor(.white)
                                                .padding(.vertical, 2)
                                                .padding(.horizontal, 10)
                                                .background(RoundedRectangle(cornerRadius: 30)
                                                                .foregroundColor(self.cs().watermelon))
                                        } else {
                                            Text(session.time)
                                                .foregroundColor(.white)
                                                .padding(.vertical, 2)
                                                .padding(.horizontal, 10)
                                                .background(RoundedRectangle(cornerRadius: 30)
                                                                .strokeBorder(lineWidth: 2)
                                                                .foregroundColor(self.cs().watermelon))
                                        }
                                    }.padding(.trailing, 5)
                                }
                            }
                        }.centered()
                    } else {
                        Text("Sorry, no sessions for this day.")
                            .italic()
                            .centered()
                            .padding(.vertical, 2)
                    }
                    
                }.padding()
                .background(RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(self.cs().black))
            }
            
            Spacer()
            
            Button {
                
                model.createSession(at: session.id, with: session.selectedTutor)
                
            } label: {
                Text("Confirm")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background(RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(self.cs().watermelon))
            }.centered()
            
            Spacer()
            
        }.background(self.cs().background)
        .navigationTitle(Text("Schedule a Session"))
        .padding()
    }
    
    func getMonthAndYear() -> String {
        
        let calendar = Calendar.current
        
        let monthNumber = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())
        var month = ""
        
        month = calendar.monthSymbols[monthNumber - 1]
        
        return "\(month) \(year)"
    }
    
    func getDaysInWeek() -> [Day] {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: Date())
        let month = calendar.component(.month, from: Date())
        let day = calendar.component(.day, from: Date())
        let weekDay = calendar.component(.weekday, from: Date()) - 1
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day - weekDay
        
        var daysArray = [Day]()
        
        for _ in 0..<7 {
            
            let date = calendar.date(from: components)
            
            let dayOfWeek = calendar.component(.weekday, from: date!)
            let dayOfWeekSymbol = calendar.shortWeekdaySymbols[dayOfWeek - 1]
            daysArray.append(Day(id: components.day!, weekday: dayOfWeekSymbol, dayOfWeek: dayOfWeek))
            
            components.day = components.day! + 1
        }
        
        return daysArray
    }
    
    func getSessionsForSelectedDate() -> [Session] {
        
        var sessionArray = [Session]()
        
        for session in course.sessions {
            
            if session.day == String(calendarSelection) {
                
                sessionArray.append(session)
                
            }
        }
        
        return sessionArray
        
    }
    
    func getDayNumber() -> Int {
        
        let calendar = Calendar.current
        let weekday = calendar.component(.day, from: Date())
        
        return weekday
        
    }
}

struct Day: Identifiable {
    
    //31st
    var id: Int
    //Thur
    var weekday: String
    //5
    var dayOfWeek: Int
    
}
