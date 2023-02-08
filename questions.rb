require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton


    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end

end

class Questions
    attr_accessor :id, :title, :body, :author_id

    # def self.find_by_id(id)
    #     question = QuestionsDatabase.instance.execute(<<-SQL, id)
    #         SELECT * 
    #         FROM questions
    #         WHERE id = ?
    #     SQL
    #     return nil unless question.length > 0
    #     Questions.new(question)
    # end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

end

class Users

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

end

class QuestionFollows

    def initialize(options)
        @user_id = options['user_id']
    end

end

class Replies

    def initialize(options)
        
    end

end

class QuestionsLikes

    def initialize(options)
        
    end
end