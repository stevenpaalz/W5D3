require 'sqlite3'
require 'singleton'
require_relative "users"
require_relative "replies"
require_relative "question_follows"
require_relative "question_likes"

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

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM questions
            WHERE id = ?
        SQL
        return nil unless question.length > 0
        Questions.new(*question)
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def self.find_by_author_id(author_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT *
            FROM questions
            WHERE author_id = ?
        SQL
        return nil unless question.length > 0
        if question.length == 1
            Questions.new(question.first)
        else
            question.map {|datum| Questions.new(datum)}
        end
    end

    def author
        author = QuestionsDatabase.instance.execute(<<-SQL, self.author_id)
            SELECT fname, lname
            FROM users
            WHERE id = ?
        SQL
        return nil unless author.length > 0
        return author.first['fname'] + " " + author.first['lname']
    end

    def replies
        reply = QuestionsDatabase.instance.execute(<<-SQL, self.id)
            SELECT
                *
            FROM
                replies
            WHERE
                subject_question = ?
        SQL
        return nil unless reply.length > 0
        if reply.length == 1
            return Replies.new(reply.first)
        else
            reply.map {|datum| Replies.new(datum)}
        end
    end

    

end