require_relative "questions"
require_relative "replies"
require_relative "question_follows"
require_relative "users"

class QuestionsLikes

    attr_accessor :id, :subject_question, :liker_id
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