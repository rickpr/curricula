require 'curricula/version'
require 'spreadsheet'

module Curricula
  
  class Course
  
    attr_reader :name, :hours
    attr_accessor :prereqs
  
    def initialize name, hours
      @name = name
      @hours = hours
      @prereqs = [] 
    end

    def graph_edges
      prereqs.map{ |prereq| { source: prereq.name, destination: name } }
    end
  
  end
  
  class DegreePlan
  
    def initialize spreadsheet
      @spreadsheet = spreadsheet
      @courses = {}
    end
  
    def efficiency
      process_first!
      @efficiency
    end
  
    def course_list
      process_first!
      @course_hours
    end
  
    def course name
      process_first!
      @course_hours[name]
    end
  
    def graph_nodes
      @courses.each_value.map &:name
    end

    def graph_edges
      process_first!
      @courses.each_value.map(&:graph_edges).flatten(1).reject &:empty?
    end

    private
  
    def process
      build_courses
      all_hours = @courses.each_value.map &method(:course_hours)
      @course_hours = @courses.each_value.map(&:name).zip(all_hours).to_h
      @efficiency = all_hours.inject :+
    end
  
    def build_courses
      Spreadsheet.open(@spreadsheet).worksheets.first.each do |row|
        if row[1]
          @courses[row.last].prereqs << @courses[row.first]
        else
          @courses[row.first] = Course.new row.first, row.last
        end
      end rescue error :format
    end
  
    def course_hours course, visited = []
      raise :circular if visited.include? course
      visited << course
      course.hours + course.prereqs.map{ |prereq| course_hours(prereq, visited).to_i }.reduce(:+).to_i
    end
  
    def error name
      case name
      when :format
        raise "Check your spreadsheet format"
      when :circular
        raise "Prerequisites are circular. This degree plan makes no sense."
      else
        raise "Error #{name}"
      end
    end
  
    def process_first!
      @efficency ? true : process
    end
  
  end

end
