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

end

class Users
    attr_accessor :id, :fname, :lname
    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_name(fname, lname)
        name = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ? 
        SQL
        return nil unless name.length > 0
        Users.new(name.first)
    end

    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM users
            WHERE id = ?
        SQL
        return nil unless user.length > 0
        Users.new(user.first)
    end

    def authored_questions
        Questions.find_by_author_id(self.id)

    end

    def authored_replies
        Replies.find_by_user_id(self.id)
    end
end

class QuestionFollows

    def initialize(options)
        @user_id = options['user_id']
        @questions_id = options['questions_id']
    end
    

end

class Replies

    def initialize(options)
        @id = options['id']
        @subject_question = options['subject_question']
        @parent_reply  = options['parent_reply']
        @author_id = options['author_id']
        @body = options['body']
    end


    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM replies
            WHERE id = ?
        SQL
        return nil unless reply.length > 0
        Replies.new(reply.first)
    end

    def self.find_by_question(subject_question)
        reply = QuestionsDatabase.instance.execute(<<-SQL, subject_question)
            SELECT *
            FROM replies
            WHERE subject_question = ?
        SQL
        return nil unless reply.length > 0
        Replies.new(reply.first)
    end

    def self.find_by_user_id(author_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT *
            FROM questions
            WHERE author_id = ?
        SQL
        return nil unless reply.length > 0
        if reply.length == 1
            Replies.new(reply.first)
        else
            Replies.new(reply)
        end
    end

end

class QuestionsLikes

    def initialize(options)
        @id = options['id']
        @subject_question = options['subject_question']
        @liker_id = options['liker_id']
    end

    def self.find_by_id(id)
        like = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT *
            FROM question_likes
            WHERE id = ?
        SQL
        return nil unless like.length > 0
        QuestionsLikes.new(like.first)
    end
    
end