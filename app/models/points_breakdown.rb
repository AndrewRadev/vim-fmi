class PointsBreakdown
  def self.dump(object) = JSON.dump(object.attributes)
  def self.load(value) = new(JSON.load(value))

  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
  end

  def total
    attributes.values.sum
  end

  def update(user)
    # Note: .sum(distinct points) distincts the points
    self.attributes['tasks'] = Task.where(id: user.completed_tasks).sum(:points)
    self.attributes['vouchers'] = user.vouchers.count
    self.attributes['photo'] = user.photo? ? 1 : 0
    self
  end

  def tasks
    attributes.fetch('tasks', 0)
  end

  def vouchers
    attributes.fetch('vouchers', 0)
  end

  def photo
    attributes.fetch('photo', 0)
  end
end
