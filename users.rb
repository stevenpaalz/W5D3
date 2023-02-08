require_relative "questions"
require_relative "replies"
require_relative "question_follows"
require_relative "question_likes"

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