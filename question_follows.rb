require_relative "questions"
require_relative "replies"
require_relative "users"
require_relative "question_likes"

class QuestionFollows
    attr_accessor :user_id, :questions_id

    def initialize(options)
        @user_id = options['user_id']
        @questions_id = options['questions_id']
    end
    

end

