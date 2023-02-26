class Feed
  class Activity
    attr_accessor :kind, :user_id, :user_name, :target_id, :secondary_id,
                  :subject, :happened_at

    def initialize(hash)
      hash.each do |key, value|
        set key.to_sym, value
      end
    end

    private

    def set(name, value)
      converted = case name
        when :kind  then value.to_sym
        when /_id$/ then value.to_i
        else value
      end

      send "#{name}=", converted
    end
  end

  def each_activity
    ActiveRecord::Base.connection.execute(activity_query).each do |row|
      yield Activity.new(row)
    end
  end

  private

  def activity_query
    <<-SQL
      (
        SELECT
          'comment'           AS kind,
          comments.user_id    AS user_id,
          users.name          AS user_name,
          solutions.id        AS target_id,
          tasks.id            AS secondary_id,
          'TODO'              AS subject,
          comments.created_at AS happened_at
        FROM comments
          LEFT JOIN users     ON comments.user_id = users.id
          LEFT JOIN solutions ON comments.solution_id = solutions.id
          LEFT JOIN tasks     ON solutions.task_id = tasks.id
      ) UNION (
        SELECT
          'solution'           AS kind,
          solutions.user_id    AS user_id,
          users.name           AS user_name,
          solutions.id         AS target_id,
          solutions.task_id    AS secondary_id,
          'TODO'               AS subject,
          solutions.updated_at AS happened_at
        FROM solutions
          LEFT JOIN users ON solutions.user_id = users.id
          LEFT JOIN tasks ON solutions.task_id = tasks.id
      )
      ORDER BY happened_at DESC
    SQL
  end
end
