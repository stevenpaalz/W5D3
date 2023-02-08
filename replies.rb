require_relative "questions"
require_relative "users"
require_relative "question_follows"
require_relative "question_likes"

class Replies

    attr_accessor :id, :subject_question, :parent_reply, :author_id, :body
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
            FROM replies
            WHERE author_id = ?
        SQL
        return nil unless reply.length > 0
        if reply.length == 1
            Replies.new(reply.first)
        else
            reply.map {|datum| Replies.new(datum)}
        end
    end

    def author
        author = QuestionsDatabase.instance.execute(<<-SQL, self.author_id)
        SELECT
            fname, lname
        FROM
            users
        WHERE
            id = ?
        SQL
        return nil unless author.length > 0
        return author.first['fname'] + " " + author.last['lname']
    end

    def question
        subject_question = QuestionsDatabase.instance.execute(<<-SQL, self.subject_question)
        SELECT 
            *
        FROM
            questions
        WHERE
            id = ?
        SQL
        return nil unless subject_question.length > 0
        Questions.new(subject_question.first)
    end

    def parent
        parent_reply = QuestionsDatabase.instance.execute(<<-SQL, self.parent_reply)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
        return nil unless parent_reply.length > 0
        return Replies.new(parent_reply.first)
    end

    def child_replies
        children = QuestionsDatabase.instance.execute(<<-SQL, self.id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply = ?
        SQL
        return nil unless children.length > 0
        if children.length == 1
            Replies.new(children.first)
        else
            children.map {|datum| Replies.new(datum)}
        end
    end
end